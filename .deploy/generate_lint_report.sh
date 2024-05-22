#!/bin/bash

# Run golangci-lint and save the JSON output to a file
# golangci-lint run --out-format json > golangci-lint-report.json

# Check if the JSON file exists
if [ -f "golangci-lint-report.json" ]; then
    # Start writing Markdown output
    echo "# Golangci-lint Results" > golangci-lint-report.md
    echo "" >> golangci-lint-report.md

    # Iterate over each issue in the JSON file
    jq -c '.Issues[]' golangci-lint-report.json | while read -r issue; do
        # Extract fields from JSON
        message=$(echo "$issue" | jq -r '.Text')
        severity=$(echo "$issue" | jq -r '.Severity')
        line=$(echo "$issue" | jq -r '.Pos.Line')
        column=$(echo "$issue" | jq -r '.Pos.Column')
        file=$(echo "$issue" | jq -r '.Pos.Filename')

        # Write issue details to Markdown file
        echo "## $severity: $message" >> golangci-lint-report.md
        echo "- File: $file" >> golangci-lint-report.md
        echo "- Line: $line" >> golangci-lint-report.md
        echo "- Column: $column" >> golangci-lint-report.md
        echo "" >> golangci-lint-report.md
    done

    # Remove the JSON file after processing
    rm golangci-lint-report.json

    echo "Markdown report generated: golangci-lint-report.md"
else
    echo "Error: JSON file not found."
fi
