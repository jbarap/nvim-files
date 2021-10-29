import asyncio

from asyncio.subprocess import PIPE
from os import cpu_count, environ
from itertools import chain
from shutil import get_terminal_size
from typing import Dict

from deps import utils, paths
from deps.typing import InstallablesSpec, Installable


def pip(installables: Dict[str, Installable], limiter):
    packages = [inst['install_info']['name'] for inst in installables.values()]
    print(f"pip: installing {packages}...")

    async def _pip():
        if not packages:
            return 'pip', 0, (b"", b"")

        async with limiter:
            proc = await asyncio.create_subprocess_exec(
                paths.PYTHON,
                '-m',
                'pip',
                'install',
                *packages,
                cwd=paths.PYTHON_BASE,
                stdout=PIPE,
                stderr=PIPE,
            )
            std_out, std_err = await proc.communicate()
            returncode = await proc.wait()

            return 'pip', returncode, (std_out, std_err)

    yield _pip()


def npm(installables: Dict[str, Installable], limiter):
    packages = [inst['install_info']['name'] for inst in installables.values()]
    print(f"npm: installing {packages}...")

    async def _npm():
        if not packages:
            return 'npm', 0, (b"", b"")

        async with limiter:
            proc = await asyncio.create_subprocess_exec(
                'npm',
                'install',
                *packages,
                cwd=paths.NPM_BASE,
                stdout=PIPE,
                stderr=PIPE,
            )
            std_out, std_err = await proc.communicate()
            returncode = await proc.wait()

            return 'npm', returncode, (std_out, std_err)

    yield _npm()


def go(installables: Dict[str, Installable], limiter):
    packages = [inst['install_info']['name'] for inst in installables.values()]
    packages = ["golang.org/x/tools/gopls"]  # for testing purposes
    print(f"go: installing {packages}...")

    async def _go():
        if not packages:
            return 'go', 0, (b"", b"")

        async with limiter:
            proc = await asyncio.create_subprocess_exec(
                'go',
                'get',
                *packages,
                cwd=paths.GO_BASE,
                env={
                    **environ,
                    'GO111MODULE': 'on',
                    'GOPATH': paths.GO_BASE,
                    'GOBIN': paths.GO_BINS,
                },
                stdout=PIPE,
                stderr=PIPE,
            )
            std_out, std_err = await proc.communicate()
            returncode = await proc.wait()

            return 'go', returncode, (std_out, std_err)

    yield _go()


def github_releases():
    pass


def github_repo():
    pass


async def run_installers(installables_data: InstallablesSpec):
    term_width = get_terminal_size().columns
    limiter = asyncio.Semaphore(cpu_count() or 1)

    installables = utils.lookup_by_installer(installables_data['installables'])

    for fut in asyncio.as_completed(chain(
        pip(installables.get('pip', {}), limiter),
        npm(installables.get('npm', {}), limiter),
        go(installables.get('go', {}), limiter),
    )):
        source, code, (std_out, std_err) = await fut
        std_out, std_err = std_out.decode(), std_err.decode()

        if code != 0:
            print(f"Error at source {source}: {std_out}, {std_err}")

        print("-" * term_width)
        print(f"method: {source} | returncode: {code} | stdout: {std_out}")
        print("-" * term_width)
