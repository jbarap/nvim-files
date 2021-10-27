from typing import Dict, List, Literal, TypedDict, Union


# paths
class PathSpec(TypedDict):
    base: str
    go: str
    pip: str
    npm: str
    github_repo: str
    github_releases: str


# params
class OSParam(TypedDict):
    windows: str
    linux: str
    mac: str


class Parameterized(TypedDict):
    with_params: str
    os_param: OSParam


Parameterizable = Union[str, Parameterized]


# installables
class InstallMethod(TypedDict):
    method: Literal['go', 'pip', 'npm', 'github_repo', 'github_releases']
    name: Parameterizable
    version: Parameterizable


class Installable(TypedDict):
    cmd: List[Parameterizable]
    install_method: InstallMethod


# requirements
class Requirements(TypedDict):
    required: List[Union[str, List[str]]]
    optional: List[Union[str, List[str]]]


# final spec
class InstallablesSpec(TypedDict):
    paths: PathSpec
    installables: Dict[str, Installable]
    requirements: Requirements

