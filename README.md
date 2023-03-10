# posh-tabcompletelkllkklm,m,,m,m,,,mm,,m,mm,,,mm,m,,,,m,,,m
[![Crates.io](https://img.shields.io/crates/v/posh-tabcomplete.svg)](https://crates.io/crates/posh-tabcomplete)
[![Build Status](https://github.com/domsleee/posh-tabcomplete/actions/workflows/ci.yml/badge.svg)](https://github.com/domsleee/posh-tabcomplete/actions/workflows/ci.yml)

Blazing fast tab completion for powershell.

Features:
* Fast startup and execution using `nu-engine`
* Extendable using `.nu` files, with built in support for commmon tasks like `git` and `npm run`

By default, [completions.nu](./resource/completions.nu) is used. An alternative `.nu` file can be specified in the `TABCOMPLETE_FILE` environment variable.

## Installation

### Step 1. Install binary

| Repository      | Instructions                             |
| --------------- | ---------------------------------------  |
| **[crates.io]** | `cargo install posh-tabcomplete --locked`|


### Step 2. Setup powershell
```pwsh
Invoke-Expression (&tabcomplete init | Out-String)
```

[crates.io]: https://crates.io/crates/starship

## Built in completions
* [git completions](https://github.com/nushell/nu_scripts/blob/main/custom-completions/git/git-completions.nu). These are also combined with [git auto generated completions](https://github.com/nushell/nu_scripts/blob/main/custom-completions/auto-generate/completions/git.nu)
* [npm `run` completions](https://github.com/nushell/nu_scripts/blob/main/custom-completions/npm/npm-completions.nu)
* [cargo completions](https://github.com/nushell/nu_scripts/blob/main/custom-completions/cargo/cargo-completions.nu)

## Benchmarks

Benchmark | Results
----------|-----------
`benchmark/init` - startup time | tabcomplete: 102ms, posh-git: 432ms (4.24x faster)
`benchmark/complete` - tab completion (100 branches) | tabcomplete: 71ms, posh-git: 172ms (2.42x faster)

## Aliases / Function support
Functions are supported. For example, this would add completion for `gco `, as if it was `git checkout `:
```pwsh
function gco() { git checkout $args }
```

There is no support for alias completions at this time.