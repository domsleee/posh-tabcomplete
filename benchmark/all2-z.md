# All results

file size: 15032832
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 278.6 ± 7.1 | 270.3 | 299.8 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 606.3 ± 9.7 | 594.6 | 636.8 | 2.18 ± 0.07 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 348.8 ± 8.2 | 335.7 | 370.8 | 1.25 ± 0.04 |

tabcomplete: 70ms, posh-git: 327ms (4.67x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 669.2 ± 13.5 | 652.7 | 698.8 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 878.8 ± 17.1 | 859.2 | 921.1 | 1.31 ± 0.04 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 776.7 ± 18.6 | 747.7 | 813.1 | 1.16 ± 0.04 |

tabcomplete: 107ms, posh-git: 209ms (1.95x faster)
