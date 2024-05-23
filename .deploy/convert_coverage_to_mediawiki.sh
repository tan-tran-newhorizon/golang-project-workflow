#!/bin/bash

# Check if input file provided as argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

# Check if input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file '$input_file' not found."
    exit 1
fi

# Read input from file
input=$(< "$input_file")

title="== Test Coverage Summary ==\n"

# Output string template
output_template="{| class=\"wikitable\"
! File !! Line !! Function !! Coverage
|-
"

# Parse input and format output
formatted_output=""
while IFS= read -r line; do
    file=$(echo "$line" | awk -F ':' '{print $1}')
    line_number=$(echo "$line" | awk -F ':' '{print $2}')
    function=$(echo "$line" | awk '{print $(NF-1)}')
    coverage=$(echo "$line" | awk '{print $NF}')
    formatted_output+="| $file || $line_number || $function || $coverage\n|-\n"
done <<< "$(echo "$input" | grep -v "total")"

total_coverage=$(echo "$input" | grep "total" | awk '{print $(NF)}')

# Output the formatted result
echo -e  $title"* '''Total Coverage''': $total_coverage\n""$output_template" "$formatted_output""|}"
