# All results

file size: 15032832
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 278.1 ± 6.1 | 266.5 | 292.0 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 617.8 ± 11.4 | 597.5 | 641.4 | 2.22 ± 0.06 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 348.9 ± 9.7 | 333.9 | 370.1 | 1.25 ± 0.04 |

tabcomplete: 70ms, posh-git: 339ms (4.84x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 668.0 ± 8.9 | 654.7 | 682.7 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 880.2 ± 20.7 | 849.3 | 930.4 | 1.32 ± 0.04 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 790.3 ± 24.2 | 752.5 | 860.7 | 1.18 ± 0.04 |

tabcomplete: 122ms, posh-git: 212ms (1.74x faster)
