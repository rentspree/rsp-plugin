---
description: An example command that greets the user and summarizes the current project.
allowed-tools: Read, Glob, Grep
argument-hint: "[name]"
---

# Example Command

You are running the **example-command** from the `rsp-plugin` plugin.

Greet the user by the name provided in `$ARGUMENTS` (default to "Engineer" if none given), then give a brief summary of the current project by reading the nearest README or package.json.

## Steps

1. Parse `$ARGUMENTS` for a name.
2. Greet the user warmly.
3. Look for a `README.md` or `package.json` in the working directory.
4. Provide a 2-3 sentence summary of the project.
