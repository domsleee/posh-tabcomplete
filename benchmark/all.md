# All results

file size: 10002944
pwsh version: 7.5.0-preview.2
## Init

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1` | 206.5 ± 4.9 | 201.8 | 228.5 | 1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1` | 478.1 ± 7.8 | 468.6 | 523.8 | 2.32 ± 0.07 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 249.4 ± 4.4 | 244.2 | 266.6 | 1.21 ± 0.04 |

posh-tabcomplete: 43ms, posh-git: 271ms (6.3x faster)
## Complete

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File CompleteBaseline.ps1` | 507.4 ± 6.8 | 497.4 | 528.5 | 1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1` | 686.4 ± 6.9 | 672.1 | 720.5 | 1.35 ± 0.02 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 590.7 ± 6.6 | 581.1 | 618.6 | 1.16 ± 0.02 |

posh-tabcomplete: 83ms, posh-git: 179ms (2.16x faster)
