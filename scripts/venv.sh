#!/usr/bin/env bash
if [[ -f ".venv/Scripts/activate" ]]; then
  source .venv/Scripts/activate
else
  source .venv/bin/activate
fi
