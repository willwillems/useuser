#!/bin/bash
# Ask a text input question via native macOS dialog
# Usage: ask_text.sh "question" [default_value] [timeout_seconds]
# Returns: User's text input, "CANCELLED", "TIMEOUT", or "ERROR: message"

set -e

QUESTION="${1:-}"
DEFAULT_VALUE="${2:-}"
TIMEOUT="${3:-300}"

if [ -z "$QUESTION" ]; then
    echo "ERROR: Question is required"
    exit 1
fi

# Escape special characters for AppleScript
escape_for_applescript() {
    echo "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

ESCAPED_QUESTION=$(escape_for_applescript "$QUESTION")
ESCAPED_DEFAULT=$(escape_for_applescript "$DEFAULT_VALUE")

SCRIPT="
try
    set dialogResult to display dialog \"$ESCAPED_QUESTION\" default answer \"$ESCAPED_DEFAULT\" giving up after $TIMEOUT
    if gave up of dialogResult then
        return \"TIMEOUT\"
    else
        return text returned of dialogResult
    end if
on error number -128
    return \"CANCELLED\"
end try
"

result=$(osascript -e "$SCRIPT" 2>&1) || {
    echo "ERROR: $result"
    exit 1
}

echo "$result"
