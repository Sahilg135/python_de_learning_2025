#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -f ".venv/Scripts/python.exe" ]]; then
  VENV_PY=".venv/Scripts/python"
else
  VENV_PY=".venv/bin/python"
fi

"$VENV_PY" -m ruff --fix .
"$VENV_PY" -m black .
"$VENV_PY" -m pytest -q
