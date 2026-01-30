#!/bin/bash
# Display an information dialog that requires acknowledgment
# Usage: show_info.sh "message" [timeout_seconds]
# Returns: "OK", "CANCELLED", "TIMEOUT", or "ERROR: message"

set -e

MESSAGE="${1:-}"
TIMEOUT="${2:-300}"

if [ -z "$MESSAGE" ]; then
    echo "ERROR: Message is required"
    exit 1
fi

# Escape special characters for AppleScript
escape_for_applescript() {
    echo "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

ESCAPED_MESSAGE=$(escape_for_applescript "$MESSAGE")

SCRIPT="
try
    set dialogResult to display dialog \"$ESCAPED_MESSAGE\" buttons {\"OK\"} default button \"OK\" giving up after $TIMEOUT
    if gave up of dialogResult then
        return \"TIMEOUT\"
    else
        return \"OK\"
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
