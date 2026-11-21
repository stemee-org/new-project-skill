# new-project

Una skill per agenti di programmazione (Claude Code, Codex) che imposta un progetto nuovo con il metodo «prima i documenti». Fa tre cose, in quest'ordine:

1. **Crea i file.** Da zero file a tutta la documentazione: `CLAUDE.md`, piano con task e milestone, una scheda per task, stato, ADR, handover, piani di feature, skill di progetto, hook e agenti di revisione.
2. **Installa due plugin**: [`mattpocock-skills`](https://github.com/mattpocock/skills) e [`ponytail`](https://github.com/DietrichGebert/ponytail).
3. **Fa le domande tecniche e scrive i task.** Se esiste qualcosa da ricostruire, copiare o migliorare (un prototipo, una versione vecchia, il prodotto di qualcun altro, una specifica), lo legge tutto, chiede solo ciò che la lettura non dice, e ne ricava task che si spiegano da soli.

Il metodo nasce dalla ricostruzione di stemee a partire da un prototipo (novembre 2026): il kit è quello usato lì, ripulito da ciò che era specifico del progetto.

## Cosa fa
`/new-project [cartella o nome] [riferimento]`

1. **Kit.** Copia i documenti nella cartella senza sovrascrivere nulla e li committa. Non chiede niente.
2. **Plugin.** Installa `mattpocock-skills` e `ponytail` e li abilita per chi apre la repo. Il kit contiene già i file che le skill di `mattpocock-skills` cercano (`docs/agents/`), puntati sui documenti del metodo: non serve lanciare `/setup-matt-pocock-skills`. I plugin si caricano dopo `/reload-plugins` o alla sessione successiva.
3. **Domande e task.** Legge il riferimento, poi fa le domande tecniche: ognuna dice cosa ha trovato, cosa consiglia e cosa cambia con la risposta. Registra le decisioni (ADR, glossario, architettura), mostra in chat l'elenco dei task e **aspetta l'ok**; solo allora scrive una scheda per task in `docs/tasks/` e la riga nel tabellone di `docs/PLAN.md`. Senza riferimento le domande sono sul prodotto e i task nascono dalle risposte.
4. **Resto dei documenti**: `CLAUDE.md`, `CONTRIBUTING.md`, `README.md`, configurazione, stato e primo handover.
5. **Controllo**: nessun segnaposto rimasto, ogni task ha la sua scheda, link e hook a posto.
6. **Commit** sul branch `<nome>/T00-docs-setup`. Push e pull request solo dopo aver chiesto.

Non scrive codice di prodotto: la prima sessione finisce con i documenti, i task e il primo da prendere.

### Com'è fatto un task
Una scheda dice: **perché** esiste e perché a quel punto (cosa sblocca, da quale risposta o ADR nasce), **cosa** funziona alla fine visto da chi lo usa, da dove viene nel riferimento e cosa si **tiene, cambia o toglie**, **quando è finito** (controlli che si possono eseguire o vedere), cosa resta **fuori**. La prova: chi non era nella sessione, con la sola scheda, sa dire perché il task esiste, può cominciarlo e sa quando fermarsi. Criteri ed esempio in `skills/new-project/reference/tasks.md`.

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
Con più profili di Claude Code si lancia una volta per profilo, con `CLAUDE_CONFIG_DIR` impostata.

## Struttura
- `skills/new-project/SKILL.md`: il percorso, passo per passo.
- `skills/new-project/reference/tasks.md`: le domande tecniche e com'è fatto un buon task.
- `skills/new-project/reference/from-reference.md`: leggere un prototipo o un altro riferimento, e dove va ogni cosa trovata.
- `skills/new-project/reference/method.md`: il metodo e le sue ragioni.
- `skills/new-project/templates/`: il kit copiato nel progetto. I file con il prefisso `dot-` diventano file con il punto (`dot-claude/` → `.claude/`).
- `skills/new-project/scripts/scaffold.sh`: copia il kit; con `--check` elenca i segnaposto `{{…}}` rimasti, i task senza scheda e le schede incomplete.
- `tests/run.sh`: prova lo scaffold e il controllo su una cartella temporanea.
- `.claude-plugin/`: manifest del plugin e del marketplace.

## Stato
Versione 0.2.0. Provati con `./tests/run.sh`: la copia del kit da zero, i file esistenti lasciati intatti, gli hook, `settings.json` valido con i due plugin abilitati, il controllo dei task. Provata la validazione del plugin (`claude plugin validate .`). Non ancora provati: il percorso dall'inizio alla fine su un progetto vero, l'installazione di `ponytail` dai comandi della skill, l'uso dentro Codex.

## Modificarla
Il kit è in inglese; la lingua dei documenti del progetto si sceglie nell'intervista. Chi cambia una regola del metodo la cambia in `reference/method.md` e nei template che la ripetono (`CLAUDE.md`, `CONTRIBUTING.md`, le skill in `templates/dot-claude/skills/`): si cerca la vecchia formulazione con `grep` prima di committare.
