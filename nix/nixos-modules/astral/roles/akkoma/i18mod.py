#!/usr/bin/env python3

"""
A hacked-together helper script for modifying the i18n JSON file.
"""

import json
import sys
from typing import NamedTuple

BLACKLIST = {
    ("languages",),
}


def main():
    data = json.load(sys.stdin)
    modded = mod_node(data, BLACKLIST)
    json.dump(modded, sys.stdout, indent=4)


class Literal(NamedTuple):
    data: str
    def __str__(self):
        return self.data


class Subst(NamedTuple):
    data: str
    def __str__(self):
        return '{' + self.data + '}'


def mod(xs):
    for x in xs:
        if isinstance(x, Subst):
            yield x
            continue

        if isinstance(x, Literal):
            s = (
                x.data
                    .replace('post', 'yeet').replace('Post', 'Yeet')
                    .replace('repeat', 'reyeet').replace('Repeat', 'Reyeet')
                    .replace('favorite', 'yay').replace('Favorite', 'Yay')
                    .replace('bookmark', 'yoink').replace('Bookmark', 'Yoink')

                    .replace('reply', 'yeetback').replace('Reply', 'Yeetback')
                    .replace('replies', 'yeetbacks').replace('Replies', 'Yeetbacks')
                    .replace('replying', 'yeeting back').replace('Replying', 'Yeeting back')

                    .replace('instance', 'yeetland').replace('Instance', 'Yeetland')
                    .replace('account', 'yeeter').replace('Account', 'Yeeter')
                    .replace('user', 'yeeter').replace('User', 'Yeeter')
                    .replace('moderator', 'yeet controller').replace('Moderator', 'Yeet Controller')
                    .replace('admin', 'Minister of Yeeting').replace('Admin', 'Minister of Yeeting')
            )
            yield Literal(s)


def mod_node(x, blacklist, path = None):
    path = path or tuple()

    if path in blacklist:
        return x

    if isinstance(x, str):
        nodes = parse_i18nstr(x)
        result = mod(nodes)
        return ''.join(map(str, result))

    if isinstance(x, dict):
        return {k: mod_node(v, blacklist, path + (k,)) for k, v in x.items()}


def parse_i18nstr(s: str):
    state = Literal
    acc = []

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
                acc.clear()
                state = Literal
                continue
            acc.append(c)

    yield state(''.join(acc))


if __name__ == '__main__':
    main()
