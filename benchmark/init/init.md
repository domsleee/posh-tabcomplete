| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 240.1 ± 7.1 | 233.3 | 263.2 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 541.9 ± 16.0 | 525.0 | 583.6 | 2.26 ± 0.09 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 306.7 ± 9.4 | 296.9 | 326.3 | 1.28 ± 0.05 |

tabcomplete: 66ms, posh-git: 301ms (4.56x faster)
