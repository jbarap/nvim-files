import json

from pathlib import Path

from deps.typing import ParamInstallablesSpec, PathSpec


# fixed paths
CONFIG = Path(__file__).resolve().parent.parent.parent
JSON = CONFIG / "data" / "installables.json"

# paths inferred from the json file
with open(JSON) as f:
    param_installables_data: ParamInstallablesSpec = json.load(f)
    paths: PathSpec = param_installables_data['paths']

INSTALLABLES = CONFIG / paths['base']['installables']

PYTHON_BASE = INSTALLABLES / paths['base']['pip']
PYTHON_BINS = INSTALLABLES / paths['bins']['pip']
PYTHON = PYTHON_BINS / "python3"

GO_BASE = INSTALLABLES / paths['base']['go']
GO_BINS = INSTALLABLES / paths['bins']['go']

NPM_BASE = INSTALLABLES / paths['base']['npm']
NPM_BINS = INSTALLABLES / paths['bins']['npm']

GITHUB_RELEASES_BASE = INSTALLABLES / paths['base']['github_releases']
GITHUB_RELEASES_BINS = INSTALLABLES / paths['bins']['github_releases']
