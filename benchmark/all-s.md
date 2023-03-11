# All results

file size: 16681984
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 237.2 ± 5.5 | 229.1 | 251.6 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 527.9 ± 12.2 | 515.8 | 564.0 | 2.23 ± 0.07 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 302.7 ± 8.6 | 289.2 | 320.8 | 1.28 ± 0.05 |

tabcomplete: 65ms, posh-git: 290ms (4.46x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 578.9 ± 20.2 | 558.6 | 658.5 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 742.6 ± 10.5 | 721.5 | 769.0 | 1.28 ± 0.05 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 653.2 ± 13.7 | 638.2 | 690.4 | 1.13 ± 0.05 |

tabcomplete: 74ms, posh-git: 163ms (2.2x faster)
