#!/usr/bin/env python
"""Small example CLI."""
from sahil_py.utils import write_json
import argparse


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="data/example.json")
    args = ap.parse_args()
    write_json(args.out, {"hello": "sahil"})
    print(f"Wrote {args.out}")


if __name__ == "__main__":
    main()
