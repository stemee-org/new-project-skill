# Starting from something that exists

A «reference» is anything the new project is meant to rebuild, copy or do better than: our own prototype, an older version of the product, someone else's product or open-source repo, a specification, a design file, a set of PDFs. The reference is evidence to read, not a base to copy.

## 1. Name the relationship
Decide it with the user first; it becomes ADR `0002` and the first paragraph of `CLAUDE.md`.

| Relationship | When | What it means |
|---|---|---|
| **Rebuild** | Our prototype works but grew too fast to fix in place | New repo. The reference is read-only. Each part is ported as its own task, re-reading the original and applying the ADRs. Goal of the plan: parity, then what the prototype lacked |
| **Adopt in place** | The code is sound, the method is missing | Same repo. The kit is added around the code; documents describe what exists; the plan starts from today's defects. Nothing is moved in this session |
| **Inspiration** | Someone else's product or code | We take ideas and behaviour, never code, text, data or assets unless the licence allows it and the user confirms. Record the licence and what is taken, in the ADR |
| **Specification** | Documents, designs, requirements | The documents are sources: cite them (file, section), don't paste them. Contradictions between sources become open questions |

Ask before choosing «rebuild»: is the reference online? Are there users, data to migrate, public addresses that must keep working? Each answer is an ADR or a task, never an assumption.

## 2. Pin it
- Write exactly what the reference is: repo and branch `@` commit, or URL and date visited, or file name and version. Numbers quoted from it («82 entries, 15 tables») are counted at that pin.
- Read-only: this session never changes the reference, and the rule goes in `CLAUDE.md`.
- Material under copyright or with personal data goes in a folder that is gitignored (`sources/`), is cited only, and the ADR says so.

## 3. Read all of it before writing anything
Code, README and documents, git history (`git log`, `git shortlog -sn`), open issues and pull requests (`gh issue list`, `gh pr list`), config and env files (names only), tests, TODOs. For a large reference use one read-only agent per area, each returning this inventory:

- **Features**: what a user can do today, with the path where it lives.
- **Decisions already made**: choices visible in the code or documents (stack, data model, auth, pricing, what was ruled out), with where and when they were made.
- **Defects**: what is wrong in structure, not single bugs: several names for one thing, files too large, no migrations, no tests, logic scattered, secrets or local addresses in config.
- **Terms**: the words the product and the code use, and the synonyms.
- **Config**: every env var read, every external service.
- **Not finished**: half-built features, dead code, things documented but absent.
- **Who wrote what**: areas by author.

## 4. Turn the inventory into documents
| Inventory | Goes to | How |
|---|---|---|
| Relationship and pin | ADR `0002`, `CLAUDE.md` | One decision, alternatives included (fix in place; copy wholesale then tidy) |
| Decisions already made | One ADR each | Add an `Origin` line: where and when it was born. `Date` is the day it is recorded. `accepted` only if the user confirms it was really agreed; otherwise `proposed`. Say in the index which numbers are inherited |
| Decisions we now take differently | ADR with the old choice among the alternatives | This is the «do better» part: say what was wrong |
| Features | Tasks in `PLAN.md` | One task per portable piece, with «from: <path in the reference>». Order: foundations first, then the core, then what depends on it |
| Defects | `PLAN.md`, section «Known defects of the reference not to carry over» | One line each, with the task or ADR that fixes it |
| Not finished, new ideas | The last milestone, after parity | New features before parity are a non-goal |
| Terms | `GLOSSARY.md` | One name per thing; the column «not to be confused with» holds the old synonyms |
| Config | `.env.example` | Names and placeholders only. Never a value from the reference |
| Target structure | `ARCHITECTURE.md` | Plus a section «Differences from the reference» |
| Who wrote what | `CONTRIBUTING.md`, area owners | A proposal until the people confirm it |
| Open issues of the reference | `PLAN.md`, a table mapping each to a task, a non-goal or an open question | Issues that contradict an ADR are named |

The plan's goal says what «parity» means and how we know it is reached. Typical milestones: `M0` documents · `M1` foundations · … parity, part by part · launch (what the reference lacked to go live) · after (what it never had).

## 5. Rules that go in the new CLAUDE.md
- The reference, pinned, is read-only.
- One task at a time is ported, reading the original and applying the ADRs: never copy whole folders without a task in `docs/PLAN.md`.
- A defect found in the reference while porting is fixed here and written in the handover.
- For «inspiration»: what may and may not be taken, in one line, with the ADR.

And in `CONTRIBUTING.md`: porting = read the original, apply the ADRs and the corrections named in the task, add the tests.

## 6. For every part: keep, change, drop
The point is not parity, it is doing better. For each area write, in the task or its plan, what is kept as it is, what changes and why, and what is dropped. A part ported with no line under «change» was either perfect or not looked at.

## 7. Before closing the session
- List in the handover's `Watch out` everything inferred from reading: inherited ADRs marked `accepted`, area owners, counts, dates left open.
- Check nothing came across that should not: secrets, local IPs, personal data, copyrighted text.
- The reference itself is untouched (`git status` there, if it is a repo).
