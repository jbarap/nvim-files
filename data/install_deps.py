#!/usr/bin/env python3

"""Dependency installer, a la https://github.com/cyproterone/nvim2"""

import json
import venv
from argparse import ArgumentParser, Namespace

from deps import utils
from deps import constants as const
from deps.installables_spec import InstallablesSpec


with open(const.JSON_PATH) as f:
    installables_data: InstallablesSpec = json.load(f)
    installables_data = utils.resolve_parameters(installables_data)


def main(args: Namespace):
    if args.command == 'setup':
        utils.assert_requirements(installables_data['requirements'])

        # check for python venv
        if not utils.is_exec(const.PYTHON_VENV_PATH / "bin" / "python"):
            print("Python venv not found, creating...")
            env_builder = venv.EnvBuilder(with_pip=True)
            env_builder.create(const.PYTHON_VENV_PATH / "python")
        else:
            print("Python venv found")

    elif args.command == 'install':
        print("Installing executables")

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

