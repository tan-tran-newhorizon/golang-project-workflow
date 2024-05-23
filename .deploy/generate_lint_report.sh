#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install jq to use this script."
    exit
fi

# Check if the input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path_to_golangci_lint_json_output"
    exit 1
fi

INPUT_FILE="$1"

# Read and parse JSON, then convert to MediaWiki format
jq -r '.Issues[] | 
    "== File: \(.Pos.Filename) ==\n" +
    "=== Line: \(.Pos.Line), Col: \(.Pos.Column) ===\n" +
    "* Linter: \(.FromLinter)\n" +
    "* Message: \(.Text)\n" +
    "* Source: <code>\(.SourceLines | join("\n"))</code>\n"' "$INPUT_FILE"