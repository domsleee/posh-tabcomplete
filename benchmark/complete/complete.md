| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ./CompleteBaseline.ps1` | 652.1 ± 11.8 | 634.9 | 675.2 | 1.00 |
| `pwsh -NoProfile -File ./CompletePoshGit.ps1` | 825.0 ± 7.9 | 812.9 | 837.0 | 1.27 ± 0.03 |
| `pwsh -NoProfile -File ./CompleteTabComplete.ps1` | 723.5 ± 11.4 | 711.6 | 753.3 | 1.11 ± 0.03 |
tabcomplete: 71ms, posh-git: 172ms (2.42x faster)
