from sahil_py.utils import write_json, read_json
from pathlib import Path

def test_roundtrip(tmp_path: Path):
    path = tmp_path / "x.json"
    write_json(path, {"a": 1})
    assert read_json(path) == {"a": 1}
