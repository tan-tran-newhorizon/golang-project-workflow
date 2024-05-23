#!/bin/bash
# Check if jq is installed (jq is a JSON processor)
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq and try again."
    exit 1
fi

# Start the MediaWiki formatted output
echo "{| class=\"wikitable\""
echo "! File !! Line !! Column !! Message !! Linter"

# Parse the JSON and convert to MediaWiki format
jq -r '.Issues[] | "|-\n| \(.FromLinter) || \(.Pos.Filename) || \(.Pos.Line) || \(.Pos.Column) || \(.Text)"' golangci-lint-report.json

# End the MediaWiki table
echo "|}"