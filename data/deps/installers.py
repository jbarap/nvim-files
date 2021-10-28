import asyncio
import time

from asyncio.subprocess import PIPE
from os import cpu_count
from itertools import chain
from shutil import get_terminal_size
from typing import Dict

from deps import utils
from deps.constants import CONFIG_PATH
from deps.installables_spec import InstallablesSpec, Installable, PathSpec


def pip(installables: Dict[str, Installable], paths: PathSpec, limiter):

    packages = [inst['install_method']['name'] for inst in installables.values()]
    python_path = CONFIG_PATH / paths["base"] / paths["pip"] / "python3"

    print(f"pip: installing {packages}...")

    async def _pip():
        if not packages:
            return "pip", 0, (b"", b"")

        async with limiter:
            proc = await asyncio.create_subprocess_exec(
                python_path,
                "-m",
                "pip",
                "install",
                *packages,
                stdout=PIPE,
                stderr=PIPE,
            )
            std_out, std_err = await proc.communicate()
            returncode = await proc.wait()

            return "pip", returncode, (std_out, std_err)

    yield _pip()


def npm(limiter):

    async def _npm():
        async with limiter:
            proc = await asyncio.create_subprocess_exec(
                "sleep",
                "1"
            )
            returncode = await proc.wait()
            return "npm", proc, returncode

    yield _npm()


async def go():
    pass


async def github_releases():
    pass


async def github_repo():
    pass


async def run_installers(installables_data: InstallablesSpec):
    term_width = get_terminal_size().columns

    limiter = asyncio.Semaphore(cpu_count() or 1)

    pip_installables = utils.filter_by_installer(installables_data["installables"], "pip")

    for fut in asyncio.as_completed(chain(
        pip(pip_installables, installables_data["paths"], limiter),
    )):
        source, code, (std_out, std_err) = await fut
        std_out, std_err = std_out.decode(), std_err.decode()

        if code != 0:
            print(f"Error at source {source}: {std_out}, {std_err}")

        print("-" * term_width)
        print(f"method: {source} | returncode: {code} | stdout: {std_out}")
        print("-" * term_width)
