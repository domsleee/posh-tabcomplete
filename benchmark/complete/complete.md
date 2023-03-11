| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 578.9 ± 20.2 | 558.6 | 658.5 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 742.6 ± 10.5 | 721.5 | 769.0 | 1.28 ± 0.05 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 653.2 ± 13.7 | 638.2 | 690.4 | 1.13 ± 0.05 |

tabcomplete: 74ms, posh-git: 163ms (2.2x faster)
