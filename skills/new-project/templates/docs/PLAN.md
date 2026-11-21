# Plan

## Goal
{{What success looks like, in 2–3 sentences, and how we know it is reached. With a reference: what «parity» means, and the pin (repo `branch` @ `commit`); each task's card says where its original is.}}

## Non-goals
- {{Things we decided NOT to do, so nobody starts them. Link the ADR.}}

## Milestones
| # | Milestone | Target date | Status |
|---|---|---|---|
| M0 | Documents, rules and plan | {{YYYY-MM-DD}} | in progress |
| M1 | Foundations: repo, quality tools, CI | {{date or «to be decided»}} | planned |
| {{M2}} | {{…}} | {{…}} | planned |

## Task board
<!-- Claim a task by putting your name + branch BEFORE starting. One owner per task. -->
Each task has a card in [tasks/](tasks/) that says why it exists, what to build and when it is done; the title links to it. This row is the only home of blockers, owner, branch and status. A task can be taken when every task in «Blocked by» is `done`.

| ID | Task | Milestone | Blocked by | Owner | Branch | Status |
|---|---|---|---|---|---|---|
| T00 | Fill documents, ADRs, plan and tasks {{from the interview / from the reference}} | M0 | — | {{name}} | `{{name}}/T00-docs-setup` | in progress |
| T01 | [Scaffold: {{workspace, apps, root scripts, `.gitignore`}}](tasks/T01-scaffold.md) | M1 | — | — | — | todo |
| T02 | [Quality tools: {{lint, format, type-check, test runner}}](tasks/T02-quality-tools.md) | M1 | T01 | — | — | todo |
| T03 | [CI: {{replace the generic workflow with one for this stack}}](tasks/T03-ci.md) | M1 | T02 | — | — | todo |
| {{T04}} | {{[Title: what works when it is done](tasks/T04-slug.md)}} | {{…}} | {{…}} | — | — | todo |

Status values: `todo` · `claimed` · `in progress` · `in review` · `done` · `blocked (reason)`

{{With a reference, add here: «### Known defects of the reference not to carry over» (one line each, with the task or ADR that fixes it) and, if it has open issues, a table mapping each to a task, a non-goal or an open question.}}

## Open questions
- {{Question}} (asked by {{name}}, {{date}}; to be answered by {{name}})
