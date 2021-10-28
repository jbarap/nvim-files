#!/usr/bin/env python3

"""Dependency installer, a la https://github.com/cyproterone/nvim2"""

import json
import venv
from argparse import ArgumentParser, Namespace
from asyncio import run

from deps import utils
from deps.installers import run_installers
from deps.constants import CONFIG_PATH, JSON_PATH
from deps.installables_spec import ParamInstallablesSpec


with open(JSON_PATH) as f:
    param_installables_data: ParamInstallablesSpec = json.load(f)

installables_data = utils.resolve_parameters(param_installables_data)
paths = installables_data['paths']
INSTALLABLES_PATH = CONFIG_PATH / paths['base']


def main(args: Namespace):
    if args.command == 'setup':
        print("Checking required executables...")
        utils.assert_requirements(installables_data['requirements'])

        print("Creating directories...")
        utils.assert_paths(paths, base_path=INSTALLABLES_PATH)

        print("Python venv: ", end="")
        if not utils.is_exec(INSTALLABLES_PATH / paths['pip'] / "python3"):
            print("Creating...")
            env_builder = venv.EnvBuilder(with_pip=True)
            env_builder.create(INSTALLABLES_PATH / "python")
        else:
            print("Found!")

    elif args.command == 'install':
        print("Installing: ", [i for i in installables_data["installables"]])
        run(run_installers(installables_data))

    else:
        print("Use a supported command, run ./data/install_deps.py --help")


if __name__ == '__main__':
    arg_parser = ArgumentParser()

    subparsers = arg_parser.add_subparsers(dest="command")

    subparsers.add_parser("setup")
    subparsers.add_parser("install")
    subparsers.add_parser("update")

    args = arg_parser.parse_args()

    main(args)

