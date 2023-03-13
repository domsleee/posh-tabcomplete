# All results

file size: 16797696
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 242.2 ± 9.0 | 231.2 | 266.5 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 543.3 ± 13.4 | 519.7 | 570.1 | 2.24 ± 0.10 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 304.5 ± 8.5 | 293.1 | 331.2 | 1.26 ± 0.06 |

tabcomplete: 62ms, posh-git: 301ms (4.85x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 582.9 ± 9.7 | 570.1 | 610.0 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 752.6 ± 15.4 | 730.7 | 786.8 | 1.29 ± 0.03 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 670.3 ± 14.9 | 646.7 | 696.6 | 1.15 ± 0.03 |

tabcomplete: 87ms, posh-git: 169ms (1.94x faster)
