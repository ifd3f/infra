#!/usr/bin/env python3

import os
import sys
import logging
from pathlib import Path

logger = logging.getLogger(__name__)

# Resolve the directory this script lives in
SCRIPT_DIR = Path(__file__).resolve().parent
HOME_DIR = Path.home()
CONFIG_DIR = HOME_DIR / ".config"


paths = {
    SCRIPT_DIR / "zsh/zshrc.zsh": HOME_DIR / ".zshrc",
    SCRIPT_DIR / "zsh/starship.toml": CONFIG_DIR / "starship.toml",
    SCRIPT_DIR / "nvim": CONFIG_DIR / "nvim",
    SCRIPT_DIR / "git": CONFIG_DIR / "git",
}


def symlink(source: Path, target: Path) -> bool:
    """
    Create a symlink from source_name to target_path.
    """
    if target.exists():
        if target.is_symlink():
            target.unlink()
        elif target.is_dir():
            raise FileExistsError("{target_path} exists and is a directory!")
        else:
            raise FileExistsError("{target_path} exists and is not a symlink!")

    # Make the file
    target.parent.mkdir(parents=True, exist_ok=True)

    # Create the symlink
    os.symlink(source, target)
    return True


def main():
    for s, t in paths.items():
        s, t = Path(s), Path(t)
        try:
            symlink(s, t)
            logger.info(f"Linked: {t} -> {s}")
        except FileExistsError:
            logger.warn(f"Ignoring due to existing file: {t} -> {s}")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    main()

