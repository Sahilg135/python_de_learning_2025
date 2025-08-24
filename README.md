# python_de_learning_2025

Purpose: Senior Data Engineer–style Python practice (scripts, packages, tests, and notebooks) with **one clean workflow**: local VS Code → Git → GitHub.

## Quickstart (Windows/PowerShell)
```powershell
# 1) Clone or create repo then run from repo root
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
pre-commit install
python -m ipykernel install --user --name=python_de_learning_2025

# Run tests
pytest -q

# Open Jupyter in VS Code or run notebooks
jupyter notebook
```
## Layout
```
.
├─ src/                # Your reusable code (importable as `sahil_py`)
├─ notebooks/          # Exploration; keep light, pair with code in src/
├─ tests/              # Pytest unit tests
├─ data/               # .gitkeep only (no big files in git)
├─ scripts/            # Small CLIs (ETL tasks, utilities)
├─ .pre-commit-config.yaml
├─ requirements.txt
└─ README.md
```

## Conventions
- Black + Ruff on save (pre-commit ensures it).
- Type hints, docstrings, logging.
- Notebook results -> refactor to `src/` and add tests.
- Commit style: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`.
