use rstest::rstest;
use rstest_reuse::{self, *};
use speculoos::assert_that;

extern crate speculoos;
use crate::speculoos::prelude::ContainingIntoIterAssertions;

mod testenv;
pub use testenv::*;

#[apply(shell_to_use)]
fn test_npm_run(shell: &str) {
    let lines = util::run_command(shell, "Invoke-TabComplete 'npm run '");
    assert_that!(lines).contains("script1".to_string());
    assert_that!(lines).contains("script2".to_string());
}
