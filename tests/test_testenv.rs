mod testenv;
use std::{fs, io::BufRead, path::PathBuf};

use itertools::Itertools;
pub use testenv::*;

#[test]
pub fn test_path_is_set() {
    let testenv = TestEnv::new("pwsh");
    let res = testenv.run_with_profile("(gcm tabcomplete).Path").unwrap();
    let lines = res.stdout.lines().map(|x| x.unwrap()).collect_vec();

    let bin_invoked_path = fs::canonicalize(&lines[0]).expect("invoked path");
    let binding = PathBuf::from(file!());
    let project_path = binding
        .as_path()
        .parent()
        .expect("tests directory")
        .parent()
        .expect("rootdirectory");
    let expected_bin_path = project_path.join("target").join("debug").join(format!(
        "tabcomplete{}",
        if cfg!(windows) { ".exe" } else { "" }
    ));

    let expected_bin = fs::canonicalize(expected_bin_path).expect("bin path should exist");
    assert_eq!(expected_bin, bin_invoked_path);
}

#[test]
pub fn test_git_is_defined() {
    let testenv = TestEnv::new("pwsh");
    testenv
        .run_with_profile("git -h")
        .expect("git should be defined");
}
