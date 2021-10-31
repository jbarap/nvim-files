import asyncio
import json
import os
import re

from itertools import chain
from typing import Awaitable, Dict, Iterable, Optional, Tuple

import deps.processing as prc
from deps import utils, paths
from deps.typing import InstallablesSpec, Installable


def pip(
    installables: Dict[str, Installable],
    task_limiter: Optional[asyncio.Semaphore]
) -> Iterable[Awaitable[Tuple[str, bool]]]:

    packages = [inst['install_info']['name'] for inst in installables.values()]
    print(f"pip: installing {packages}...")

    async def _pip():
        if not packages:
            return "pip", True

        success = await prc.pipeline(
            [
                prc.call(
                    paths.PYTHON,
                    '-m',
                    'pip',
                    'install',
                    *packages,
                    cwd=paths.PYTHON_BASE,
                ),
            ],
            name="pip",
            task_limiter=task_limiter,
        )

        return 'pip', success

    yield _pip()


def npm(
    installables: Dict[str, Installable],
    task_limiter: Optional[asyncio.Semaphore]
) -> Iterable[Awaitable[Tuple[str, bool]]]:

    packages = [inst['install_info']['name'] for inst in installables.values()]
    print(f"npm: installing {packages}...")

    async def _npm():
        if not packages:
            return 'npm', True

        success = await prc.pipeline(
            [
                prc.call(
                    'npm',
                    'install',
                    *packages,
                    cwd=paths.NPM_BASE,
                )
            ],
            name='npm',
            task_limiter=task_limiter,
        )

        return 'npm', success

    yield _npm()


def go(
    installables: Dict[str, Installable],
    task_limiter: Optional[asyncio.Semaphore]
) -> Iterable[Awaitable[Tuple[str, bool]]]:

    packages = [inst['install_info']['name'] for inst in installables.values()]
    print(f"go: installing {packages}...")

    async def _go():
        if not packages:
            return 'go', True

        success = await prc.pipeline(
            [
                prc.call(
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
                )
            ],
            name='go',
            task_limiter=task_limiter,
        )

        return 'go', success

    yield _go()


def github_releases(
    installables: Dict[str, Installable],
    task_limiter: Optional[asyncio.Semaphore]
) -> Iterable[Awaitable[Tuple[str, bool]]]:

    if installables == {}:
        return []

    # custom pipeline step to parse curl response
    @prc.pipeline_step
    def parse_for_target_asset(
        process_stdout,
        pattern,
        base_path,
        **kwargs
    ):
        if isinstance(process_stdout, bytes):
            process_stdout = process_stdout.decode()

        parsed = json.loads(process_stdout)
        target_asset = [a for a in parsed['assets'] if re.match(pattern, a['name'])]

        if len(target_asset) == 0:
            raise Exception(f"No asset matched pattern {pattern}")

        _ctx = kwargs['_ctx']
        _ctx['target_asset_name'] = target_asset[0]['name']
        _ctx['target_asset_link'] = target_asset[0]['browser_download_url']
        _ctx['target_asset_path'] = base_path / _ctx['target_asset_name']

    # main function
    async def _github_releases(installable_name, installable):
        # paths
        install_path = paths.GITHUB_RELEASES_BASE / installable_name
        bin_path = str(install_path / installable['cmd'][0])

        install_info = installable['install_info']
        repo_owner, repo_name, pattern = install_info['name'].split('/')
        pattern = f".*{pattern}.*"

        success = await prc.pipeline(
            [
                prc.stop_if_executable(bin_path),
                prc.assert_path(install_path),
                # fetch assets
                prc.call(
                    'curl',
                    '-H',
                    '--fail',
                    '"Accept: application/vnd.github.v3+json"',
                    f'https://api.github.com/repos/{repo_owner}/{repo_name}/releases/latest',
                    cwd=install_path,
                ),
                # parse to find the target asset
                parse_for_target_asset(prc.Context('stdout'), pattern, install_path),
                # download the file
                prc.call(
                    'curl',
                    '-LO',
                    prc.Context('target_asset_link'),
                    cwd=install_path,
                ),
                prc.unzip_file(prc.Context('target_asset_path'), install_path),
                prc.make_executable(bin_path),
            ],
            name=f"github_releases ({installable_name})",
            task_limiter=task_limiter,
        )

        return f'github_releases ({installable_name})', success

    for inst_name, inst_val in installables.items():
        print(f"github_releases: installing {inst_name}...")
        yield _github_releases(inst_name, inst_val)


def github_repo():
    pass


def rust():
    pass


async def run_installers(installables_data: InstallablesSpec):
    max_tasks = os.cpu_count() or 1
    task_limiter = asyncio.Semaphore(max(max_tasks - 1, 1))

    installables = utils.lookup_by_installer(installables_data['installables'])

    for fut in asyncio.as_completed(chain(
        pip(installables.get('pip', {}), task_limiter),
        npm(installables.get('npm', {}), task_limiter),
        go(installables.get('go', {}), task_limiter),
        github_releases(installables.get('github_releases', {}), task_limiter)
    )):
        source, success = await fut

        utils.box_print(f"{source} - success: {success}")
