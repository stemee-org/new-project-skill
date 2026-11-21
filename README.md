# relay

Un plugin per agenti di programmazione (Claude Code, Codex) per lavorare con il metodo «prima i documenti»: ogni sessione parte dai documenti della repo e finisce aggiornandoli, così la successiva, di una persona o di un agente che non c'era, può riprendere qualunque task. Come in una staffetta, il testimone sono i documenti.

Il metodo nasce dalla ricostruzione di stemee a partire da un prototipo (novembre 2026): il kit è quello usato lì, ripulito da ciò che era specifico del progetto.

## Le skill
| Quando | Skill | Cosa fa |
|---|---|---|
| Una volta, all'inizio | `/new-project` | Imposta la repo: documenti, plugin, domande tecniche, task |
| A ogni inizio sessione | `/start-session` | Legge i documenti, chiede quali task fare, carica le skill che servono |
| Quando il piano cambia | `/replan` | Aggiunge, modifica, divide, unisce o toglie task, e aggiorna tutti i documenti che ne dipendono |
| Prima di un task grande | `/plan` | Scrive il piano della feature e lo fa approvare |
| A ogni scelta difficile da rovesciare | `/adr` | Registra la decisione |
| Per passare un task a un'altra sessione | `/write-prompt` | Scrive il prompt per un orchestratore con la sua squadra |
| A ogni fine sessione | `/end-session` | Verifica, revisione, handover, stato, commit, pull request |

Installate dal plugin si chiamano `/relay:<nome>`.

