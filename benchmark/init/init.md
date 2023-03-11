| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 288.8 ± 17.1 | 271.6 | 348.9 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 628.9 ± 10.6 | 610.9 | 649.4 | 2.18 ± 0.13 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 356.0 ± 6.9 | 344.5 | 368.0 | 1.23 ± 0.08 |

tabcomplete: 67ms, posh-git: 340ms (5.07x faster)
