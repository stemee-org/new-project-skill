---
name: new-project
description: Set up a new project (or adopt an existing repo) with the documentation-first method. Copies the whole documentation kit (CLAUDE.md, docs/PLAN.md, task cards, STATUS, ADRs, handovers, project skills, hooks, review agents), installs the mattpocock-skills and ponytail plugins, then reads any prototype, older codebase, competitor or spec the project is meant to rebuild or improve on, asks the technical questions reading cannot answer, and writes tasks that explain themselves. Use when the user says "new project", "start a project", "set up the docs/method for this repo", "rebuild <prototype> properly", or invokes /new-project.
---
Invocation: `/new-project [target dir or name] [reference: path, repo URL, site, document…]`.

The output is a repository where a person or an agent that was never in this conversation can pick up any task by reading only the documents. No product code is written here: the session ends with the documents, the tasks and a first handover (task `T00`).

The order is fixed, and the first two steps need no answer from the user, so run them straight away:

1. **Kit**: from zero files to every documentation file.
2. **Plugins**: `mattpocock-skills` and `ponytail`.
3. **Questions and tasks**: read the reference, ask what reading cannot answer, write the tasks.

Then fill the rest of the documents (4), check (5), commit and hand over (6). There is one point where you stop and wait: the task breakdown in step 3.

Files of this skill, in the folder that holds this `SKILL.md` (written `<skill>` below; in Claude Code it is `${CLAUDE_SKILL_DIR}`). Read each when its step says so:
- `<skill>/scripts/scaffold.sh`: copies the kit without overwriting; `--check` lists what is still unfilled.
- `<skill>/templates/`: the kit.
- `<skill>/reference/from-reference.md`: how to read a reference and where each finding goes.
- `<skill>/reference/tasks.md`: the technical questions and what makes a task good.
- `<skill>/reference/method.md`: what each document is for and the rules behind the method.

Running it again on the same repo is safe: the script skips existing files, a plugin already installed is left alone, and you go on from the first thing still unfilled (`scaffold.sh --check` says which).

## 1. Kit
1. Target: the directory the user named, otherwise the current one. Look before writing: `git status` and `ls -a` there. `git init` if it is not a repo.
2. Run `bash <skill>/scripts/scaffold.sh <target>`. It copies `templates/` (a `dot-` prefix becomes a leading dot), keeps every file that exists and prints what it kept. A file it kept is merged by hand later, keeping what the project already says: never overwrite it.
3. Commit. In a repo with no commits, the kit as copied is the first commit on `main` (`chore: add the project kit`) and everything after happens on the branch `<name>/T00-docs-setup`. In a repo with history, create that branch first and commit the kit there.

Every document now exists, with `{{…}}` where the project's own content goes. Do not ask anything yet.

## 2. Plugins
Invoking this skill is the request to install them: say what you run and run it, without asking again.

```
claude plugin install mattpocock-skills@claude-plugins-official
claude plugin marketplace add DietrichGebert/ponytail
claude plugin install ponytail@ponytail
```

- Check first with `claude plugin list`: skip what is already there.
- If `claude` is not on the `PATH` or a command fails, do not stop: give the user the lines to type themselves (`/plugin install mattpocock-skills@claude-plugins-official`, `/plugin marketplace add DietrichGebert/ponytail`, `/plugin install ponytail@ponytail`), write in the handover that the plugins are still to install, and go on.
- A plugin installed now is not loaded in this session: its skills work after `/reload-plugins` or in the next session. So nothing in the steps below depends on them; say so in the final report.
- Install only from those two sources. Ponytail's author states it ships from `DietrichGebert/ponytail` and nowhere else.
- The kit's `.claude/settings.json` already enables both for the repo, so Claude Code offers them to whoever opens it. The kit also ships what the `mattpocock-skills` engineering skills look for (`docs/agents/issue-tracker.md`, `docs/agents/domain.md`, the `Agent skills` block of `CLAUDE.md`), pointing at this method's documents: `/setup-matt-pocock-skills` does not need to be run, and running it would move tasks and glossary somewhere else.
- Then `claude plugin details <plugin>` for each and correct `CONTRIBUTING.md`, «Plugins», against what is really installed: drop a skill that is not listed, add one the project will use. Never describe a plugin skill from memory.

Codex: `codex plugin marketplace add mattpocock/skills`, `codex plugin add mattpocock-skills@mattpocock`, `codex plugin marketplace add DietrichGebert/ponytail`, `codex plugin add ponytail@ponytail`. Any other agent: follow each repo's README; if there is no way to install, say so and go on.

