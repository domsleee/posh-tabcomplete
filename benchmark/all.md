# All results

file size: 9488384
pwsh version: 7.5.0-preview.2
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 204.9 ± 3.8 | 201.7 | 220.4 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 473.5 ± 5.1 | 466.0 | 499.5 | 2.31 ± 0.05 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 246.5 ± 2.5 | 242.6 | 262.1 | 1.20 ± 0.03 |

posh-tabcomplete: 41ms, posh-git: 268ms (6.54x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 503.4 ± 7.1 | 495.3 | 565.0 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 683.2 ± 5.7 | 675.8 | 708.0 | 1.36 ± 0.02 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 586.7 ± 4.3 | 580.7 | 607.7 | 1.17 ± 0.02 |

posh-tabcomplete: 83ms, posh-git: 179ms (2.16x faster)
