use std::io::BufRead;

use crate::TestEnv;

pub fn run_command(shell: &str, command: &str) -> Vec<String> {
    let testenv = TestEnv::new(shell);
    let res = testenv.run_with_profile(command).unwrap();
    res.stdout.lines().map(|x| x.unwrap()).collect()
}
