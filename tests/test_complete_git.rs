use std::io::BufRead;

use itertools::Itertools;
use rstest::rstest;
use rstest_reuse::{self, *};
use speculoos::assert_that;

extern crate speculoos;
use crate::speculoos::prelude::ContainingIntoIterAssertions;

mod testenv;
pub use testenv::*;

#[apply(shell_to_use)]
fn test_checkout_branches(shell: &str) {
    let lines = util::run_command(shell, "Invoke-TabComplete 'git checkout '");
    assert_that!(lines).contains("testbranch".to_string());
    assert_that!(lines).contains("testbranch23".to_string());
}

#[apply(shell_to_use)]
fn test_checkout_branches2(shell: &str) {
    let lines = util::run_command(shell, "Invoke-TabComplete 'git checkout testbranch2'");
    assert_that!(lines).contains("testbranch23".to_string());
}

#[apply(shell_to_use)]
fn test_merge(shell: &str) {
    let lines = util::run_command(shell, "Invoke-TabComplete 'git merge '");
    assert_that!(lines).contains("testbranch".to_string());
    assert_that!(lines).contains("testbranch23".to_string());
}

#[apply(shell_to_use)]
fn test_fetch_first_arg(shell: &str) {
    let lines = util::run_command(shell, "Invoke-TabComplete 'git fetch '");
    assert_that!(lines).contains("origin".to_string());
}

#[apply(shell_to_use)]
fn test_fetch_second_arg(shell: &str) {
    let lines = util::run_command(shell, "Invoke-TabComplete 'git fetch origin '");
    assert_that!(lines).contains("testbranch".to_string());
    assert_that!(lines).contains("testbranch23".to_string());
}

#[apply(shell_to_use)]
fn test_rebase_first_arg(shell: &str) {
    let lines = util::run_command(shell, "Invoke-TabComplete 'git rebase '");
    assert_that!(lines).contains("testbranch".to_string());
    assert_that!(lines).contains("testbranch23".to_string());
    assert_that!(lines).contains("origin".to_string());
}

#[apply(shell_to_use)]
fn test_rebase_second_arg(shell: &str) {
    let lines = util::run_command(shell, "Invoke-TabComplete 'git rebase origin '");
    assert_that!(lines).contains("testbranch".to_string());
    assert_that!(lines).contains("testbranch23".to_string());
}

#[apply(shell_to_use)]
fn test_diff(shell: &str) {
    let lines = util::run_command(shell, "Invoke-TabComplete 'git diff '");
    assert_that!(lines).contains("testbranch".to_string());
    assert_that!(lines).contains("testbranch23".to_string());
    assert_that!(lines).contains("HEAD".to_string());
}

#[apply(shell_to_use)]
fn test_complete_nongit_command(shell: &str) {
    let testenv = TestEnv::new_with_other_nu(shell);
    let res = testenv
        .run_with_profile("Invoke-TabComplete 'burrito -'")
        .unwrap();
    let lines: Vec<String> = res.stdout.lines().map(|x| x.unwrap()).collect_vec();
    assert_that!(lines).contains("--hello-there".to_string());
}

#[apply(shell_to_use)]
fn test_file_completion_edgecases(shell: &str) -> std::io::Result<()> {
    assert_file_completion(
        shell,
        "myfile with spaces.txt",
        "'myfile with spaces.txt'",
        "my",
    )?;
    assert_file_completion(
        shell,
        "myfilewith'quote.txt",
        "'myfilewith''quote.txt'",
        "my",
    )?;
    assert_file_completion(
        shell,
        "myfile with ' quote spaces.txt",
        "'myfile with '' quote spaces.txt'",
        "my",
    )?;

    // seems broken in nushell?
    // assert_file_completion(shell, "myfilewith`backtick.txt", "'myfilewith`backtick.txt'", "my")?;

    Ok(())
}

fn assert_file_completion(
    shell: &str,
    filename: &str,
    expected: &str,
    completion: &str,
) -> std::io::Result<()> {
    let testenv = TestEnv::new(shell);
    std::fs::write(testenv.temp_dir.path().join(filename), "AAA")?;
    let res = testenv
        .run_with_profile(&format!("Invoke-TabComplete 'git add {completion}'"))
        .unwrap();
    let lines: Vec<String> = res.stdout.lines().map(|x| x.unwrap()).collect_vec();
    assert_that!(lines).is_equal_to(vec![expected.to_string()]);
    Ok(())
}
