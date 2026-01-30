#!/bin/bash
# Ask a yes/no confirmation question via native macOS dialog
# Usage: ask_confirm.sh "question" [default: yes|no] [timeout_seconds|0|none]
# Returns: "YES", "NO", "CANCELLED", "TIMEOUT", or "ERROR: message"
# Note: Pass 0 or "none" for timeout to wait indefinitely

set -e

QUESTION="${1:-}"
DEFAULT_BUTTON="${2:-no}"
TIMEOUT="${3:-300}"

if [ -z "$QUESTION" ]; then
    echo "ERROR: Question is required"
    exit 1
fi

# Normalize default button
case "$DEFAULT_BUTTON" in
    yes|Yes|YES|y|Y)
        DEFAULT_BUTTON="Yes"
        ;;
    *)
        DEFAULT_BUTTON="No"
        ;;
esac

# Escape special characters for AppleScript
escape_for_applescript() {
    echo "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

ESCAPED_QUESTION=$(escape_for_applescript "$QUESTION")

# Check if timeout should be disabled
if [ "$TIMEOUT" = "0" ] || [ "$TIMEOUT" = "none" ] || [ "$TIMEOUT" = "None" ]; then
    # No timeout - dialog stays open indefinitely
    SCRIPT="
try
    set dialogResult to display dialog \"$ESCAPED_QUESTION\" buttons {\"No\", \"Yes\"} default button \"$DEFAULT_BUTTON\"
    set buttonPressed to button returned of dialogResult
    if buttonPressed is \"Yes\" then
        return \"YES\"
    else
        return \"NO\"
    end if
on error number -128
    return \"CANCELLED\"
end try
"
else
    # With timeout
    SCRIPT="
try
    set dialogResult to display dialog \"$ESCAPED_QUESTION\" buttons {\"No\", \"Yes\"} default button \"$DEFAULT_BUTTON\" giving up after $TIMEOUT
    if gave up of dialogResult then
        return \"TIMEOUT\"
    else
        set buttonPressed to button returned of dialogResult
        if buttonPressed is \"Yes\" then
            return \"YES\"
        else
            return \"NO\"
        end if
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