## 3. Questions and tasks
Read `reference/tasks.md` now, and `reference/from-reference.md` if there is a reference: anything the user named or that sits next to the target (a prototype repo, an older version, a competitor's site, PDFs, a design file, open issues).

1. **Read all of it first.** Pin the reference (repo and branch `@` commit, or URL and date) and build the inventory described in `from-reference.md`. A large reference is read by one read-only agent per area, each returning that inventory; they read, only you write. Never change the reference.
2. **Ask the technical questions.** Only what the reference, the repo and the conversation do not answer, and only questions whose answer changes a task, an ADR or a non-goal. Lead each one with what you found and what you recommend, so that a word is enough to answer. Rounds of at most four questions (`AskUserQuestion`), most consequential first; stop when another answer would not change the plan. The list to draw from is in `tasks.md`.
3. **Record what was decided** before slicing, because tasks lean on it: one ADR per hard-to-reverse answer in `docs/decisions/` (`0002` is the relationship to the reference), the product's words in `docs/GLOSSARY.md`, the target structure in `docs/ARCHITECTURE.md`.
4. **Draft the breakdown and show it in chat**: a numbered list with, for each task, the title, why it exists, what works when it is done, and what blocks it. Ask whether the size is right, whether the order is right, and what to merge, split or drop. **Wait for the answer**, and repeat until approved.
5. **Write the tasks**: one card per task in `docs/tasks/T<nn>-<slug>.md` from `docs/tasks/_template.md`, and its row on the board of `docs/PLAN.md`. Then the rest of `PLAN.md`: goal, non-goals, milestones, open questions with who must answer.

Without a reference the step is the same, shorter: the questions are about the product (what it is and for whom, what the first milestone must do, stack decided or to decide) and the tasks come from the answers. An open stack choice is a `proposed` ADR and a task to decide it, not a guess.

A task is good when someone who was not here can start it from the card alone and can tell why it exists. `tasks.md` has the test and an example of each kind.

## 4. Fill the rest
Read `reference/method.md`. Decisions, glossary, architecture, plan and tasks are written; now, in this order:
1. `CLAUDE.md`: description, stack, commands, conventions, rules, gotchas. Under about 100 lines: only what a session cannot see from the code. A command that does not exist yet is written as «created by T<n>», never faked. Separate parts of the repo get their own `CLAUDE.md` for notes that only matter there.
2. `CONTRIBUTING.md`: people, branch names, the team practice with the models table (adjust the last rows to this project's hard parts), area owners. Owners derived from a reference's history are a proposal: say so.
3. `README.md`: what it is, state, how to start, structure. For people, short.
4. `.env.example` (every variable, placeholders only), `.gitignore`, `.claude/protected-paths` (generated files, with the command that regenerates each), `.claude/settings.json` (allow the stack's test, lint, type-check and build commands; ask for dependency changes and pushes; deny the package managers the project does not use).
5. `.github/`: keep the generic CI until the scaffold task replaces it; note in the handover what it will and will not do on the first push.
6. `docs/STATUS.md` and the first handover in `docs/handover/`. In `Watch out`, list everything written from reading and not confirmed by a person: those are the lines someone must re-read.
7. If anyone on the project uses Codex or another agent: an `AGENTS.md` of two lines at the root that sends the agent to `CLAUDE.md` and `CONTRIBUTING.md`, so the rules live in one place.

Each fact goes in one document and the others link to it. Do not pad: a section with one honest line («nothing yet») beats invented content.

## 5. Check
- `bash <skill>/scripts/scaffold.sh --check <target>` prints nothing: no `{{…}}` left, every task on the board has a card, every card says why, what and when it is done.
- Every relative link points to a file that exists; every ADR is in the index; every task has a milestone and a status; the blockers form no cycle.
- `.claude/settings.json` is valid JSON; the hooks are executable; `echo '{"tool_input":{"file_path":".env"}}' | .claude/hooks/protect-files.sh` exits 2.
- No secret, real address or personal data came across from the reference, and the reference is untouched (`git status` there).
- Take the first task that nothing blocks and read only its card and what it links: could you start? If not, the card is missing something; fix it and try the next one.

## 6. Commit and hand over
- Commit on `<name>/T00-docs-setup` with a message that says what was written, from which sources, what the user chose in this session and what is still unconfirmed.
- Creating a remote, pushing and opening a pull request are outward-facing: ask first. Never push to `main`, never merge without being asked.
- End with a short report: the documents written, the decisions recorded, the tasks (how many, per milestone), the open questions, whether the two plugins are installed and that they load after `/reload-plugins`, and the first task to take, with the reminder that the next session starts with `/start-session`.
