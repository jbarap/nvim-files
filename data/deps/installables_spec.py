from typing import Dict, List, Literal, TypedDict, Union


# requirements
class RequirementsSpec(TypedDict):
    required: List[Union[str, List[str]]]
    optional: List[Union[str, List[str]]]


# paths
class PathSpec(TypedDict):
    base: str
    go: str
    pip: str
    npm: str
    github_repo: str
    github_releases: str


# installable components with params
class OSParam(TypedDict):
    windows: str
    linux: str
    mac: str


class Parameterized(TypedDict):
    with_params: str
    os_param: OSParam


Parameterizable = Union[str, Parameterized]


class ParamInstallMethod(TypedDict):
    method: Literal['go', 'pip', 'npm', 'github_repo', 'github_releases']
    name: Parameterizable
    version: Parameterizable


class ParamInstallable(TypedDict):
    cmd: List[Parameterizable]
    install_method: ParamInstallMethod


# installable components without params
class InstallMethod(TypedDict):
    method: Literal['go', 'pip', 'npm', 'github_repo', 'github_releases']
    name: str
    version: str


class Installable(TypedDict):
    cmd: List[str]
    install_method: InstallMethod


# final spec with params
class ParamInstallablesSpec(TypedDict):
    paths: PathSpec
    requirements: RequirementsSpec
    installables: Dict[str, ParamInstallable]


# final spec
class InstallablesSpec(TypedDict):
    paths: PathSpec
    requirements: RequirementsSpec
    installables: Dict[str, Installable]

