#!/bin/bash

# Run golangci-lint and save the JSON output to a file
golangci-lint run --out-format json > golangci-lint-report.json

# Check if the JSON file exists
if [ -f "golangci-lint-report.json" ]; then
    # Start writing Markdown output
    echo "# Golangci-lint Results" > golangci-lint-report.wiki
    echo "" >> golangci-lint-report.wiki

    # Iterate over each issue in the JSON file
    jq -c '.Issues[]' golangci-lint-report.json | while read -r issue; do
        # Extract fields from JSON
        message=$(echo "$issue" | jq -r '.Text')
        severity=$(echo "$issue" | jq -r '.Severity')
        line=$(echo "$issue" | jq -r '.Pos.Line')
        column=$(echo "$issue" | jq -r '.Pos.Column')
        file=$(echo "$issue" | jq -r '.Pos.Filename')

        # Write issue details to Markdown file
        echo "## $severity: $message" >> golangci-lint-report.wiki
        echo "- File: $file" >> golangci-lint-report.wiki
        echo "- Line: $line" >> golangci-lint-report.wiki
        echo "- Column: $column" >> golangci-lint-report.wiki
        echo "" >> golangci-lint-report.wiki
    done

    # Remove the JSON file after processing
    rm golangci-lint-report.json

    echo "Markdown report generated: golangci-lint-report.wiki"
else
    echo "Error: JSON file not found."
fi
