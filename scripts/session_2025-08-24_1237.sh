#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
git init
git branch -m main
git config user.name "Sahil Gundu"
git config user.email "sahil.gundu@gmail.com"
for d in data ddl dml docs queries utils; do echo > "$d/.gitkeep"; done
# Windows noise
Thumbs.db
Desktop.ini
# Editors
/.vscode/
/.dbeaver/
# Logs / temp
*.log
*.tmp
~$*
[200~# (Windows line-endings hygiene)
git config core.autocrlf true
# 2) Create standard folders and placeholder files
mkdir -p data ddl dml docs queries utils
for d in data ddl dml docs queries utils; do touch "$d/.gitkeep"; done
# 3) Create a proper .gitignore file
cat > .gitignore <<'EOF'
# Windows noise
Thumbs.db
Desktop.ini
# Editors
.vscode/
.dbeaver/
# Logs / temp
*.log
*~
*.tmp
.DS_Store
EOF
# 4) Stage and commit
git add .gitignore data ddl dml docs queries utils
git commit -m "chore: scaffold repo with .gitignore and placeholders"
# 5) (Optional) connect to GitHub remote and push
# Replace URL with your repo
git remote add origin https://github.com/Sahilg135/sql_de_lab.git
git push -u origin main
cd "C:\Users\hp\Git\sql_de_learning_2025"
git remote -v  
git branch --show-current  
git fetch origin
git pull --rebase origin main
git status  
mkdir -p datasets/raw/csv
clear
cd "/c/Users/hp/Git/sql_de_learning_2025"
# 1) Create canonical SQL subfolders
mkdir -p sql/00_datasets_details          sql/01_basic_sql          sql/02_intermediate_sql_part1          sql/03_intermediate_sql_part2_joins          sql/04_intermediate_sql_part3_joins          sql/05_advanced_sql
# 2) Move & rename your current files into the folders (case-insensitive)
shopt -s nocaseglob
mv -f sql/Datasets_details*                 sql/00_datasets_details/datasets_details.sql
mv -f sql/Basic_SQL*                        sql/01_basic_sql/basic_sql.sql
mv -f sql/Intermediate_SQL_part1*           sql/02_intermediate_sql_part1/intermediate_sql_part1.sql
mv -f sql/Intermediate_SQL_part2_JOINS*     sql/03_intermediate_sql_part2_joins/intermediate_sql_part2_joins.sql
mv -f sql/Intermediate_SQL_part3_JOINS*     sql/04_intermediate_sql_part3_joins/intermediate_sql_part3_joins.sql
mv -f sql/Advance_SQL*                      sql/05_advanced_sql/advanced_sql.sql
shopt -u nocaseglob
# 3) (Optional) remove the old placeholder if it's now useless
rm -f sql/.gitkeep 2>/dev/null
# 4) Add deps.yaml placeholders (we’ll fill them after push)
for d in 00_datasets_details 01_basic_sql 02_intermediate_sql_part1 03_intermediate_sql_part2_joins 04_intermediate_sql_part3_joins 05_advanced_sql; do   printf "datasets:\n" > "sql/$d/deps.yaml"; done
# 5) Commit & push
git add -A
git commit -m "chore(sql): organize into subfolders, rename to snake_case, add deps.yaml placeholders"
git push
clear
cd "/c/Users/hp/Git/sql_de_learning_2025"
git add sql/*/deps.yaml
git commit -m "chore(sql): add deps.yaml for all modules"
git push
cd "/c/Users/hp/Git/sql_de_learning_2025"
git fetch origin
git pull --rebase origin main
# (Run your rename/normalize loop here — safe if already normalized)
# ensure stable line-endings (create once if missing)
[ -f .gitattributes ] || printf '* text=auto\n*.sql text eol=lf\n*.csv text eol=lf\n' > .gitattributes
# commit & push the CSVs
git add datasets/raw/csv .gitattributes
git commit -m "chore(datasets): add 10 CSVs under datasets/raw/csv"
git push -u origin main
git check-ignore -v datasets/raw/csv/*
git add -f datasets/raw/csv
git commit -m "data: add 10 CSVs to datasets/raw/csv"
git push -u origin main
cd "/c/Users/hp/Git/sql_de_learning_2025"
git pull --rebase origin main
# delete from repo and disk (safe even if empty)
if [ -d datasets/processed ]; then   git rm -r datasets/processed;   git commit -m "chore(datasets): remove unused processed folder";   git push; fi
mkdir -p datasets/catalog
cat > datasets/catalog/datasets_catalog.yaml << 'YAML'
tutorial_us_housing_units:
file: datasets/raw/csv/tutorial_us_housing_units.csv
schema: tutorial
table: us_housing_units
tutorial_billboard_top_100_year_end:
file: datasets/raw/csv/tutorial_billboard_top_100_year_end.csv
schema: tutorial
table: billboard_top_100_year_end
tutorial_aapl_historical_stock_price:
file: datasets/raw/csv/tutorial_aapl_historical_stock_price.csv
schema: tutorial
table: aapl_historical_stock_price
tutorial_crunchbase_acquisitions:
file: datasets/raw/csv/tutorial_crunchbase_acquisitions.csv
schema: tutorial
table: crunchbase_acquisitions
tutorial_crunchbase_companies:
file: datasets/raw/csv/tutorial_crunchbase_companies.csv
schema: tutorial
table: crunchbase_companies
tutorial_crunchbase_investments:
file: datasets/raw/csv/tutorial_crunchbase_investments.csv
schema: tutorial
table: crunchbase_investments
tutorial_crunchbase_investments_part1:
file: datasets/raw/csv/tutorial_crunchbase_investments_part1.csv
schema: tutorial
table: crunchbase_investments_part1
tutorial_crunchbase_investments_part2:
file: datasets/raw/csv/tutorial_crunchbase_investments_part2.csv
schema: tutorial
table: crunchbase_investments_part2
benn_college_football_players:
file: datasets/raw/csv/benn_college_football_players.csv
schema: benn
table: college_football_players
benn_college_football_teams:
file: datasets/raw/csv/benn_college_football_teams.csv
schema: benn
table: college_football_teams
YAML
git add datasets/catalog/datasets_catalog.yaml
git commit -m "docs(data): add datasets catalog (schema+table mapping)"
git push
clear
cd "/c/Users/hp/Git/sql_de_learning_2025"
mkdir -p db/ddl db/seed
# 001_create_schemas.sql
cat > db/ddl/001_create_schemas.sql << 'SQL'
-- Run connected to database: sql_de_lab
-- Creates the schemas used by your SQL files. Safe to re-run.
CREATE SCHEMA IF NOT EXISTS tutorial;
CREATE SCHEMA IF NOT EXISTS benn;
SQL
# 002_set_search_path.sql
cat > db/ddl/002_set_search_path.sql << 'SQL'
-- Run connected to database: sql_de_lab
-- Optional but tidy: default to tutorial first, then public
ALTER DATABASE sql_de_lab SET search_path = tutorial, public;
-- Apply for current session too (harmless if not supported by your tool):
SET search_path = tutorial, public;
SQL
# README for DB bootstrap
cat > db/README.md << 'MD'
# Local DB bootstrap
## Prereqs
- PostgreSQL running locally
- A database named **sql_de_lab** (create once via UI or `CREATE DATABASE sql_de_lab;`)
## Apply DDL
1. Connect to `sql_de_lab`.
2. Run `db/ddl/001_create_schemas.sql`.
3. Run `db/ddl/002_set_search_path.sql`.
## Load data (current approach)
Use DBeaver Import (CSV → New Table) and map files from
`datasets/raw/csv/` to the exact tables:
tutorial schema:
- us_housing_units
- billboard_top_100_year_end
- aapl_historical_stock_price
- crunchbase_acquisitions
- crunchbase_companies
- crunchbase_investments
- crunchbase_investments_part1
- crunchbase_investments_part2
benn schema:
- college_football_players
- college_football_teams
**Note:** Table names must match exactly the list above; your SQL will then run unchanged.
## Roadmap (later)
- Replace manual import with a scripted loader (`psql \copy` or csvkit) for one-command rebuild.
- Add indexes/constraints once queries are validated for speed.
MD
# Seed README (the wizard steps you’re using now)
cat > db/seed/README.md << 'MD'
# CSV load (DBeaver wizard)
1) Right-click schema (tutorial or benn) → Tools → Import Data…
2) Source: CSV → select file from `datasets/raw/csv/…`
3) Target: New table, set **Schema** and exact **Table name** as per db/README.md.
4) Check "First row is header".
5) Review types (year/month -> INTEGER, numeric -> DOUBLE PRECISION, text -> TEXT).
6) Finish.
Re-run any import if needed; it’s safe to drop and recreate tables during dev.
MD
git add db
git commit -m "chore(db): add DDL and reproducible setup docs"
git push
git add db/ddl/100_create_tables.sql
git commit -m "ddl: add benn.college_football_teams"
git push
cd "C:\Users\hp\Git\sql_de_learning_2025\sql\06_window_functions_techTFQ"
ls
git status
git status
cd..
cd..
cd..
cd ..
cd ..
ls
git status
git add sql/06_window_functions_techTFQ/
git status
git commit -m "Added window functions practice SQL file with salary inserts"
git push origin main
git status
git add db/ddl/001_create_schemas.sql db/ddl/002_set_search_path.sql db/ddl/100_create_tables.sql sql/01_basic_sql/basic_sql.sql
git commit -m "Updated DDL scripts and basic SQL examples"
git push origin mail
git push origin main
git status
git log --oneline -5
git status
exit
cd C:\Users\hp\Git\sql_de_learning_2025
git status
cd C\Users\hp\Git\sql_de_learning_2025
cd 'C:\Users\hp\Git\sql_de_learning_2025'
git status
# Stage everything (modified + untracked files)
git add .
# Commit with a clear message
git commit -m "Updated DDL and window function scripts; added new CTE practice file"
# Push to remote main branch
git push origin main
git status
git config --global core.autocrlf true
git status
ls
ls -la
ls -alF 
clear
ls -la
cd /c/Users/hp/Git/python_de_learning_2025
mkdir -p scripts
# 1) One-time / re-run setup
cat > scripts/dev_bootstrap.sh <<'EOF'
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
EOF

chmod +x scripts/dev_bootstrap.sh
# 2) Quick activate (works on Windows Git Bash & Linux/Mac)
cat > scripts/venv.sh <<'EOF'
#!/usr/bin/env bash
if [[ -f ".venv/Scripts/activate" ]]; then
  source .venv/Scripts/activate
else
  source .venv/bin/activate
fi
EOF

chmod +x scripts/venv.sh
# 3) Lint + format + test in one go
cat > scripts/qa.sh <<'EOF'
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
EOF

chmod +x scripts/qa.sh
# Commit these utility scripts
git add scripts/*.sh
git commit -m "chore(scripts): add dev_bootstrap, venv activator, QA runner"
cd /c/Users/hp/Git/python_de_learning_2025
cat > SCRIPTS_README.md <<'EOF'
# Dev Scripts – Quickstart

Use these helper scripts to keep your environment reproducible and your workflow clean. Run them in **Git Bash** from the repo root.

## How you’ll use them

**First time (or when you pull fresh):**
```bash
./scripts/dev_bootstrap.sh

source ./scripts/venv.sh
./scripts/qa.sh


./scripts/qa.sh


EOF

cd /c/Users/hp/Git/python_de_learning_2025
cat > SCRIPTS_README.md <<'EOF'
# Dev Scripts – Quickstart

Use these helper scripts to keep your environment reproducible and your workflow clean. Run them in **Git Bash** from the repo root.

## How you’ll use them

**First time (or when you pull fresh):**
```bash
./scripts/dev_bootstrap.sh


cd /c/Users/hp/Git/python_de_learning_2025
cat > SCRIPTS_README.md <<'EOF'
# Dev Scripts – Quickstart

Use these helper scripts to keep your environment reproducible and your workflow clean. Run them in **Git Bash** from the repo root.

## How you’ll use them

**First time (or when you pull fresh):**
```bash
./scripts/dev_bootstrap.sh







cd /c/Users/hp/Git/python_de_learning_2025
cat > SCRIPTS_README.md
cat SCRIPTS_README.md
cd /c/Users/hp/Git/python_de_learning_2025
# Initialize local repo and commit your work
git init
git add .
git commit -m "feat: bootstrap Python DE repo (structure, scripts, README)"
git branch -M main
git remote add origin https://github.com/Sahilg135/python_de_learning_2025.git
git push -u origin main
git status
cd /c/Users/hp/Git/python_de_learning_2025
ts=$(date +%Y-%m-%d_%H%M)
out="scripts/session_${ts}.sh"
{   echo '#!/usr/bin/env bash';   echo 'set -euo pipefail';   echo 'cd "$(dirname "$0")/.."';   history | sed 's/^[ ]*[0-9]\+[ ]*//'; } > "$out"
