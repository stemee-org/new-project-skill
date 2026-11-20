---
name: adr
description: Record an architecture decision as a new ADR in docs/decisions/. Use when a hard-to-reverse choice is made (library, data model, auth, hosting, API shape) or the user says "record this decision".
---
1. List `docs/decisions/` and take the next free number `NNNN`.
2. Create `docs/decisions/NNNN-<kebab-title>.md` from `docs/decisions/_template.md`. Fill Context, Decision, Alternatives and Consequences from the conversation; ask the user for anything missing. Status: `proposed` unless the user says it's decided.
3. If it replaces an earlier decision, change only the old record's status line to `superseded by NNNN`. Never edit an accepted record otherwise.
4. Add a row to the index in `docs/decisions/README.md`.
5. If the decision changes how the system fits together, update `docs/ARCHITECTURE.md` (link the ADR, don't copy it).
