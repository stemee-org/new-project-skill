---
name: handover
description: Write the end-of-session handover and update project status. Use when the user says they're done, wrapping up, or asks for a handover.
---
1. Collect: what was done this session, branch, last commit, uncommitted changes (`git status`), what was verified and what was not.
2. Create `docs/handover/<YYYY-MM-DD>-<author>-<topic>.md` from the template in `docs/handover/README.md`. Never edit someone else's handover.
3. Overwrite `docs/STATUS.md` with the current state (one screen); link the new handover.
4. Update the task rows in `docs/PLAN.md`.
5. If a decision was made, create an ADR in `docs/decisions/` and add it to the index.
6. If a non-obvious pitfall came up, add one line to **Gotchas** in the `CLAUDE.md` of the folder it concerns (the root one if it concerns the whole repo).
7. Show the user the diff of the docs, then commit them on the work branch with the rest of the task: a task is not closed while its documents are outside the commits.
