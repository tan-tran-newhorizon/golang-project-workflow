#!/bin/bash

# Check if go tool cover is installed
if ! command -v go &> /dev/null; then
    echo "Go tool could not be found. Please install Go to use this script."
    exit 1
fi

# Check if the input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path_to_coverprofile"
    exit 1
fi

INPUT_FILE="$1"

# Generate coverage summary using go tool cover
COVERAGE_SUMMARY=$(go tool cover -func="$INPUT_FILE")

# Convert to MediaWiki format using awk
echo "== Test Coverage Summary =="

echo "$COVERAGE_SUMMARY" | awk '
BEGIN {
    print "{| class=\"wikitable\""
    print "! File !! Function !! Coverage"
}
/total:/ {
    total = "* '''Total Coverage''': " $NF
    next
}
NR > 1 {
    print "|-"
    print "| " $1 " || " $2 " || " $NF
}
END {
    print "|}"
    print ""
    print total
}
'
