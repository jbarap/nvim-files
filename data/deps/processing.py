import asyncio
import os
import traceback
import zipfile

from asyncio.subprocess import PIPE
from contextlib import nullcontext
from pathlib import Path
from typing import (
    Any,
    Awaitable,
    Dict,
    Callable,
    List,
    Optional,
    Union,
)

from deps import utils
from deps.typing import TPathLike


class ReturncodeError(Exception):
    def __init__(self, msg):
        super().__init__(msg)


class EarlySuccess(Exception):
    def __init__(self, msg):
        super().__init__(msg)


class Context:
    def __init__(self, key: str):
        self.key = key

    def resolve(self, context: dict):
        return context[self.key]


# TODO: maybe implement hooks as python functions stored in a dict, where you specify
# the key to the function in the json. Hooks could then be specified as a Hook object
# passed to pipeline as a step. e.g.:
# pipeline(steps=[some_step, Hook('event1'), another_step], hooks={'event1': 'func_key'})
# the function with key 'func_key' would then be executed as a @pipeline_step, receiving
# context as a kwarg
async def pipeline(
    steps: List[Callable[..., Any]],
    name: str = "",
    task_limiter: Optional[Union[asyncio.Semaphore, nullcontext]] = None,
) -> bool:

    if task_limiter is None:
        task_limiter = nullcontext()

    context = {}
    success = True

    try:
        for step in steps:
            if asyncio.iscoroutinefunction(step):
                context = await step(_ctx=context)
            else:
                context = step(_ctx=context)
    except EarlySuccess:
        success = True
    except Exception:
        print(f"Error at pipeline {name}: {traceback.format_exc()}")
        success = False

    return success


def _resolve_context(args, kwargs, context):
    args = list(args)
    for i, arg in enumerate(args):
        if isinstance(arg, Context):
            args[i] = arg.resolve(context)

    for key, val in kwargs.items():
        if isinstance(val, Context):
            kwargs[key] = val.resolve(context)

    return args, kwargs


def pipeline_step(func: Callable[..., Any]) -> Callable[..., Any]:
    def usr_interface(
        *usr_args,
        **usr_kwargs
    ) -> Union[Callable[..., Any], Awaitable[Any]]:

        async def async_ready_for_pipeline(_ctx=None):
            nonlocal usr_args, usr_kwargs
            if _ctx is None:
                _ctx = {}

            usr_args, usr_kwargs = _resolve_context(usr_args, usr_kwargs, _ctx)
            await func(*usr_args, **usr_kwargs, _ctx=_ctx)
            return _ctx

        def sync_ready_for_pipeline(_ctx=None):
            nonlocal usr_args, usr_kwargs
            if _ctx is None:
                _ctx = {}

            usr_args, usr_kwargs = _resolve_context(usr_args, usr_kwargs, _ctx)
            func(*usr_args, **usr_kwargs, _ctx=_ctx)
            return _ctx

        if asyncio.iscoroutinefunction(func):
            ready_for_pipeline = async_ready_for_pipeline
        else:
            ready_for_pipeline = sync_ready_for_pipeline

        return ready_for_pipeline

    return usr_interface


@pipeline_step
async def call(
    cmd: Union[str, Path],
    *cmd_args: Union[str, Path],
    cwd: Optional[TPathLike] = None,
    env: Optional[Dict] = None,
    stdin=None,
    stdout=None,
    stderr=None,
    check_returncode=True,
    **kwargs,
) -> None:

    proc = await asyncio.create_subprocess_exec(
        cmd,
        *cmd_args,
        cwd=cwd,
        env={
            **os.environ,
            **(env or {}),
        },
        stdin=stdin if stdin else PIPE,
        stdout=stdout if stdout else PIPE,
        stderr=stderr if stderr else PIPE,
    )

    std_out, std_err = await proc.communicate()
    returncode = await proc.wait()

    kwargs['_ctx']['stdout'] = std_out
    kwargs['_ctx']['sterr'] = std_err
    kwargs['_ctx']['returncode'] = returncode

    if check_returncode:
        if returncode != 0:
            msg = f"Process {cmd} {cmd_args} exited with returncode {returncode}. "
            msg = msg + f"stdout: {std_out}. stderr: {std_err}"
            raise ReturncodeError(msg)


@pipeline_step
def stop_if_executable(exec_path: Union[str, Path], **kwargs):
    # FIXME: check TypeVar
    if utils.is_exec(exec_path):  # type: ignore
        raise EarlySuccess(f"Executable {exec_path} found")


@pipeline_step
def assert_path(path: TPathLike, **kwargs):
    Path(path).mkdir(parents=True, exist_ok=True)


# TODO: support .gz, .tar.gz
@pipeline_step
def unzip_file(
    file_path: Union[str, Path],
    extraction_path: Optional[Union[str, Path]],
    **kwargs,
):
    if zipfile.is_zipfile(file_path):
        with zipfile.ZipFile(file_path) as f:
            f.extractall(path=extraction_path)
        os.remove(file_path)


@pipeline_step
def make_executable(file_path: Union[str, Path], **kwargs):
    if not utils.is_exec(file_path):  # type: ignore
        os.chmod(file_path, 0o775)
