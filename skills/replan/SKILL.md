---
name: replan
description: Change the plan of a project - add a task, change one (scope, split, merge, order, blockers), drop one, or place a piece of work that came up in the middle of a task - and bring every document that depends on it up to date (task board, task cards, milestones, ADRs, glossary, architecture, status). Use when the user says "add a task", "change T12", "split this task", "we also need…", "drop this", "this came up while working", or invokes /replan.
---
Invocation: `/replan [what changes]`.

The plan is what every session works from, so it changes on purpose, in one place, with its reason written down. This skill never edits a row on its own: it works out everything the change touches, shows the before and the after, waits, and then writes all of it together.

It works on a repo set up with the documentation-first method (`/new-project`): board in `docs/PLAN.md`, one card per task in `docs/tasks/`. If they are not there, say so and stop. No product code is written here.

## 1. Understand the change
Name what kind it is; one request can hold several.

| Kind | It is |
|---|---|
| **Add** | Work that no task covers |
| **Change** | A task's scope, its «done when», its milestone |
| **Split** | One task is really two, or is too big for one session |
| **Merge** | Two tasks cannot be finished apart |
| **Reorder** | The blockers change: what must come before what |
| **Drop** | A task will not be done |
| **In flight** | Something came up while working on a task |

Before adding, look for a task that already covers it: the cheapest task is the one that does not need to exist.

For a piece **in flight**, decide with the user where it belongs:
- The current task's «Done when» cannot be true without it → it is part of the task. If the card did not say so, the card was wrong: change it and note why.
- It can wait and the task still finishes → a new task. Do not widen the current one in silence.
- It must be done first → a new task that blocks the current one, which goes to `blocked (T<nn>)` or waits.

Ask only what the request and the documents do not say, at most four questions, each with your recommendation: why now, what works at the end, how we know it is done, what it must wait for. When a new piece of work is still vague, pin it down first (`mattpocock-skills:grilling` if installed); a whole feature to break into tasks can go through `/to-tickets`, which writes to the same board.

## 2. Read what it touches
Only documents, and only those involved:
- `docs/PLAN.md` in full, and the cards of the tasks named or affected.
- What those cards link: ADRs, plans in `docs/plans/`.
- Every mention of the ids involved: `grep -rn "T12" docs CLAUDE.md CONTRIBUTING.md README.md`.
- Work not yet on `main`: `git fetch --all --prune`, the open pull requests, and for each unmerged branch `git diff origin/main...<branch> -- docs/PLAN.md docs/tasks`. A task claimed or changed there counts.

## 3. Work out the impact
| Kind | Always | Look also at |
|---|---|---|
| Add | New card; new row with milestone and blockers | Tasks that should now wait for it; the milestone's goal; new words for the glossary; a new part in the architecture |
| Change | The card's sections; one dated line in its `Notes` saying what changed and why | Tasks that name it in «Out of scope» or wait for it; its plan in `docs/plans/`; the ADRs it leans on |
| Split | The original keeps its id with the narrower scope; a new id takes the rest; both cards say where the line runs | Tasks blocked by the original: by which half now? |
| Merge | One id survives and its card says which task it absorbed; the other row and card go | Every mention of the id that went, re-pointed |
| Reorder | The «Blocked by» cells | That the blockers form no cycle; that nobody is already working on a task now blocked |
| Drop | Row and card removed; one line in «Non-goals» with the former id and the reason | Tasks that waited for it or relied on it: re-pointed, changed or dropped too |

And for any kind:
- **Milestones**: a milestone that gains or loses tasks may change its meaning or its date. A date nobody fixed stays «to be decided».
- **Decisions**: a change that goes against an accepted ADR needs a new ADR first (`/adr`); it is never done by editing the task.
- **Other documents**: `docs/STATUS.md` (one line, if what is «next» changes), `docs/ARCHITECTURE.md`, `docs/GLOSSARY.md`, commands in `CLAUDE.md` written as «created by T<n>», area owners in `CONTRIBUTING.md`, open questions in `PLAN.md` that the change answers or raises.

Rules that do not bend:
- **An id is never reused.** A new task takes the highest id ever used plus one, counting dropped ones (they are in «Non-goals» and in `git log`).
- **A `done` task is not rewritten.** What it left out or got wrong is a new task that says so.
- **Someone else's task is not changed without them.** If the task is claimed by another person or `in review`, stop and tell the user who to hear; record the answer in the card.
- **Every change says why**, in the card, with the date and who asked.

## 4. Show it, then wait
In chat, before writing anything:
- For each task: the row before and after, and the card sections that change. For a new task: title, why, what works at the end, done when, blocked by.
- The other documents touched, one line each saying what changes.
- What you are not sure of.

Wait for the go-ahead; change the proposal until it is approved.

## 5. Write
All of it in one go, so the documents never disagree with each other.
- Cards from `docs/tasks/_template.md`. A card is good when someone who was not here can say why the task exists, start it without asking, and tell when to stop. The full guide, with an example, is in the `new-project` skill beside this one: `${CLAUDE_SKILL_DIR}/../new-project/reference/tasks.md` (`${CLAUDE_SKILL_DIR}` is the folder that holds this `SKILL.md`).
- Rows on the board, with titles linked to their cards, in the words of `docs/GLOSSARY.md`.
- The other documents from step 3.

## 6. Check
- `bash "${CLAUDE_SKILL_DIR}/../new-project/scripts/scaffold.sh" --check <repo>` prints nothing: every task has a card, every card a row, every card says why, what and when it is done.
- The grep of step 2 again: no mention of an id that went, no link to a card that is gone.
- The blockers form no cycle; at least one task can be taken.

## 7. Commit
- A change that concerns only the task in progress is committed on that task's branch, with the work.
- Any other change to the plan goes on its own branch from `origin/main`, `<name>/replan-<short-desc>`, and through a pull request: the plan on `main` is what the others read. Pushing and opening it are asked for.
- The commit says what changed in the plan, why, who asked, and which documents followed. The next handover names it (`/end-session`).
