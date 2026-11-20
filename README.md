# new-project

Una skill per agenti di programmazione (Claude Code, Codex) che imposta un progetto nuovo con il metodo «prima i documenti»: `CLAUDE.md`, piano con task e milestone, stato, ADR, handover, piani di feature, skill di progetto, hook e agenti di revisione. Funziona anche quando esiste già qualcosa da ricostruire, copiare o migliorare: un prototipo, una versione vecchia, il prodotto di qualcun altro, una specifica.

Il metodo nasce dalla ricostruzione di stemee a partire dal prototipo abacus (novembre 2026): il kit è quello usato lì, ripulito da ciò che era specifico del progetto.

## Cosa fa
`/new-project [cartella o nome] [riferimento]`

1. Capisce da dove si parte (cartella vuota, repo esistente, materiale di riferimento).
2. Intervista: chiede solo ciò che non può leggere.
3. Mostra la squadra (chi fa cosa, con quale modello) e aspetta l'ok.
4. Copia il kit senza sovrascrivere nulla.
5. Riempie i documenti, in ordine: decisioni, glossario, architettura, piano, `CLAUDE.md`, `CONTRIBUTING.md`, `README.md`, stato e primo handover.
6. Controlla (segnaposto rimasti, link, hook) e committa sul branch `<nome>/T00-docs-setup`.

Non scrive codice di prodotto: la prima sessione finisce con i documenti e il primo task da prendere.

## Installazione
**Claude Code, come plugin** (si aggiorna da solo con il marketplace):
```
/plugin marketplace add stemee-org/new-project-skill
/plugin install new-project@stemee-org
```

**Claude Code o Codex, come skill personale** (un link alla copia clonata: `git pull` aggiorna tutto):
```
git clone https://github.com/stemee-org/new-project-skill.git
cd new-project-skill
./install.sh claude     # ${CLAUDE_CONFIG_DIR:-~/.claude}/skills/new-project
./install.sh codex      # ${CODEX_HOME:-~/.codex}/skills/new-project
./install.sh <cartella-delle-skill>
```
Con più profili di Claude Code si lancia una volta per profilo, con `CLAUDE_CONFIG_DIR` impostata. La repo è privata: serve l'accesso a `stemee-org`.

## Struttura
- `skills/new-project/SKILL.md`: il percorso, passo per passo.
- `skills/new-project/reference/method.md`: il metodo e le sue ragioni.
- `skills/new-project/reference/from-reference.md`: partire da un prototipo o da un altro riferimento.
- `skills/new-project/templates/`: il kit copiato nel progetto. I file con il prefisso `dot-` diventano file con il punto (`dot-claude/` → `.claude/`).
- `skills/new-project/scripts/scaffold.sh`: copia il kit; con `--check` elenca i segnaposto `{{…}}` rimasti.
- `.claude-plugin/`: manifest del plugin e del marketplace.

## Stato
Versione 0.1.0. Provato lo scaffold (copia, file esistenti lasciati intatti, hook, JSON valido) e la validazione del plugin. Non ancora provata dall'inizio alla fine su un progetto vero, né dentro Codex: il kit abilita il plugin `mattpocock-skills@claude-plugins-official`, e quali delle sue skill usare si scrive progetto per progetto dopo averlo installato.

## Modificarla
Il kit è in inglese; la lingua dei documenti del progetto si sceglie nell'intervista. Chi cambia una regola del metodo la cambia in `reference/method.md` e nei template che la ripetono (`CLAUDE.md`, `CONTRIBUTING.md`, le skill in `templates/dot-claude/skills/`): si cerca la vecchia formulazione con `grep` prima di committare.
