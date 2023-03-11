| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 248.5 ± 8.5 | 236.6 | 267.9 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 550.9 ± 10.3 | 534.7 | 576.0 | 2.22 ± 0.09 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 317.8 ± 11.7 | 301.5 | 339.7 | 1.28 ± 0.06 |

tabcomplete: 69ms, posh-git: 302ms (4.38x faster)
