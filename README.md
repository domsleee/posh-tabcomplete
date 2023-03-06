# posh-tabcomplete

Blazing fast tab completion for powershell.

Features:
* Fast startup and execution using `nu-engine`
* Extendable using `.nu` files, with [git-completions](https://github.com/nushell/nu_scripts/blob/main/custom-completions/git/git-completions.nu) built in

Currently only `git` is supported. It can be extended by specifying a `.nu` file in the `TABCOMPLETE_FILE` environment variable.

## Installation

### Step 1. Install

| Repository      | Instructions                             |
| --------------- | ---------------------------------------  |
| **[crates.io]** | `cargo install posh-tabcomplete --locked`|


### Step 2. Setup powershell
```pwsh
Invoke-Expression (&tabcomplete init | Get-Content)
```

[crates.io]: https://crates.io/crates/starship

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