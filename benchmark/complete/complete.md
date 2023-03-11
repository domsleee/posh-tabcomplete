| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 586.5 ± 11.9 | 566.5 | 610.6 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 754.0 ± 14.8 | 722.6 | 780.0 | 1.29 ± 0.04 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 665.4 ± 9.8 | 649.4 | 687.6 | 1.13 ± 0.03 |

tabcomplete: 78ms, posh-git: 167ms (2.14x faster)
