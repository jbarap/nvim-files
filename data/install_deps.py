#!/usr/bin/env python3

"""
Dependency installer.

A la https://github.com/cyproterone/nvim2
and https://github.com/williamboman/nvim-lsp-installer
"""

import json
import venv
from argparse import ArgumentParser, Namespace
from asyncio import run

from deps import utils, paths
from deps.installers import run_installers
from deps.typing import ParamInstallablesSpec


# read, resolve, and save the json file
with open(paths.JSON) as f:
    param_installables_data: ParamInstallablesSpec = json.load(f)

installables_data = utils.resolve_parameters(param_installables_data)

with open(paths.JSON.with_name("installables_resolved.json"), 'w') as f:
    json.dump(installables_data, f)


def main(args: Namespace):
    if args.command == 'setup':
        print("Checking required executables...")
        utils.assert_requirements(installables_data['requirements'])

        print("Creating directories...")
        utils.assert_paths(
            installables_data['paths']['bins'].values(),  # type: ignore
            base_path=paths.INSTALLABLES
        )

        print("Python venv: ", end="")
        if not utils.is_exec(paths.PYTHON):
            print("Creating...")
            env_builder = venv.EnvBuilder(with_pip=True)
            env_builder.create(paths.PYTHON_BASE)
        else:
            print("Found!")

    elif args.command == 'install':
        run(run_installers(installables_data))

    else:
        print("Use a supported command, run ./data/install_deps.py --help")


if __name__ == '__main__':
    arg_parser = ArgumentParser()

    subparsers = arg_parser.add_subparsers(dest='command')

    subparsers.add_parser('setup')
    subparsers.add_parser('install')
    subparsers.add_parser('update')

    args = arg_parser.parse_args()

    main(args)
