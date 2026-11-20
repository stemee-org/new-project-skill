# Contributing

{{Who works here: names, each with their own Claude Code or not.}} What is not written in this repo the others do not know: every session starts from the documents and ends by updating them.

## Before you start
1. Pull `main`.
2. Read `docs/STATUS.md` and the latest file in `docs/handover/` (or run `/start-session` in Claude Code).
3. Create the branch `<name>/<task-id>-<short-desc>` (without a task: `<name>/<short-desc>`).
4. Claim your task in `docs/PLAN.md` (owner + branch) before starting.

## While working
- Never push to `main`: work on a branch, one task at a time, and open a pull request. Also for a change of documents only.
- Small commits; message style: `<type>: <what>` (feat, fix, docs, refactor, test, chore).
- Don't change files owned by someone else's in-progress task without talking to them. Someone else's branch is not deleted without asking.
- Made a decision others should know about? Write an ADR (`/adr`).
- {{With a reference: porting = read the original, apply the ADRs and the corrections named in the task, add the tests. A defect found in the reference is fixed here and written in the handover.}}

## How a task is built
The default way of working, not something to ask for. One session orchestrates, a team of subagents writes, and whoever is working sees the team before it starts. A «task» is any work that changes the repo; a question or a read-only session is not.

1. **Read first.** {{The original in the reference and}} the state of the repo (code, ADRs, handovers that name the task), before writing the plan.
2. **The team is shown in chat, always.** Before changing a file the orchestrator writes the team table in chat: wave, subtask, model, effort, why. Then waits for the go-ahead. A task of a few files has one row («orchestrator, no subagent»): shown anyway, so the choice not to delegate is visible.
3. **A task bigger than a few files also has a plan.** In `docs/plans/` (`/plan`): the table shown in chat is its `Team` section. The plan is approved before code is written.
4. **The main session orchestrates**, on the best model available: {{Fable 5.2, or Opus 5.5 with effort `high` or `xhigh`}}. A session cannot change its own model: on another one it says so first and asks whether to go on. It keeps plan, shared dependencies (manifests, lockfiles), verification, commits, documents and pull request. Model and effort are passed explicitly on each `Agent` call.
5. **Subagents write, they don't commit.** Two working at once never touch the same files; one that needs another's result waits for it.
6. **A subagent's work is verified, not trusted.** At the end of each wave the orchestrator reads the diff and runs test, lint and type-check, then commits.
7. **The last wave checks.** Independent review of the diff (`code-reviewer`), security review if the task touches input, access or payments (`security-auditor`), a run of the real app if what the user sees changes. What stays unverified is written in the handover and in the pull request.

### Models and efforts
One subagent per independent piece of work, none for a piece that is a few tool calls: the task decides the number. Most of the team is Opus at different efforts; smaller models are for searching and routine work. Never `max` or `low`.

| Work | Model | Effort |
| --- | --- | --- |
| Searching, listing, reading many files, checking links or documents | `haiku` or `sonnet` | default |
| Routine code, tests from a clear specification, documents, translations | `sonnet` | default |
| Standard implementation of a well-specified piece | `opus` | `medium` |
| Non-trivial implementation, refactoring, regression test for a defect | `opus` | `high` |
| {{The hard core of this project: e.g. the engine, parsers, migrations, money, security}} | `opus` | `xhigh` |
| Final review of the whole diff (`code-reviewer`, `security-auditor`) | `opus` | `high` or `xhigh` |

## Before you finish
- Tests, lint and type-check pass.
- After the push, check the CI on the pull request.
- Write a handover in `docs/handover/` (`/handover`).
- Update `STATUS.md` and your task's row in `PLAN.md`.
- Commit and push on the work branch, then a pull request to `main` (`/ship`). Title in the form of commits, with the task in parentheses at the end. Description with the sections «What changes», «Why this way», «How it was done», «Verified» and «Not verified». Have it reviewed before merging unless told otherwise.

## Plugins
`.claude/settings.json` enables them: Claude Code offers to install them to whoever opens the repo. ADRs and the documents of this repo come before any plugin skill; what a plugin skill produces is stored in these documents (`docs/plans/`, the task board, `docs/GLOSSARY.md`, an ADR), never in a parallel set of files.

- **`mattpocock-skills@claude-plugins-official`** (by hand: `claude plugin install mattpocock-skills@claude-plugins-official`). {{Which of its skills this project uses and at which point of «How a task is built»: written after installing it and reading its list, not from memory.}}

## Area owners
The owner is the person to hear before changing the area, not the only one who may touch it. {{If derived from a reference's history: a proposal until confirmed.}}

| Area | Owner |
|---|---|
| {{e.g. frontend, backend, data}} | {{name}} |
| Documents (`docs/`, `CLAUDE.md`) | whoever closes the session |
