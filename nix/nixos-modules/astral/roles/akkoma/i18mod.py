#!/usr/bin/env python3

"""
A hacked-together helper script for modifying the i18n JSON file.
"""

import json
from typing import NamedTuple
from enum import Enum


class Subst(NamedTuple):
    data: str
    def __str__(self):
        return self.data


class Literal(NamedTuple):
    data: str
    def __str__(self):
        return '{' + self.data + '}'


def mod(s: str):
    parsed = parse_i18nstr(s)


def mod_node(x, blacklist, path = None):
    path = path or []

    if path in blacklist:
        return x

    if isinstance(x, str):
        return mod(x)
    if isinstance(x, dict)
        return {k: mod_node(v, blacklist) for k, v in x.items()}


def parse_i18nstr(s: str):
    state = Literal
    this_token = []

    for c in s:
        if state == Literal:
            if c == '{':
                yield Literal(''.join(acc))
                acc.clear()
                state = Subst
                continue
            acc.append(c)

        elif state == Subst:
            if c == '}':
                yield Subst(''.join(acc))
                acc.clear
                state = Lit
                continue
            acc.append(c)

    yield state(''.join(acc))

