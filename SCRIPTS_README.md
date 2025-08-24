Dev Scripts – Quickstart

Use these helper scripts to keep your environment reproducible and your workflow clean. Run them in Git Bash from the repo root.

How you’ll use them

First time (or when you pull fresh):

./scripts/dev_bootstrap.sh


Each new session:

source ./scripts/venv.sh


Before pushing:

./scripts/qa.sh

What they do

dev_bootstrap.sh – Creates/refreshes the virtualenv, installs requirements, sets up pre-commit, registers a Jupyter kernel, and runs a smoke test with pytest.

venv.sh – Activates the virtualenv (works on Windows Git Bash and Linux/Mac).

qa.sh – Lints (Ruff), formats (Black), and runs tests (pytest).

Tip: If a script isn’t executable, run chmod +x scripts/*.sh once.
