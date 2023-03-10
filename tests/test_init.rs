mod testenv;
use itertools::Itertools;
use rstest::rstest;
use rstest_reuse::{self, *};
use std::io::BufRead;
pub use testenv::*;

#[apply(shell_to_use)]
fn test_init(shell: &str) {
    let testenv = TestEnv::new(shell);
    let res = testenv
        .run_with_profile("Write-Output 'hello world'")
        .unwrap();
    let lines = res.stdout.lines().map(|x| x.unwrap()).collect_vec();
    assert_eq!(vec!["hello world"], lines);
}
