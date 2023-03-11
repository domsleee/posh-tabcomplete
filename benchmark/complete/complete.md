| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 690.0 ± 8.4 | 674.0 | 704.9 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 890.2 ± 9.6 | 878.9 | 910.4 | 1.29 ± 0.02 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 796.1 ± 12.7 | 775.4 | 831.8 | 1.15 ± 0.02 |

tabcomplete: 106ms, posh-git: 200ms (1.89x faster)
