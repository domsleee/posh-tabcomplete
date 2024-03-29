use std::io::BufRead;

use itertools::Itertools;
use rstest::rstest;
use rstest_reuse::{self, *};

mod testenv;
pub use testenv::*;

use speculoos::assert_that;
use speculoos::prelude::ContainingIntoIterAssertions;

#[apply(shell_to_use)]
fn test_command_names(shell: &str) {
    let lines = util::run_command(shell, "Get-CommandNamesUsingRegex");
    println!("{lines:?}");
    assert_that!(lines).contains("git".to_string());
}

#[apply(shell_to_use)]
fn test_command_names_other_nu(shell: &str) {
    let testenv = TestEnv::new_with_other_nu(shell);
    let res = testenv
        .run_with_profile("Get-CommandNamesUsingRegex")
        .unwrap();
    let lines = res.stdout.lines().map(|x| x.unwrap()).collect_vec();
    println!("{lines:?}");
    assert_that!(lines).contains("burrito".to_string());
}
