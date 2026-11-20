---
name: write-prompt
description: Write a ready-to-paste prompt that runs a task with an orchestrator model and a team of subagents. Use when the user says "write a prompt for <task>", invokes `/write-prompt <task> <orchestrator>`, or wants to delegate a task to Opus 5.5 or Fable plus subagents.
---
Invocation: `/write-prompt [task] [orchestrator]`.

- `task`: what has to be done. A task id from `docs/PLAN.md` (e.g. `T09`) or a free description.
- `orchestrator`: `opus` or `fable`. If missing, ask once. If the user gave no preference, recommend one (Fable for open-ended design or long, ambiguous work; Opus 5.5 for well-bounded work).

You only write the prompt. Do not run the task, do not spawn agents, do not claim anything in `PLAN.md`.

## 1. Understand the task
1. If `task` is an id, read its entry in `docs/PLAN.md` and every ADR, plan (`docs/plans/`) and doc it links. If it is claimed by someone else, stop and tell the user.
2. Read the code the task touches, and the original in the reference if the task is a port (read-only, see `CLAUDE.md`).
3. Measure the task: how many files, how many independent parts, how much is reading versus writing, how risky (the project's hard core, migrations, payments, security).

## 2. Choose the orchestrator
- `fable`: orchestrator is Fable. It runs on its own, no effort to choose.
- `opus`: orchestrator is Opus 5.5, and you choose its effort from the measure above, without asking:
  - `high`: the plan is clear, the work splits into a few well-defined pieces, little ambiguity.
  - `xhigh` ("Extra"): the design is open, pieces depend on each other, the logic or the architecture is delicate, or a wrong choice is expensive to undo (data model, migrations).
  - Never `max` or `low`.
  State the choice and the reason in one line.

## 3. Design the team
Subagents are spawned by the orchestrator with the `Agent` tool. Choose how many the task needs, not a fixed number: one per independent piece of work, none for a piece that is a few tool calls. Give each one model and effort by what it does, from the table in `CONTRIBUTING.md` («Models and efforts»): read it, never choose from memory.

Rules for the team:
- Writers never touch the same files; a piece that needs another piece's result waits for it.
- Anything that only reads can run in parallel; mix models freely, but most of the team should be Opus at different efforts, with cheaper models only for search and routine work.
- `effort` is set on the `Agent` call only because this skill asks for it explicitly: say so in the prompt.
- Testing and review are the last pieces, after the writers.

## 4. Write the prompt
Write it in the language of the project's documents, in a single fenced block, ready to paste, with these sections:

1. **Role and model**: "You are the orchestrator, model <Opus 5.5 with effort High|Extra | Fable>", one line on why (for Opus).
2. **Goal and done criteria**: what the task is, what "done" looks like, the files and docs to read first (with paths).
3. **Constraints from the project**: copy only those that apply from `CLAUDE.md` (never restate all of it): branch `<name>/<task-id>-<short-desc>` and pull request with no push on `main`; claim in `PLAN.md`; the conventions and ADRs the task meets; tests for new behaviour and a regression test for a fix; ADR to reverse a decision; commits explained in full. For a feature bigger than a few files, the orchestrator writes a plan and waits for approval before coding. Guides or documents a writer must read are named with their paths: subagents do not look for them on their own.
4. **Team**: a table of the subagents: name, job, model, effort, files it owns, what it returns, and what it must wait for. Give the exact `Agent` parameters (`model`, `effort`, `subagent_type`).
5. **Order of work**: phases, which run in parallel, where the orchestrator checks a subagent's result instead of trusting it (read the diff, run the tests).
6. **Verification and closing**: the Test, Lint and Type-check commands of `CLAUDE.md` (and Build if what ships changes) before saying done; commit everything including docs and handover; open the pull request; report what is not verified. Never merge.

Keep the prompt self-contained: the reader was not in this session, so name paths and ADR numbers, never "as discussed".

## 5. Return it
Show the prompt, then two lines: the orchestrator and effort chosen (with why), and the number of subagents with their models. Do not save it to a file unless the user asks.
