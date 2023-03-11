| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 237.2 ± 5.5 | 229.1 | 251.6 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 527.9 ± 12.2 | 515.8 | 564.0 | 2.23 ± 0.07 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 302.7 ± 8.6 | 289.2 | 320.8 | 1.28 ± 0.05 |

tabcomplete: 65ms, posh-git: 290ms (4.46x faster)
