#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

# Create venv if missing
python -m venv .venv

# Pick venv python (Windows Git Bash vs Linux/Mac)
if [[ -f ".venv/Scripts/python.exe" ]]; then
  VENV_PY=".venv/Scripts/python"
else
  VENV_PY=".venv/bin/python"
fi

"$VENV_PY" -m pip install --upgrade pip
"$VENV_PY" -m pip install -r requirements.txt pre-commit
"$VENV_PY" -m pre_commit install
"$VENV_PY" -m ipykernel install --user --name=python_de_learning_2025

# Smoke test (non-fatal)
"$VENV_PY" -m pytest -q || true

echo "✅ Dev bootstrap complete."
