# All results

file size: 14286848
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 227.1 ± 4.8 | 220.2 | 240.1 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 534.8 ± 30.9 | 505.8 | 624.0 | 2.35 ± 0.14 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 307.8 ± 22.4 | 268.0 | 370.3 | 1.36 ± 0.10 |

posh-tabcomplete: 80ms, posh-git: 307ms (3.84x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 546.7 ± 7.8 | 536.8 | 574.4 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 724.9 ± 7.3 | 713.6 | 746.7 | 1.33 ± 0.02 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 627.3 ± 5.4 | 617.5 | 641.5 | 1.15 ± 0.02 |

posh-tabcomplete: 80ms, posh-git: 178ms (2.22x faster)
