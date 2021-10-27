import os
import sys
import shutil
from pathlib import Path
from typing import List, Union, TypeVar

from deps.installables_spec import InstallablesSpec, Requirements


TPathLike = TypeVar('TPathLike', str, Path)


def is_exec(path: Union[TPathLike, List[TPathLike]]) -> bool:
    """Check if a path is an executable.

    If a list is given, the elements of the list will be taken as aliases.
    """
    executable = False
    if isinstance(path, list):
        for p in path:
            executable = executable or bool(shutil.which(p, mode=os.X_OK))
    else:
        executable = bool(shutil.which(path, mode=os.X_OK))

    return executable


def assert_requirements(requirements: Requirements) -> None:
    for r in requirements['required']:
        if not is_exec(r):
            raise Exception(f"Required executable '{r}' not found")

    for r in requirements['optional']:
        if not is_exec(r):
            print(f"Optional executable '{r}' not found")


def resolve_parameters(data: InstallablesSpec) -> InstallablesSpec:
    data = data.copy()

    platform_dict = {
        'linux': 'linux',
        'win32': 'windows',
        'darwin': 'mac',
    }
    platform = platform_dict[sys.platform]

    def _resolve(_data):

        if isinstance(_data, list):
            for i, value in enumerate(_data):
                _data[i] = _resolve(value)

        elif isinstance(_data, dict):
            if "with_params" in _data:
                return _data["with_params"].replace(
                    "{os_param}",
                    _data["os_param"][platform]
                )

            else:
                for key, value in _data.items():
                    _data[key] = _resolve(value)

        return _data

    return _resolve(data)

