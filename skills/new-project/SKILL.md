---
name: new-project
description: Set up a new project (or adopt an existing repo) with the documentation-first method - CLAUDE.md, docs/PLAN.md, STATUS, ADRs, handovers, plans, project skills, hooks, review agents - and fill it in from an interview and from any prototype, older codebase, competitor or spec the project is meant to rebuild, copy or improve on. Use when the user says "new project", "start a project", "set up the docs/method for this repo", "rebuild <prototype> properly", or invokes /new-project.
---
Invocation: `/new-project [target dir or name] [reference: path, repo URL, site, document…]`.

The output of this skill is a repository where a person or a Claude session that was never in this conversation can pick up any task by reading only the documents. No product code is written here: the first session ends with documents, a plan and a first handover (task `T00`).

Files of this skill, in the folder that holds this `SKILL.md` (written `<skill>` below; in Claude Code it is `${CLAUDE_SKILL_DIR}`). Read them when the step says so, not before:
- `<skill>/reference/method.md`: what each document is for, the rules that hold the method together, and why.
- `<skill>/reference/from-reference.md`: what to do when there is a prototype or anything else to rebuild, copy or do better than.
- `<skill>/templates/`: the kit that gets copied into the repo.
- `<skill>/scripts/scaffold.sh`: copies the kit without overwriting; `--check` lists what is still unfilled.

Outside Claude Code (Codex or another agent): where a step names a Claude Code tool, do the same thing with what you have. Ask the interview in chat instead of `AskUserQuestion`; read the reference yourself if you cannot start read-only subagents; skip the plugin step and say so. The kit still installs `.claude/` (skills, hooks, agents), because the people on the project may use Claude Code; add at the root an `AGENTS.md` of two lines that sends the agent to `CLAUDE.md` and `CONTRIBUTING.md`, so the rules live in one place.

