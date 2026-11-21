# Issue tracker: the task board of this repo

For the skills that talk about «issues» or «tickets» (`to-tickets`, `to-spec`, `triage`, `implement`…): here they are **tasks**, and they live in this repo.

## Conventions
- **Board**: `docs/PLAN.md`, «Task board». One row per task: ID, title, milestone, blocked by, owner, branch, status. The row is the only home of status and blockers.
- **Card**: `docs/tasks/T<nn>-<slug>.md`, from `docs/tasks/_template.md`. One file per task, never a combined file. It says why the task exists, what to build, when it is done.
- **Spec or plan of a bigger feature**: `docs/plans/<task-id>-<short-name>.md` (`/plan`).
- Nothing goes in `.scratch/` or in a parallel set of files.

## When a skill says «publish to the issue tracker»
Show the breakdown in chat and get it approved. Then, for each ticket in dependency order: take the next free `T<nn>`, write its card, add its row to the board with its blockers. Titles use the words of `docs/GLOSSARY.md`.

## When a skill says «fetch the relevant ticket»
Read the task's row on the board, its card, and its plan in `docs/plans/` if there is one.

## Status
Status is the board's column, with these values: `todo` · `claimed` · `in progress` · `in review` · `done` · `blocked (reason)`.

| A skill says | Here |
|---|---|
| `ready-for-agent`, unblocked | `todo`, and every task in «Blocked by» is `done` |
| claim | Owner and branch written in the row before any work, on the task's own branch |
| `needs-info` | `blocked (question)`, and the question in «Open questions» of `PLAN.md` with who must answer |
| `wontfix` | The row is removed and one line goes in «Non-goals», with the reason |
| resolved, closed | `done`, set when the pull request is merged |

## Comments
Appended to the card under `## Notes`, with date and name.
