import asyncio
import json
import os
import re
import zipfile

from asyncio.subprocess import PIPE
from itertools import chain
from shutil import get_terminal_size
from typing import Awaitable, Dict, Iterable

from deps import utils, paths
from deps.typing import InstallablesSpec, Installable

# TODO: refactor a lot of things:
#       - the install methods that handle packages use almost the same logic
#       - the github_releases function does too much and repeats a lot of code


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
                    **os.environ,
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


def github_releases(installables: Dict[str, Installable], limiter) -> Iterable[Awaitable]:
    if installables == {}:
        return []

    async def _github_releases(installable_name, installable):
        install_path = paths.GITHUB_RELEASES_BASE / installable_name
        install_path.mkdir(exist_ok=True)

        bin_path = str(install_path / installable['cmd'][0])
        if utils.is_exec(bin_path):
            return 'github_releases', 0, (b"", b"")

        install_info = installable['install_info']
        repo_owner, repo_name, pattern = install_info['name'].split('/')
        pattern = f".*{pattern}.*"

        async with limiter:
            # fetch assets
            proc = await asyncio.create_subprocess_exec(
                'curl',
                '-H',
                '--fail',
                '"Accept: application/vnd.github.v3+json"',
                f'https://api.github.com/repos/{repo_owner}/{repo_name}/releases/latest',
                cwd=install_path,
                stdout=PIPE,
                stderr=PIPE,
            )
            std_out, std_err = await proc.communicate()
            returncode = await proc.wait()

            if returncode != 0:
                return 'github_releases', returncode, (std_out, std_err)

            # parse to find the desired asset
            parsed = json.loads(std_out.decode())
            target_asset = [a for a in parsed['assets'] if re.match(pattern, a['name'])]

            if len(target_asset) == 0:
                error_msg = f"No asset matched pattern {pattern} in repo {repo_name}"
                return 'github_releases', 420, (b"", error_msg.encode())

            target_name = target_asset[0]['name']
            target_download_link = target_asset[0]['browser_download_url']

            # downloading
            proc = await asyncio.create_subprocess_exec(
                'curl',
                '-LO',
                target_download_link,
                cwd=install_path,
                stdout=PIPE,
                stderr=PIPE,
            )
            std_out, std_err = await proc.communicate()
            returncode = await proc.wait()

            # if it's a zip, extract it
            if zipfile.is_zipfile(install_path / target_name):
                with zipfile.ZipFile(install_path / target_name) as f:
                    f.extractall(path=install_path)
                os.remove(install_path / target_name)

            # make the file executable
            if not utils.is_exec(bin_path):
                os.chmod(bin_path, 0o775)

            return 'github_releases', returncode, (std_out, std_err)

    for inst_name, inst_val in installables.items():
        print(f"github_releases: installing {inst_name}...")
        yield _github_releases(inst_name, inst_val)


def github_repo():
    pass


async def run_installers(installables_data: InstallablesSpec):
    term_width = get_terminal_size().columns
    limiter = asyncio.Semaphore(os.cpu_count() or 1)

    installables = utils.lookup_by_installer(installables_data['installables'])

    for fut in asyncio.as_completed(chain(
        pip(installables.get('pip', {}), limiter),
        npm(installables.get('npm', {}), limiter),
        go(installables.get('go', {}), limiter),
        github_releases(installables.get('github_releases', {}), limiter)
    )):
        source, code, (std_out, std_err) = await fut
        std_out, std_err = std_out.decode(), std_err.decode()

        if code != 0:
            print(f"Error at source {source}: {std_out}, {std_err}")

        print("-" * term_width)
        print(f"{source}: returncode {code}")
        print("-" * term_width)
