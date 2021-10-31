from pathlib import Path
from typing import Dict, List, Literal, TypedDict, Union, TypeVar


TPathLike = TypeVar('TPathLike', str, Path)


# requirements
class RequirementsSpec(TypedDict):
    required: List[Union[str, List[str]]]
    optional: List[Union[str, List[str]]]


# installable components
InstallMethod = Literal['go', 'pip', 'npm', 'github_repo', 'github_releases']


# with params
class OSParam(TypedDict):
    windows: str
    linux: str
    mac: str


class Parameterized(TypedDict):
    with_params: str
    os_param: OSParam


Parameterizable = Union[str, Parameterized]


class ParamInstallInfo(TypedDict):
    method: InstallMethod
    name: Parameterizable
    version: Parameterizable


class ParamInstallable(TypedDict):
    cmd: List[Parameterizable]
    install_info: ParamInstallInfo


# without params
class InstallInfo(TypedDict):
    method: InstallMethod
    name: str
    version: str


class Installable(TypedDict):
    cmd: List[str]
    install_info: InstallInfo


# paths
class PathSpec(TypedDict):
    base: Dict[str, str]
    bins: Dict[InstallMethod, str]


# final spec with params
class ParamInstallablesSpec(TypedDict):
    requirements: RequirementsSpec
    installables: Dict[str, ParamInstallable]
    paths: PathSpec


# final spec
class InstallablesSpec(TypedDict):
    requirements: RequirementsSpec
    installables: Dict[str, Installable]
    paths: PathSpec

