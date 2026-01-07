# Ralph Agent Instructions

## Your Task

1. Read `prd.json`
2. Read `progress.txt`
   (check Codebase Patterns first)
3. Check you're on the correct branch (create it if it doesn't exist, checkout if it does)
4. Pick highest priority story where `passes: false`
5. Implement that ONE story
6. Run typecheck and tests (if applicable for the language)
7. Update `AGENTS.md` files with learnings (if they exist or create one in the root if valuable)
8. Commit: `feat: [ID] - [Title]`
9. Update `prd.json`: Set `passes: true` for the completed story
10. Append learnings to `progress.txt`

## Progress Format

APPEND to `progress.txt`:

## [Date] - [Story ID]
- What was implemented
- Files changed
- **Learnings:**
  - Patterns discovered
  - Gotchas encountered
---

## Codebase Patterns

Add reusable patterns to the TOP of `progress.txt`:

## Codebase Patterns
- Migrations: Use IF NOT EXISTS
- React: useRef<Timeout | null>(null)

## Stop Condition

If ALL stories pass (check `prd.json` first), reply with EXACTLY:
<promise>COMPLETE</promise>

Otherwise end your turn normally after committing and updating the tracking files.
