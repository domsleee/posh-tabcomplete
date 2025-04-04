# posh-tabcomplete
[![Crates.io](https://img.shields.io/crates/v/posh-tabcomplete.svg)](https://crates.io/crates/posh-tabcomplete)
[![Build Status](https://github.com/domsleee/posh-tabcomplete/actions/workflows/ci.yml/badge.svg)](https://github.com/domsleee/posh-tabcomplete/actions/workflows/ci.yml)

Blazing fast tab completion for powershell and pwsh.

![demo](media/demo.gif)

This video is using the `MenuComplete` binding in  `code $PROFILE`:

```powershell
Set-PSReadLineKeyHandler -Key Tab MenuComplete
```

Features:
* Fast startup and execution using [nushell/nu-engine](https://crates.io/crates/nu-engine)
* Extendable using `.nu` files, with built in support for commmon tasks like `git` and `npm run`
* Supports all platforms. Tested on windows, WSL, mac and linux

By default, [completions.nu](./resource/completions.nu) is used. An alternative `.nu` file can be specified in the `TABCOMPLETE_FILE` environment variable.

## Installation

### Step 1. Install binary

There are binaries available in [releases](https://github.com/domsleee/posh-tabcomplete/releases), or with one of these commands:

| Repository      | Instructions                              |
| --------------- | ----------------------------------------- |
| **[crates.io]** | `cargo install posh-tabcomplete --locked` |


### Step 2. Setup powershell

Add this line to your profile, you can edit this by typing `code $PROFILE` in powershell:
```pwsh
Invoke-Expression (&posh-tabcomplete init | Out-String)
```

[crates.io]: https://crates.io/crates/posh-tabcomplete

## Built in completions
The completions packaged with the binary in [completions.nu](./resource/completions.nu) are:
* [git completions](https://github.com/nushell/nu_scripts/blob/main/custom-completions/git/git-completions.nu). These are also combined with [git auto generated completions](https://github.com/nushell/nu_scripts/blob/main/custom-completions/auto-generate/completions/git.nu)
* [npm completions](https://github.com/nushell/nu_scripts/blob/main/custom-completions/npm/npm-completions.nu)
* [cargo completions](https://github.com/nushell/nu_scripts/blob/main/custom-completions/cargo/cargo-completions.nu)

## Benchmarks
To run these, run `./benchmark/benchmark_all.ps1`

| Benchmark                                            | Results                                                |
| ---------------------------------------------------- | ------------------------------------------------------ |
| `benchmark/init` - startup time                      | posh-tabcomplete: 42ms, posh-git: 268ms (6.38x faster) |
| `benchmark/complete` - tab completion (100 branches) | posh-tabcomplete: 80ms, posh-git: 176ms (2.2x faster)  |

## Aliases / Function support
Functions are supported. For example, the completion of `gco` in the demo is:
```pwsh
function gco() { git checkout $args }
```

There is no support for alias completions at this time.

## Full list of completions

See [completions.nu](./resource/completions.nu):

* `git`
  * `branch`
  * `checkout`
  * `cherry-pick`
  * `fetch`
  * `merge`
  * `push`
  * `rebase`
  * `switch`
  * `diff`
* `npm`
  * `run`