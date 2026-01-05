#!/usr/bin/env python3

import sys
import traceback
import re
import string

template = string.Template(
    """$pre{$input_args}: 
let cfg = config.$path; in
{
  options.$path = {
    enable = lib.mkEnableOption "$enable_name";
  };

  config = lib.mkIf cfg.enable $config;
}"""
)


def main():
    base_path = sys.argv[1]

    for path in sys.argv[2:]:
        with open(path) as f:
            print(f"handling {path}")
            src = f.read()

        try:
            result = transform(base_path, path, src)
            with open(path, "w") as f:
                f.write(result)
        except ValueError:
            traceback.print_exc()


def transform(base_path, file_path, src):
    braces = parse_braces("{", "}", src)
    path_elements = ["astral"] + [
        e
        for e in file_path.removesuffix(".nix").removeprefix(base_path).split("/")
        if e not in ["", "default"]
    ]
    cfg_path = ".".join(path_elements)
    enable_name = cfg_path

    if isinstance(braces[0], str):
        pre = braces[0]
    else:
        pre = ""

    bracket_groups = [element for element in braces if isinstance(element, list)]

    if len(bracket_groups) == 1:
        template_args = {
            "input_args": "config, lib, ...",
            "imports_attr": "",
            "config": src,
        }
    else:
        args, body = bracket_groups
        args = {a.strip() for a in args[0].split(",")}
        args.add("config")
        args.add("lib")
        args.remove("...")

        template_args = {
            "input_args": ",".join(args) + ", ...",
            "imports_attr": "",
            "config": "{" + unparse_braces("{", "}", body) + "}",
        }

    template_args["pre"] = pre
    template_args["path"] = cfg_path
    template_args["enable_name"] = enable_name

    return template.substitute(template_args).strip()


def parse_braces(opening, closing, text):
    stack = [[]]
    buffer = []

    def flush_buffer():
        if buffer:
            s = "".join(buffer)
            buffer.clear()
            if not stack:
                stack.append(s)
            else:
                stack[-1].append(s)

    for ch in text:
        if ch == opening:
            flush_buffer()
            stack.append([])
        elif ch == closing:
            flush_buffer()
            if len(stack) == 0:
                raise ValueError("Unbalanced closing brace")
            result = stack.pop()
            stack[-1].append(result)
        else:
            buffer.append(ch)

    flush_buffer()

    return stack.pop()


def unparse_braces(opening, closing, parsed):
    def helper(n, is_root):
        if isinstance(n, str):
            yield n
            return
        if isinstance(n, list):
            if not is_root:
                yield opening
            for i in n:
                yield from helper(i, False)
            if not is_root:
                yield closing

    return "".join(helper(parsed, True))


if __name__ == "__main__":
    main()
