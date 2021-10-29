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

PYTHON_BASE = INSTALLABLES / paths['install_methods']['pip']
PYTHON_BINS = PYTHON_BASE / "bin"
PYTHON = PYTHON_BINS / "python3"

GO_BASE = INSTALLABLES / paths['install_methods']['go']
GO_BINS = GO_BASE / "bin"

NPM_BASE = INSTALLABLES / paths['install_methods']['npm']
NPM_BINS = NPM_BASE / "node_modules" / ".bin"
