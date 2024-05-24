#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq could not be found. Please install jq to use this script."
    exit 1
fi

# Check if the input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path_to_golangci_lint_json_output"
    exit 1
fi

INPUT_FILE="$1"

# Extract the summary of issues
SUMMARY=$(jq -r '
  .Issues | group_by(.FromLinter) | 
  map({linter: .[0].FromLinter, count: length}) | 
  "== 4 issues: ==\n" + 
  (map("* \(.linter): \(.count)") | join("\n"))
' "$INPUT_FILE")

# Extract and format the issues in MediaWiki format
DETAILS=$(jq -r '
  .Issues[] | 
  "=== File: " + .Pos.Filename + " ===\n" +
  "==== Line: " + (.Pos.Line | tostring) + ", Col: " + (.Pos.Column | tostring) + " ====\n" +
  "* Linter: " + .FromLinter + "\n" +
  "* Message: " + .Text + "\n" +
  "* Source:\n<code>" + (.SourceLines | join("\n")) + "</code>\n"
' "$INPUT_FILE")

# Combine the summary and details
echo -e "$SUMMARY\n\n== Details ==\n$DETAILS"
