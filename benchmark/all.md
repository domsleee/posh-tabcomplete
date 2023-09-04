# All results

file size: 14286336
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 234.5 ± 6.0 | 226.0 | 250.7 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 525.4 ± 6.2 | 514.2 | 541.2 | 2.24 ± 0.06 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 295.1 ± 4.9 | 288.2 | 311.9 | 1.26 ± 0.04 |

tabcomplete: 60ms, posh-git: 290ms (4.83x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 574.8 ± 9.2 | 561.8 | 599.1 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 761.5 ± 8.6 | 746.9 | 780.7 | 1.32 ± 0.03 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 660.5 ± 10.5 | 647.3 | 694.2 | 1.15 ± 0.03 |

tabcomplete: 85ms, posh-git: 186ms (2.19x faster)
