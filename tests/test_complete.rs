use std::io::BufRead;

use assertor::{assert_that, VecAssertion};
use itertools::Itertools;
use rstest::rstest;
use rstest_reuse::{self, *};

mod testenv;
pub use testenv::*;

#[template]
#[rstest]
#[case("pwsh")]
#[cfg_attr(windows, case("powershell"))]
pub fn shell_to_use(#[case] shell: &str) {}

#[apply(shell_to_use)]
fn test_checkout_branches(shell: &str) {
    let testenv = TestEnv::new(shell);
    let res = testenv
        .run_with_profile("Invoke-TabComplete 'git checkout '")
        .unwrap();
    let lines = res.stdout.lines().map(|x| x.unwrap()).collect_vec();

    assert_that!(lines).contains("testbranch".to_string());
    assert_that!(lines).contains("testbranch23".to_string());
}

#[apply(shell_to_use)]
fn test_checkout_branches2(shell: &str) {
    let testenv = TestEnv::new(shell);
    let res = testenv
        .run_with_profile("Invoke-TabComplete 'git checkout testbranch2'")
        .unwrap();
    let lines = res.stdout.lines().map(|x| x.unwrap()).collect_vec();
    assert_that!(lines).contains("testbranch23".to_string());
}

#[apply(shell_to_use)]
fn test_checkout_branches_alias(shell: &str) {
    let testenv = TestEnv::new(shell);
    let res = testenv
        .run_with_profile("Invoke-TabComplete 'myLongGitCheckoutAlias '")
        .unwrap();
    let lines = res.stdout.lines().map(|x| x.unwrap()).collect_vec();
    assert_that!(lines).contains("testbranch".to_string());
    assert_that!(lines).contains("testbranch23".to_string());
}

#[apply(shell_to_use)]
fn test_checkout_completions_registered(shell: &str) {
    let testenv = TestEnv::new(shell);
    let res = testenv
        .run_with_profile(
            "Get-ArgumentCompleter -Native | ForEach-Object { \"$($_.CommandName)\" }",
        )
        .unwrap();
    let lines = res.stdout.lines().map(|x| x.unwrap()).collect_vec();
    assert_that!(lines).contains("myLongGitCheckoutAlias".to_string());
    assert_that!(lines).contains("git".to_string());
}

#[apply(shell_to_use)]
fn test_complete_nongit_command(shell: &str) {
    let testenv = TestEnv::new_with_other_nu(shell);
    let res = testenv
        .run_with_profile("Invoke-TabComplete 'burrito -'")
        .unwrap();
    let lines = res.stdout.lines().map(|x| x.unwrap()).collect_vec();
    assert_that!(lines).contains("--hello-there".to_string());
}