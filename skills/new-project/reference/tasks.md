# Questions and tasks

The tasks are what the next sessions will work from. A vague task costs every session that reads it; a task with no reason gets done to the letter and wrong. So: read, ask what reading cannot answer, then write tasks that explain themselves.

## 1. The technical questions
Ask after reading, never before: a question the reference answers wastes the user's attention and shows it was not read.

Every question has three parts:
- **What you found**, with the path: «`api/import.py` builds its SQL by joining strings.»
- **What you recommend and why**: «Use parameterised queries: string-built SQL is the first thing a security review will stop.»
- **What the answer changes**: a task, an ADR, a non-goal. If nothing changes whichever way it goes, do not ask.

Draw from this list; skip what is already answered, add what this reference raises.

| Area | What to settle |
|---|---|
| Relationship | Rebuild, adopt in place, inspiration or specification (`from-reference.md`, §1). Is the reference live, with users, data or public addresses that must keep working? |
| Scope | Which features are in the first milestone, which come later, which are dropped for good. What «parity» means and how we will know it is reached |
| Stack | For each layer (language, framework, database, package manager): keep the reference's choice or change it, and what was wrong with it |
| Structure | One repo or several, the parts and where the line between them runs, what the reference mixes that should be separate |
| Data | The data model: what stays, what is renamed, what is wrong. Existing data to migrate, and how schema changes will be made from now on |
| Access | Who logs in and how, roles, what is public. Payments, if any |
| Outside world | Every external service the reference calls: keep, replace, drop. Where it will be hosted and how it is deployed |
| Quality bar | What is tested and how (unit, integration, end to end), what CI must block, languages of the interface, accessibility, performance that matters |
| Known pain | What breaks or slows people down today that the reference's code does not show |
| People | Who works on it, who owns which area, language of the documents |

Order by consequence: an answer that reshapes many tasks (relationship, scope, stack) comes before one that touches a single task. Stop when the next answer would not change the plan; what is still open goes in `Open questions` of `PLAN.md` with who must answer, and the tasks that depend on it say so.

An answer is recorded where it belongs, not in a transcript: hard to reverse → ADR; a thing we will not do → non-goal; a word → glossary; everything else → the `Why` of the task it shaped.

## 2. Slicing
- **Foundations first, and small**: scaffold, quality tools (lint, format, type-check, test), CI. Each one finishes and is reviewed alone.
- **Then a thin slice through everything**: the first product task makes one real thing work end to end (data, logic, interface, test), however small. It proves the structure before twenty tasks rely on it.
- **Vertical, not by layer**: «a customer can download an invoice as PDF» is a task; «all the models», «all the endpoints» are not. A finished task can be shown or verified on its own.
- **One session each**: a task fits one working session with its tests and its review. Bigger than that, split it; a task that is three tool calls belongs inside another.
- **A wide mechanical change** (a rename across the codebase) is the exception: add the new form beside the old, migrate in batches, remove the old.
- **Blockers are real**: a task lists only the tasks that must be done before it can start. Order follows from that: whatever nothing blocks can be taken now, also by two people at once.
- **Unknowns are tasks too**: «decide X» or «try Y on a throwaway branch» with a written outcome (an ADR, a note in the plan) beats a product task built on a guess.
- With a reference, each ported part is its own task with where the original lives and what is kept, changed and dropped (`from-reference.md`, §6).

## 3. The card
One file per task, `docs/tasks/T<nn>-<slug>.md`, from the template. The board row holds what changes (owner, branch, status, blockers); the card holds what does not.

| Section | Says | Wrong when |
|---|---|---|
| Title | What works when it is done | It names an activity («refactor», «work on auth») |
| Why | Why it exists and why at this point: what it unblocks, which answer or ADR it comes from, what goes wrong without it | It repeats the title, or says «needed for the project» |
| What to build | The behaviour at the end, seen by whoever uses it | It is a list of files to create |
| From the reference | Where the original is, at the pin; keep, change (and why), drop (and why) | Nothing is under «change»: either it was perfect or it was not looked at |
| Done when | Checks someone can run or see | «Works correctly», «is complete» |
| Out of scope | What a reader would expect here and is elsewhere, with the task | Left empty on a task with obvious neighbours |
| Notes | ADRs that apply, open questions with who answers, pitfalls seen while reading | — |

Use the words of `docs/GLOSSARY.md`, in the language of the documents, in full sentences. No abbreviation that is not in the glossary.

### The test
Give the card, and only the card with what it links, to someone who was not in this session. Can they say why the task exists, start it without asking, and tell when to stop? Three yeses, or the card is not finished.

### An example
Not good:

> **T07 · Invoices backend.** Port the invoice code from the prototype. Done when it works.

It says nothing about why, what is ported, what changes or how to check it. Good:

> **T07 · A customer can create an invoice and see its total**
>
> **Why.** It is the first feature, and the thin slice through database, API and page: T08–T12 copy its shape, so a mistake here is cheapest to fix now. Amounts follow ADR 0006 (integers in cents).
>
> **What to build.** A logged-in customer adds lines to a new invoice, saves it and sees net, tax and total; reopening it shows the same numbers.
>
> **From the reference.** `server/invoices.js` @ `3f9c2ab`. Keep: the rounding rule, per line and then summed. Change: amounts become integer cents, because the prototype's floats lose a cent on some totals (ADR 0006); the tax rate comes from the customer's country, not from a constant. Drop: the CSV export, which nobody used (non-goal 3).
>
> **Done when.** ☐ The totals match the worked cases in `docs/plans/T07-invoices.md`, a zero-rated line included. ☐ A line with a negative quantity is refused with a message that names the line. ☐ Test, lint and type-check pass.
>
> **Out of scope.** PDF download (T08). Editing an invoice already sent (T11).

## 4. The breakdown, before the files
Show the breakdown in chat first: number, title, why in one line, what works at the end, blocked by. Ask about size, order, and what to merge, split or drop. Write the cards only after the user approves it: rewriting twenty files costs more than rewriting a list.
