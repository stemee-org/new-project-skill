# Domain docs

How skills should use this repo's domain documentation. Single context: one glossary and one set of decisions for the whole repo.

## Before exploring, read these
- **`docs/GLOSSARY.md`**: the project's words, one meaning each.
- **`docs/decisions/`**: the ADRs, indexed in `docs/decisions/README.md`. Read those that touch the area you are about to work in.
- **`docs/ARCHITECTURE.md`**: how the system fits together, at folder level.

There is no `GLOSSARY.md` at the root and no `docs/adr/`: do not create them.

## Use the glossary's vocabulary
When your output names a domain concept (a task title, a test name, a proposal), use the term as `docs/GLOSSARY.md` defines it, not a synonym from its «Not to be confused with» column. A concept that is missing is either language the project does not use, or a gap: add the term to the glossary in the same change.

## Decisions
- A new decision is a new file, written with `/adr` from `docs/decisions/_template.md` and added to the index.
- An accepted ADR is never edited: it is superseded by a new one.
- If your output contradicts an ADR, say so explicitly, with the number, and do not go ahead on your own.
