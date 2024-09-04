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
    assert_eq!(lines, vec!["script1", "script2"]);
}

#[apply(shell_to_use)]
fn test_npm_run_space(shell: &str) -> Result<(), std::io::Error> {
    let test_env = TestEnv::new(shell).create_package_json(
        r#"
            {
                "scripts": {
                    "with space": "echo hello world",
                }
            }
        "#,
    )?;

    let lines = util::run_with_test_env(&test_env, "Invoke-TabComplete 'npm run with'");
    assert_eq!(&lines, &["'with space'".to_string()]);
    Ok(())
}

#[apply(shell_to_use)]
fn test_npm_run_single_quotes(shell: &str) -> Result<(), std::io::Error> {
    let test_env = TestEnv::new(shell).create_package_json(
        r#"
            {
                "scripts": {
                    "withsingle'quote": "echo hello world",
                }
            }
        "#,
    )?;

    let lines = util::run_with_test_env(&test_env, "Invoke-TabComplete 'npm run with'");
    assert_that!(&lines).equals_iterator(&["'withsingle''quote'".to_string()].iter());
    Ok(())
}

#[apply(shell_to_use)]
fn test_npm_run_double_quotes(shell: &str) -> Result<(), std::io::Error> {
    let test_env = TestEnv::new(shell).create_package_json(
        r#"
            {
                "scripts": {
                    "withdouble\"quote": "echo hello world",
                }
            }
        "#,
    )?;

    let lines = util::run_with_test_env(&test_env, "Invoke-TabComplete 'npm run with'");
    assert_that!(&lines).equals_iterator(&[r#"'withdouble"quote'"#.to_string()].iter());
    Ok(())
}

#[apply(shell_to_use)]
fn test_npm_run_backticks(shell: &str) -> Result<(), std::io::Error> {
    let test_env = TestEnv::new(shell).create_package_json(
        r#"
            {
                "scripts": {
                    "with`backtick": "echo hello world",
                }
            }
        "#,
    )?;

    let lines = util::run_with_test_env(&test_env, "Invoke-TabComplete 'npm run with'");
    assert_that!(&lines).equals_iterator(&[r#"'with`backtick'"#.to_string()].iter());
    Ok(())
}

#[apply(shell_to_use)]
fn test_npm_run_ampersand(shell: &str) -> Result<(), std::io::Error> {
    let test_env = TestEnv::new(shell).create_package_json(
        r#"
            {
                "scripts": {
                    "with&ampersand": "echo hello world",
                }
            }
        "#,
    )?;

    let lines = util::run_with_test_env(&test_env, "Invoke-TabComplete 'npm run with'");
    assert_that!(&lines).equals_iterator(&[r#"'with&ampersand'"#.to_string()].iter());
    Ok(())
}
