# All results

file size: 14947328
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 245.4 ± 10.9 | 230.8 | 263.7 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 533.5 ± 17.6 | 515.4 | 601.7 | 2.17 ± 0.12 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 310.3 ± 9.7 | 299.7 | 329.8 | 1.26 ± 0.07 |

tabcomplete: 64ms, posh-git: 288ms (4.5x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 574.2 ± 13.4 | 558.9 | 620.8 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 739.1 ± 14.1 | 712.3 | 775.0 | 1.29 ± 0.04 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 656.1 ± 12.6 | 640.2 | 684.4 | 1.14 ± 0.03 |

tabcomplete: 81ms, posh-git: 164ms (2.02x faster)
