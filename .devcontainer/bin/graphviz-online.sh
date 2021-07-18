#!/bin/bash
# A script that reads Graphviz code from stdin and
# produces a URL for visualizing it.

graphviz=$(cat - )

jq -rn --arg x "$graphviz" \
    '"https://dreampuf.github.io/GraphvizOnline/#" + ($x|@uri)'
