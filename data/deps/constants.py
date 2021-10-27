from pathlib import Path


DATA_PATH = Path(__file__).resolve().parent.parent
JSON_PATH = DATA_PATH / "installables.json"
INSTALLABLES_PATH = DATA_PATH / "installables"

PYTHON_VENV_PATH = INSTALLABLES_PATH / "python"
