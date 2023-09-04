use rstest::rstest;
use rstest_reuse::{self, *};
use speculoos::assert_that;

extern crate speculoos;
use crate::speculoos::prelude::ContainingIntoIterAssertions;

mod testenv;
pub use testenv::*;

#[apply(shell_to_use)]
fn test_checkout_branches_alias(shell: &str) {
    let lines = util::run_command(shell, "Invoke-TabComplete 'myLongGitCheckoutAlias '");
    assert_that!(lines).contains("testbranch".to_string());
    assert_that!(lines).contains("testbranch23".to_string());
}

#[apply(shell_to_use)]
fn test_checkout_completions_registered(shell: &str) {
    let lines = util::run_command(
        shell,
        "Get-ArgumentCompleter -Native | ForEach-Object { \"$($_.CommandName)\" }",
    );
    assert_that!(lines).contains("myLongGitCheckoutAlias".to_string());
    assert_that!(lines).contains("git".to_string());
}
