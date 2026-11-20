---
name: start-session
description: Load project context at the start of a work session. Use at the beginning of a session or when asked "where are we" / "catch me up".
---
Work that is not on `main` yet lives on other branches and in open pull requests: `main`'s docs alone can miss a task someone already claimed or finished. Always look at both.

1. Read `docs/STATUS.md`, the newest file in `docs/handover/`, and `docs/PLAN.md` (the copies on `main`: `git show origin/main:docs/STATUS.md` if the current branch is behind).
2. Run `git fetch --all --prune`, `git status` and `git log --oneline -10`; note any uncommitted work or branch mismatch, and whether the current branch is behind `origin/main`.
3. Look past `main`:
   - Open pull requests: `gh pr list --state open --json number,title,headRefName,author,isDraft,updatedAt`.
   - Branches with unmerged work: for every `origin/*` branch except `main`, `git log --oneline origin/main..<branch>` (skip branches with no commits ahead). Note author and date of the last commit (`git log -1 --format='%an %ar' <branch>`).
   - What those branches say about the plan: `git diff origin/main...<branch> -- docs/PLAN.md docs/STATUS.md` (three dots: only their changes). A task claimed or moved forward there counts as claimed, even if `main` still says `todo`.
   - Recently merged pull requests (`gh pr list --state merged -L 5`): if `PLAN.md` or `STATUS.md` still call one of them open, say so.
4. Summarize in under 10 lines: current state, what's in progress (and by whom, with the branch or pull request), the top next step. List each unmerged branch in one line.
5. Ask which task to work on. Before starting it, claim it in `PLAN.md` if unclaimed, on its own branch from `origin/main`.
6. If the task is claimed by someone else, on `main` or on any branch from step 3, stop and tell the user.
7. Once the task is chosen, rename the session with `mcp__ccd_session_mgmt__set_session_title` (`session_id: "self"`). Never leave the default "New session": the title is the task id plus a short description, e.g. `T09 · login form`. If no task is chosen (only a catch-up), use a title that says what the session is for, e.g. `Catch-up 2026-11-14`. Load the tool with `ToolSearch` (`select:mcp__ccd_session_mgmt__set_session_title`) if it is only deferred; if it is not available at all, say so and move on.
8. Once the task is chosen, and before changing any file, show the team in chat without being asked (`CONTRIBUTING.md`, «How a task is built»):
   - Name the model this session runs on. The orchestrator must be the best one available (named in `CLAUDE.md`, «Rules»): if it is another model, say so first and ask whether to go on.
   - Print a table with wave, subtask, model, effort and why. If the task has a plan in `docs/plans/`, the table is its `Team` section; otherwise propose one from the table in `CONTRIBUTING.md` («Models and efforts»). A task of a few files gets a single row («orchestrator, no subagent»): show it anyway.
   - Wait for the user's go-ahead. A task bigger than a few files with no plan yet goes through `/plan` first.
