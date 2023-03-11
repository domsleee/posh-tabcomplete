# All results

file size: 16768000
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 277.7 ± 8.0 | 265.8 | 298.7 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 608.9 ± 12.6 | 588.1 | 651.5 | 2.19 ± 0.08 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 350.7 ± 9.7 | 336.1 | 373.5 | 1.26 ± 0.05 |

tabcomplete: 73ms, posh-git: 331ms (4.53x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 672.5 ± 18.6 | 647.5 | 739.0 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 869.1 ± 12.9 | 849.7 | 901.3 | 1.29 ± 0.04 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 778.8 ± 13.9 | 755.8 | 827.4 | 1.16 ± 0.04 |

tabcomplete: 106ms, posh-git: 196ms (1.85x faster)
