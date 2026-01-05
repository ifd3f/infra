#!/usr/bin/env python3

from pathlib import Path
import sys

def search_to_import(path: Path, is_root:bool):
    if path.is_file(follow_symlinks=False) and path.suffix == '.nix':
        yield path
    elif path.is_dir():
        if (path / 'default.nix').exists() and not is_root:
            yield path
        else:
            for child in path.iterdir():
                yield from search_to_import(child, False)

def generate_import_list(base: Path):
    for i in search_to_import(base, True):
        yield './' + str(i.relative_to(base))

print('{imports=[')
for f in generate_import_list(Path.cwd()):
    print(f)
print('];}')