## 1. Find out where you are
1. Target directory: empty, an existing repo with code, or a repo that already has some of these documents? Run `git status` and `ls -a` there. Never overwrite a file that exists: the script skips it and you merge by hand, keeping what the project already says.
2. Reference material: anything the user named or that sits next to the target (a prototype repo, an older version, a competitor's site, PDFs, a design file, open issues). If there is any, read `reference/from-reference.md` now: it changes the interview and almost every document.
3. Say which model this session runs on. The method wants the best available model as orchestrator (see `reference/method.md`, «Team»); if this is not it, say so and ask whether to go on.

## 2. Interview
Read first, ask second: never ask what the reference, the repo or the conversation already answers. Ask the rest in one or two rounds (`AskUserQuestion`), and offer a recommendation for each:
- What the product is and for whom, in two sentences. What "done" looks like for the first milestone.
- Who works on it (names; each with their own Claude?) and who owns which area.
- Language of the documents. Section headings stay in English whatever the answer, because the project skills look for them; code, comments and names in English.
- Stack and package manager: decided, or to decide? An open stack choice becomes a `proposed` ADR, not a guess.
- Git: where the repo lives, and whether `main` is pull-request only (the default of the kit).
- With a reference: the relationship to it (rebuild, evolve in place, inspiration, specification) and what is wrong with it today.

If the `mattpocock-skills` plugin is installed (step 4), its grilling skill is a good way to run this interview when the idea is still vague; the answers still land in the documents below, not in a file of its own.

## 3. Show the team, then wait
This skill follows the rule it installs. Before changing any file, print the team table in chat (wave, subtask, model, effort, why) and wait for the go-ahead. Typical shape:
- no reference, or a small one: one row, «orchestrator, no subagent»;
- a large reference: one read-only `Explore` agent per area of the prototype in the first wave (each returns an inventory, see `from-reference.md`), the orchestrator writes every document, and a last read-only agent checks the documents against the reference.
Subagents read; only the orchestrator writes documents, so one fact does not end up in two places.

## 4. Scaffold
1. `git init` if the directory is not a repo. In a repo with no commits, the kit as copied is the first commit on `main` (`chore: add the project kit`); everything after that happens on the branch `<name>/T00-docs-setup`. In a repo with history, create that branch first.
2. Run `bash <skill>/scripts/scaffold.sh <target>`. It copies `templates/` (a `dot-` prefix becomes a leading dot), keeps every existing file and prints what it skipped.
3. Plugins. `.claude/settings.json` of the kit enables `mattpocock-skills@claude-plugins-official` for everyone who opens the repo. Install it for the user now, asking first because it changes their Claude Code: `claude plugin install mattpocock-skills@claude-plugins-official`. Then list what it brings (`claude plugin details mattpocock-skills@claude-plugins-official`) and write in `CONTRIBUTING.md`, «Plugins», which of its skills the project uses and where they meet the method. Never describe its skills from memory. The rule of precedence is fixed: ADRs and the project's documents come first, a plugin skill second; what a plugin skill produces (a spec, tickets, a domain model) is stored in the project's documents (`docs/plans/`, the task board of `docs/PLAN.md`, `docs/GLOSSARY.md`, an ADR), never in a parallel set of files. Add other plugins the stack calls for the same way (marketplace in `extraKnownMarketplaces` if it is not the official one, a line in `enabledPlugins`, a paragraph in `CONTRIBUTING.md`).

## 5. Fill the documents
Read `reference/method.md` first. Write in this order, because each document leans on the ones before it:
1. `docs/decisions/`: `0001` gets the name of who decided. With a reference, `0002` records the relationship to it. Then one ADR per hard-to-reverse choice already made (stack, repo layout, hosting, data model, auth, what the product will never do). Update the index in `docs/decisions/README.md`.
2. `docs/GLOSSARY.md`: the words of the product, one meaning each. Where the reference uses several names for one thing, pick one here and use it everywhere after.
3. `docs/ARCHITECTURE.md`: the target picture at folder level, linking the ADRs.
4. `docs/PLAN.md`: goal, non-goals, milestones, task board. `M0`/`T00` is this session. The first tasks are always the foundations, each one small enough to finish and review alone: scaffold, quality tools (lint, format, type-check, test), CI. Dates nobody fixed stay «to be decided». Questions you could not answer go in `Open questions` with who must answer.
5. `CLAUDE.md`: description, stack, commands, conventions, rules, gotchas. Keep it under about 100 lines: only what a session cannot see from the code. A command that does not exist yet is listed as «created by T<n>», never faked. If the repo will have clearly separate parts, plan a `CLAUDE.md` per part for notes that only matter there. If anyone on the project uses Codex or another agent, add the two-line `AGENTS.md` that points here.
6. `CONTRIBUTING.md`: people, branch names, the team practice with the models table (adjust the last rows to this project's hard parts), area owners. Owners derived from a reference's history are a proposal: say so.
7. `README.md`: what it is, state, how to start, structure. For people, short.
8. `.env.example` (every variable, placeholders only), `.gitignore`, `.claude/protected-paths` (generated files, with the command that regenerates each), `.claude/settings.json` (allow the stack's test/lint/type-check/build commands; ask for dependency changes and pushes; deny the package managers the project does not use).
9. `.github/`: keep the generic CI until the scaffold task replaces it; note in the handover what it will and will not do on the first push.
10. `docs/STATUS.md` and the first handover in `docs/handover/` (`/handover` works from now on). In `Watch out`, list everything that was written from reading rather than confirmed by a person: those are the lines someone must re-read.

Each fact goes in one document and the others link to it. Do not pad: an empty section with one honest line («nothing yet») beats invented content.

## 6. Check
- `bash <skill>/scripts/scaffold.sh --check <target>` prints nothing: no `{{…}}` left. `<…>` placeholders remain only in the templates that are meant to be reused (`_template.md`, the handover README, the pull request and issue templates).
- Every relative link in the documents points to a file that exists; every ADR is in the index; every task has an ID, a milestone and a status.
- `.claude/settings.json` is valid JSON; the hooks are executable; `echo '{"tool_input":{"file_path":".env"}}' | .claude/hooks/protect-files.sh` exits 2.
- No secret, real address or personal data copied from the reference.
- Start a fresh look: would someone who was not here know what to do next from `docs/STATUS.md` alone?

## 7. Commit and hand over
- Commit on `<name>/T00-docs-setup` with a message that says what was written, from which sources, what was chosen by the user in this session and what is still unconfirmed.
- Creating a remote, pushing and opening a pull request are outward-facing: ask first. Never push to `main`, never merge without being asked.
- End with a short report: the documents written, the decisions recorded, the open questions, and the first task to take (`T01`) with the reminder that the next session starts with `/start-session`.
