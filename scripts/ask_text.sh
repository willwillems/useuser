#!/bin/bash
# Ask a text input question via native macOS dialog
# Usage: ask_text.sh "question" [default_value] [timeout_seconds|0|none]
# Returns: User's text input, "CANCELLED", "TIMEOUT", or "ERROR: message"
# Note: Pass 0 or "none" for timeout to wait indefinitely

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

# Check if timeout should be disabled
if [ "$TIMEOUT" = "0" ] || [ "$TIMEOUT" = "none" ] || [ "$TIMEOUT" = "None" ]; then
    # No timeout - dialog stays open indefinitely
    SCRIPT="
try
    set dialogResult to display dialog \"$ESCAPED_QUESTION\" default answer \"$ESCAPED_DEFAULT\"
    return text returned of dialogResult
on error number -128
    return \"CANCELLED\"
end try
"
else
    # With timeout
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
fi

result=$(osascript -e "$SCRIPT" 2>&1) || {
    echo "ERROR: $result"
    exit 1
}

echo "$result"
