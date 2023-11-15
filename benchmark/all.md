# All results

file size: 13297664
pwsh version: 7.4.0-rc.1
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 209.9 ± 9.0 | 202.4 | 240.6 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 492.2 ± 10.1 | 479.8 | 542.9 | 2.35 ± 0.11 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 256.6 ± 9.8 | 247.4 | 292.8 | 1.22 ± 0.07 |

posh-tabcomplete: 46ms, posh-git: 282ms (6.13x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 527.9 ± 8.0 | 515.9 | 550.0 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 732.6 ± 15.2 | 711.1 | 784.2 | 1.39 ± 0.04 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 633.8 ± 18.9 | 613.4 | 713.7 | 1.20 ± 0.04 |

posh-tabcomplete: 105ms, posh-git: 204ms (1.94x faster)
