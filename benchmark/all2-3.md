# All results

file size: 22199808
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 288.8 ± 17.1 | 271.6 | 348.9 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 628.9 ± 10.6 | 610.9 | 649.4 | 2.18 ± 0.13 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 356.0 ± 6.9 | 344.5 | 368.0 | 1.23 ± 0.08 |

tabcomplete: 67ms, posh-git: 340ms (5.07x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 690.0 ± 8.4 | 674.0 | 704.9 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 890.2 ± 9.6 | 878.9 | 910.4 | 1.29 ± 0.02 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 796.1 ± 12.7 | 775.4 | 831.8 | 1.15 ± 0.02 |

tabcomplete: 106ms, posh-git: 200ms (1.89x faster)
