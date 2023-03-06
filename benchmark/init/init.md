| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `pwsh -NoProfile -File ../profiles/ProfileBaseline.ps1` | 195.3 ± 8.5 | 188.3 | 223.2 | 1.00 |
| `pwsh -NoProfile -File ../profiles/ProfilePoshGit.ps1` | 628.2 ± 9.9 | 616.3 | 649.2 | 3.22 ± 0.15 |
| `pwsh -NoProfile -File ../profiles/ProfileTabComplete.ps1` | 297.9 ± 6.2 | 289.3 | 308.7 | 1.53 ± 0.07 |
tabcomplete: 102ms, posh-git: 432ms (4.24x faster)
