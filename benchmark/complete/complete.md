| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 599.1 ± 14.6 | 580.0 | 643.2 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 778.3 ± 13.8 | 748.8 | 807.1 | 1.30 ± 0.04 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 680.7 ± 11.3 | 662.9 | 706.4 | 1.14 ± 0.03 |

tabcomplete: 81ms, posh-git: 179ms (2.21x faster)