### `/new-project [cartella o nome] [riferimento]`
1. **Kit.** Copia i documenti nella cartella senza sovrascrivere nulla e li committa: `CLAUDE.md`, piano con task e milestone, una scheda per task, stato, ADR, handover, piani di feature, hook e agenti di revisione. Non chiede niente.
2. **Plugin.** Installa per quella repo [`mattpocock-skills`](https://github.com/mattpocock/skills) e [`ponytail`](https://github.com/DietrichGebert/ponytail), e li abilita insieme a `relay` per chi la apre. Il kit contiene già i file che le skill di `mattpocock-skills` cercano (`docs/agents/`), puntati sui documenti del metodo: non serve lanciare `/setup-matt-pocock-skills`. I plugin si caricano dopo `/reload-plugins` o alla sessione successiva.
3. **Domande e task.** Se esiste qualcosa da ricostruire, copiare o migliorare (un prototipo, una versione vecchia, il prodotto di qualcun altro, una specifica), lo legge tutto, poi fa le domande tecniche: ognuna dice cosa ha trovato, cosa consiglia e cosa cambia con la risposta. Registra le decisioni, mostra in chat l'elenco dei task e **aspetta l'ok**; solo allora scrive una scheda per task in `docs/tasks/` e la riga nel tabellone di `docs/PLAN.md`. Senza riferimento le domande sono sul prodotto.
4. **Resto dei documenti, controllo, commit** sul branch `<nome>/T00-docs-setup`. Push e pull request solo dopo aver chiesto.

Non scrive codice di prodotto: la prima sessione finisce con i documenti, i task e il primo da prendere.

### `/start-session`
1. **Legge i documenti**, solo i Markdown e non il codice: stato, ultimo handover, piano. Guarda anche branch e pull request non ancora unite, dove può esserci un task già preso.
2. **Chiede quali task fare**, proponendo quelli che nessuno blocca e nessuno ha preso; legge la scheda di quelli scelti e li segna nel piano.
3. **Carica le skill degli altri due plugin** che servono a quel lavoro: `mattpocock-skills` per le parti tecniche (`tdd`, `diagnosing-bugs`, `codebase-design`, `domain-modeling`…), `ponytail` per il codice, prima della prima riga. ADR e documenti del progetto vengono comunque prima di ogni skill.
4. Mostra la squadra e aspetta l'ok.

### `/replan [cosa cambia]`
Per cambiare il piano a progetto avviato: un task nuovo, uno da modificare, dividere, unire, riordinare o togliere, oppure un pezzo di lavoro emerso a metà di un task (la skill decide con te se fa parte del task in corso o è un task nuovo).

1. Capisce il tipo di modifica e chiede solo ciò che manca.
2. Legge il piano, le schede coinvolte e ogni punto dei documenti che le nomina, anche sui branch non uniti.
3. Calcola l'impatto: tabellone, schede, blocchi degli altri task, milestone, ADR, glossario, architettura, stato.
4. **Mostra il prima e il dopo e aspetta l'ok.**
5. Scrive tutto insieme, controlla la coerenza, committa.

Regole: un id non si riusa mai; un task `done` non si riscrive, si apre un task di seguito; il task di un'altra persona non si cambia senza sentirla; una modifica che va contro un ADR passa prima da un ADR nuovo; ogni modifica lascia nella scheda data e motivo.

### `/end-session`
Verifica (test, lint, type-check), revisione del diff, handover, stato e riga del task, commit, e dopo aver chiesto push e pull request. Se ci si ferma a metà di un task scrive solo handover e stato e committa, senza pull request.

### Com'è fatto un task
Una scheda dice: **perché** esiste e perché a quel punto (cosa sblocca, da quale risposta o ADR nasce), **cosa** funziona alla fine visto da chi lo usa, da dove viene nel riferimento e cosa si **tiene, cambia o toglie**, **quando è finito** (controlli che si possono eseguire o vedere), cosa resta **fuori**. La prova: chi non era nella sessione, con la sola scheda, sa dire perché il task esiste, può cominciarlo e sa quando fermarsi. Criteri ed esempio in `skills/new-project/reference/tasks.md`.

## Installazione
**Claude Code, come plugin** (si aggiorna da solo con il marketplace):
```
/plugin marketplace add stemee-org/relay
/plugin install relay@stemee-org
```
Una repo impostata con `/new-project` abilita già il plugin: Claude Code lo propone a chi la apre.

**Claude Code o Codex, come skill personali** (un link alla copia clonata: `git pull` aggiorna tutto):
```
git clone https://github.com/stemee-org/relay.git
cd relay
./install.sh claude     # ${CLAUDE_CONFIG_DIR:-~/.claude}/skills/<ogni skill>
./install.sh codex      # ${CODEX_HOME:-~/.codex}/skills/<ogni skill>
./install.sh <cartella-delle-skill>
```
Con più profili di Claude Code si lancia una volta per profilo, con `CLAUDE_CONFIG_DIR` impostata.

## Struttura
- `skills/<nome>/SKILL.md`: le sette skill. Ognuna ha una sola copia, qui: il kit non le copia nelle repo.
- `skills/new-project/reference/tasks.md`: le domande tecniche e com'è fatto un buon task (la usa anche `replan`).
- `skills/new-project/reference/from-reference.md`: leggere un prototipo o un altro riferimento, e dove va ogni cosa trovata.
- `skills/new-project/reference/method.md`: il metodo e le sue ragioni.
- `skills/new-project/templates/`: il kit copiato nel progetto. I file con il prefisso `dot-` diventano file con il punto (`dot-claude/` → `.claude/`).
- `skills/new-project/scripts/scaffold.sh`: copia il kit; con `--check` elenca i segnaposto `{{…}}` rimasti, i task senza scheda e le schede incomplete.
- `tests/run.sh`: prova lo scaffold, il controllo e l'installazione su una cartella temporanea.
- `.claude-plugin/`: manifest del plugin e del marketplace.

## Stato
Versione 0.3.0. Provati con `./tests/run.sh`, che gira anche in CI a ogni pull request: la copia del kit da zero, i file esistenti lasciati intatti, gli hook, `settings.json` valido con i tre plugin abilitati, il controllo dei task, la presenza di ogni skill nominata nei documenti, `install.sh`. Provata la validazione del plugin (`claude plugin validate .`). Non ancora provati: il percorso dall'inizio alla fine su un progetto vero, `/replan` ed `/end-session` in una sessione vera, l'installazione dei plugin con i comandi di `/new-project`, l'uso dentro Codex.

## Modificarla
Il kit è in inglese; la lingua dei documenti del progetto si sceglie nell'intervista. Chi cambia una regola del metodo la cambia in `reference/method.md`, nei template che la ripetono (`CLAUDE.md`, `CONTRIBUTING.md`) e nelle skill che la applicano: si cerca la vecchia formulazione con `grep` prima di committare.

## Licenza
[MIT](LICENSE).
