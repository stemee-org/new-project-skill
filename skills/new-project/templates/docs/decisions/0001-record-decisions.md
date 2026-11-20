# 0001 — Record decisions as ADRs
- **Status:** accepted
- **Date:** {{YYYY-MM-DD}}
- **Decided by:** {{names}}

## Context
People and Claude sessions join the project at different times and need to know why things are the way they are, without re-arguing settled choices.

## Decision
We record every hard-to-reverse decision as an Architecture Decision Record in `docs/decisions/`, one numbered file each, never edited once accepted.

## Alternatives considered
- Decisions in chat / PR comments — rejected because they're hard to find later.
- One big DECISIONS.md — rejected because concurrent edits conflict.

## Consequences
Small overhead per decision; in exchange, reversing a decision requires a new ADR that explains why.
