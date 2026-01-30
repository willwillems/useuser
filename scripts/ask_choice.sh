#!/bin/bash
# Ask a multiple choice question via native macOS dialog
# Usage: ask_choice.sh "question" "choice1" "choice2" ...
# Returns: Selected choice text, or "CANCELLED"

set -e

QUESTION="${1:-}"
shift

if [ -z "$QUESTION" ]; then
    echo "ERROR: Question is required"
    exit 1
fi

if [ $# -lt 2 ]; then
    echo "ERROR: At least 2 choices are required"
    exit 1
fi

# Escape special characters for AppleScript
escape_for_applescript() {
    echo "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

ESCAPED_QUESTION=$(escape_for_applescript "$QUESTION")

# Build the choices list
CHOICES=""
for choice in "$@"; do
    escaped_choice=$(escape_for_applescript "$choice")
    if [ -z "$CHOICES" ]; then
        CHOICES="\"$escaped_choice\""
    else
        CHOICES="$CHOICES, \"$escaped_choice\""
    fi
done

SCRIPT="
try
    set selectedItem to choose from list {$CHOICES} with prompt \"$ESCAPED_QUESTION\"
    if selectedItem is false then
        return \"CANCELLED\"
    else
        return item 1 of selectedItem
    end if
on error errorMessage number errorNumber
    if errorNumber is -128 then
        return \"CANCELLED\"
    else
        return \"ERROR: \" & errorMessage
    end if
end try
"

result=$(osascript -e "$SCRIPT" 2>&1) || {
    echo "ERROR: $result"
    exit 1
}

echo "$result"
