#!/usr/bin/env bash
# Example PostToolUse hook for Claude Code.
#
# This script is triggered after a tool is used. It reads the tool event
# from stdin (JSON) and can decide whether to continue, block, or provide
# feedback to the agent.
#
# Hook events are JSON objects with fields like:
#   { "tool_name": "Write", "tool_input": { "file_path": "...", ... }, ... }
#
# To use this hook, register it in your Claude Code settings:
#   "hooks": {
#     "PostToolUse": [
#       { "command": "bash /path/to/example-hook.sh" }
#     ]
#   }

# Read the event from stdin
event=$(cat)

# Extract the tool name
tool_name=$(echo "$event" | jq -r '.tool_name // empty')

# Example: warn if a Write tool creates a file in a protected directory
if [ "$tool_name" = "Write" ]; then
  file_path=$(echo "$event" | jq -r '.tool_input.file_path // empty')

  if [[ "$file_path" == */config/* ]]; then
    echo "Warning: A file was written to a config directory: $file_path"
  fi
fi
