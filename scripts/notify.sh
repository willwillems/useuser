#!/bin/bash
# Send a macOS system notification (non-blocking)
# Usage: notify.sh "message" [title] [subtitle] [sound: yes|no]
# Returns: "OK" on success, or "ERROR: message"

set -e

MESSAGE="${1:-}"
TITLE="${2:-Useuser}"
SUBTITLE="${3:-}"
SOUND="${4:-no}"

if [ -z "$MESSAGE" ]; then
    echo "ERROR: Message is required"
    exit 1
fi

# Escape special characters for AppleScript
escape_for_applescript() {
    echo "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

ESCAPED_MESSAGE=$(escape_for_applescript "$MESSAGE")
ESCAPED_TITLE=$(escape_for_applescript "$TITLE")
ESCAPED_SUBTITLE=$(escape_for_applescript "$SUBTITLE")

# Build sound clause
SOUND_CLAUSE=""
case "$SOUND" in
    yes|Yes|YES|y|Y|true|1)
        SOUND_CLAUSE="sound name \"default\""
        ;;
esac

# Build subtitle clause
SUBTITLE_CLAUSE=""
if [ -n "$ESCAPED_SUBTITLE" ]; then
    SUBTITLE_CLAUSE="subtitle \"$ESCAPED_SUBTITLE\""
fi

SCRIPT="
try
    display notification \"$ESCAPED_MESSAGE\" with title \"$ESCAPED_TITLE\" $SUBTITLE_CLAUSE $SOUND_CLAUSE
    return \"OK\"
on error errorMessage
    return \"ERROR: \" & errorMessage
end try
"

result=$(osascript -e "$SCRIPT" 2>&1) || {
    echo "ERROR: $result"
    exit 1
}

echo "$result"
