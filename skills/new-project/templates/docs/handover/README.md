# Handovers

At the end of every working session (person or Claude), write a **new** file named `YYYY-MM-DD-<author>-<topic>.md` — or run `/handover`. Never edit someone else's handover. Then update `../STATUS.md` and `../PLAN.md`.

## Template

```markdown
# Handover — <topic>
- **Date:** <YYYY-MM-DD>
- **Author:** <name> (with Claude: yes/no)
- **Branch:** <branch> · **Last commit:** <short sha>
- **Tasks:** <Task IDs from PLAN.md>

## Done
- <What was finished, with links to files/PRs.>

## State right now
- <What's half-done, what's uncommitted, what's running.>

## Next steps
1. <Concrete next action, specific enough to start without asking.>

## Watch out
- <Pitfalls, things that looked wrong but are intentional, flaky tests.>

## Decisions made
- <Link to new ADRs, or "none".>
```
