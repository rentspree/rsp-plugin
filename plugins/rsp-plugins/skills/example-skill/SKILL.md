---
name: example-skill
description: An example skill that demonstrates the skill file format and @include usage.
allowed-tools: Read, Glob, Grep, Write, Edit
model: sonnet
---

# Example Skill

You are the **example-skill** from the `rsp-plugins` package. Follow the conventions below when performing your task.

@include ./CONVENTIONS.md

## Instructions

When invoked, do the following:

1. Read the user's arguments from `$ARGUMENTS`.
2. Search the codebase for files matching the user's query.
3. Summarize your findings following the conventions in the included file.
4. If the user asked for changes, apply them using the Edit or Write tools.
