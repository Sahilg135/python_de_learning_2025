from loguru import logger
from pathlib import Path
import json


def read_json(path: str | Path) -> dict:
    """Read JSON file into dict (UTF-8)."""
    p = Path(path)
    logger.debug(f"Reading JSON: {p}")
    with p.open("r", encoding="utf-8") as f:
        return json.load(f)


def write_json(path: str | Path, obj: dict) -> None:
    """Write dict to JSON (pretty, UTF-8)."""
    p = Path(path)
    p.parent.mkdir(parents=True, exist_ok=True)
    with p.open("w", encoding="utf-8") as f:
        json.dump(obj, f, ensure_ascii=False, indent=2)
    logger.info(f"Wrote JSON: {p}")
