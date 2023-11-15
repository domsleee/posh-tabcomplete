# All results

file size: 13297664
pwsh version: 7.4.0-rc.1
## Init

| Command                                                      |   Mean [ms] | Min [ms] | Max [ms] |    Relative |
| :----------------------------------------------------------- | ----------: | -------: | -------: | ----------: |
| `pwsh -NoProfile -File ./../profiles/ProfileBaseline.ps1`    | 207.6 ± 6.7 |    186.8 |    233.2 |        1.00 |
| `pwsh -NoProfile -File ./../profiles/ProfilePoshGit.ps1`     | 487.7 ± 8.0 |    478.1 |    524.3 | 2.35 ± 0.08 |
| `pwsh -NoProfile -File ./../profiles/ProfileTabComplete.ps1` | 253.4 ± 6.4 |    247.2 |    284.2 | 1.22 ± 0.05 |

posh-tabcomplete: 45ms, posh-git: 280ms (6.22x faster)
## Complete

| Command                                         |    Mean [ms] | Min [ms] | Max [ms] |    Relative |
| :---------------------------------------------- | -----------: | -------: | -------: | ----------: |
| `pwsh -NoProfile -File CompleteBaseline.ps1`    | 523.9 ± 11.8 |    510.4 |    584.0 |        1.00 |
| `pwsh -NoProfile -File CompletePoshGit.ps1`     | 746.5 ± 28.0 |    721.4 |    843.8 | 1.42 ± 0.06 |
| `pwsh -NoProfile -File CompleteTabComplete.ps1` | 628.0 ± 19.5 |    609.1 |    736.2 | 1.20 ± 0.05 |

posh-tabcomplete: 104ms, posh-git: 222ms (2.13x faster)
