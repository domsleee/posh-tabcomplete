# All results

file size: 12472832
pwsh version: 7.4.5
## Init

| Command                                                      |   Mean [ms] | Min [ms] | Max [ms] |    Relative |
| :----------------------------------------------------------- | ----------: | -------: | -------: | ----------: |
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1`    | 208.3 ± 5.6 |    201.8 |    242.2 |        1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1`     | 477.8 ± 7.7 |    468.1 |    512.6 | 2.29 ± 0.07 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 250.5 ± 4.7 |    243.0 |    274.6 | 1.20 ± 0.04 |

posh-tabcomplete: 42ms, posh-git: 268ms (6.38x faster)
## Complete

| Command                                         |   Mean [ms] | Min [ms] | Max [ms] |    Relative |
| :---------------------------------------------- | ----------: | -------: | -------: | ----------: |
| `pwsh -NoProfile -File CompleteBaseline.ps1`    | 508.1 ± 7.7 |    495.7 |    547.5 |        1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1`     | 684.6 ± 8.5 |    670.9 |    726.7 | 1.35 ± 0.03 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 589.0 ± 9.5 |    575.1 |    643.5 | 1.16 ± 0.03 |

posh-tabcomplete: 80ms, posh-git: 176ms (2.2x faster)
