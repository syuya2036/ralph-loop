# Ralph Agent Instructions

## Context

You are running in the root of the project.
The configuration files for this agent loop are located in the `ralph-loop/` directory.

## Your Task

1. Read `ralph-loop/prd.json`
2. Read `ralph-loop/progress.txt`
   (check Codebase Patterns first)
3. Check you're on the correct branch (create it if it doesn't exist, checkout if it does)
4. Pick highest priority story where `passes: false`
5. Implement that ONE story in the CURRENT directory (`.`), NOT inside `ralph-loop/`.
6. Run typecheck and tests (if applicable for the language)
7. Update `AGENTS.md` files with learnings (if they exist or create one in the root if valuable)
8. Commit: `feat: [ID] - [Title]`
9. Update `ralph-loop/prd.json`: Set `passes: true` for the completed story
10. Append learnings to `ralph-loop/progress.txt`

## Progress Format

APPEND to `ralph-loop/progress.txt`:

## [Date] - [Story ID]
- What was implemented
- Files changed
- **Learnings:**
  - Patterns discovered
  - Gotchas encountered
---

## Codebase Patterns

Add reusable patterns to the TOP of `ralph-loop/progress.txt`:

## Codebase Patterns
- Migrations: Use IF NOT EXISTS
- React: useRef<Timeout | null>(null)

## Stop Condition

If ALL stories pass (check `ralph-loop/prd.json` first), reply with EXACTLY:
<promise>COMPLETE</promise>

Otherwise end your turn normally after committing and updating the tracking files.
