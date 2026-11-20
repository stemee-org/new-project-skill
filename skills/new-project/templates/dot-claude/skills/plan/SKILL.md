---
name: plan
description: Write a feature plan in docs/plans/ before coding. Use when the user asks to plan, design or scope a feature, or before any change touching more than a few files.
---
1. Find or create the task in `docs/PLAN.md`; if someone else owns it, stop and tell the user.
2. Read `docs/ARCHITECTURE.md`, relevant ADRs in `docs/decisions/`, and the code the feature touches. If the task ports something from a reference, read the original too and write in `Approach` what is kept, what changes and why, and what is dropped. Don't write code yet.
3. Ask the user about anything you would otherwise have to guess (scope, UX, data shape).
4. Write `docs/plans/<task-id>-<short-name>.md` from `docs/plans/_template.md`. Steps must be small, each leaving the app working and testable.
5. Fill the `Team` section: split the work into waves of subtasks and give each one a model and an effort sized on the work (table in `CONTRIBUTING.md`, «Models and efforts»). Writers in the same wave never share files; the last wave is the independent review. The practice is in `CONTRIBUTING.md` («How a task is built»).
6. Flag any step that needs a hard-to-reverse decision; suggest an ADR for it.
7. Show the plan and wait for approval before implementing. In the same message print the `Team` table in chat (wave, subtask, model, effort, why) and name the model this session runs on: the user must see who does what without opening the file. If the session is not the orchestrator model named in `CLAUDE.md`, say so before the table and ask whether to go on. When implementing, orchestrate the team as the plan says, verify each wave yourself before committing it, and tick off steps in the plan file as you go.
