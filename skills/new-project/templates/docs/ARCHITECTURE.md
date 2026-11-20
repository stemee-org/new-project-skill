# Architecture

<!-- Only the stable picture. Update when the structure changes, not for every feature. Folder-level, not file-by-file. Link ADRs, don't copy them. -->

## Overview

```mermaid
flowchart LR
  user([User]) --> web[{{Web app}}]
  web --> api[{{API}}]
  api --> db[({{Database}})]
```

## Components
| Component | Responsibility | Lives in |
|---|---|---|
| {{Web app}} | {{…}} | `{{path/}}` |

## Data flow
{{How a typical request moves through the system, in a few lines.}}

## External services
| Service | Used for | Config (env vars) |
|---|---|---|
| {{service, or «none yet»}} | {{…}} | `{{VAR}}` |

## Auth & security
{{Who can do what, where it's enforced.}}

## Deployment
{{Where it runs, how it gets there, environments. «Not decided» is a valid answer: link the open question.}}

{{With a reference, add: «## Differences from the reference», one line per structural difference with its ADR.}}
