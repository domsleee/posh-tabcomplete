use std::io::BufRead;

use crate::TestEnv;

pub fn run_command(shell: &str, command: &str) -> Vec<String> {
    let testenv = TestEnv::new(shell);
    run_with_test_env(&testenv, command)
}

pub fn run_with_test_env(testenv: &TestEnv, command: &str) -> Vec<String> {
    let res = testenv.run_with_profile(command).unwrap();
    res.stdout.lines().map(|x| x.unwrap()).collect()
}
