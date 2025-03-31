use rstest::rstest;
use rstest_reuse::{self, *};

extern crate speculoos;

mod testenv;
pub use testenv::*;

#[apply(shell_to_use)]
fn test_bun_run(shell: &str) {
    let lines = util::run_command(shell, "Invoke-TabComplete 'npm run '");
    assert_eq!(lines, vec!["script1", "script2"]);
}
