# All results

file size: 21975040
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 240.1 ± 7.1 | 233.3 | 263.2 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 541.9 ± 16.0 | 525.0 | 583.6 | 2.26 ± 0.09 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 306.7 ± 9.4 | 296.9 | 326.3 | 1.28 ± 0.05 |

tabcomplete: 66ms, posh-git: 301ms (4.56x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 586.5 ± 11.9 | 566.5 | 610.6 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 754.0 ± 14.8 | 722.6 | 780.0 | 1.29 ± 0.04 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 665.4 ± 9.8 | 649.4 | 687.6 | 1.13 ± 0.03 |

tabcomplete: 78ms, posh-git: 167ms (2.14x faster)
