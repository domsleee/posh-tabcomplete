#![allow(unused_macros)] // FIXME
use posh_tabcomplete::TABCOMPLETE_FILE;
use rstest_reuse::*;
use std::{
    env,
    ffi::OsString,
    fs,
    io::{self, Write},
    path::{Path, PathBuf},
    process::{Command, Output},
};
use tempfile::TempDir;
pub mod util;

const PATH: &str = "PATH";

#[template]
#[rstest]
#[case("pwsh")]
#[cfg_attr(windows, case("powershell"))]
pub fn shell_to_use(#[case] shell: &str) {}

pub struct TestEnv {
    pub shell: String,
    pub temp_dir: TempDir,
    pub profile_path: PathBuf,
}

impl TestEnv {
    pub fn new(shell: &str) -> TestEnv {
        let profile_prefix_data = vec![
            include_str!("./aliases.ps1"),
            include_str!("./additionalFns.ps1"),
        ];

        let (temp_dir, profile_path) =
            create_working_dir(profile_prefix_data).expect("create successful");

        let package_json_path = temp_dir.path().join("package.json");
        let package_json_str = r#"
        {
            "name": "my-app",
            "version": "1.0.0",
            "main": "index.js",
            "scripts": {
                "script1": "node index.js",
                "script2": "echo \"Error: no test specified\" && exit 1"
            }
        }
        "#;
        create_package_json(&package_json_path, package_json_str)
            .expect("Able to create package json");

        TestEnv {
            shell: shell.to_string(),
            temp_dir,
            profile_path,
        }
    }

    pub fn new_with_other_nu(shell: &str) -> TestEnv {
        let target_dir = debug_target_dir();
        let project_folder = target_dir
            .parent()
            .expect("target folder")
            .parent()
            .expect("root folder");
        let other_nu_path = project_folder
            .join("tests")
            .join("testenv")
            .join("other.nu");
        assert!(other_nu_path.exists(), "{other_nu_path:?} exists");
        let formatted_path = format!(
            r#"$env:TABCOMPLETE_FILE = "{}""#,
            other_nu_path.to_str().unwrap()
        );
        let profile_prefix_data = vec![
            formatted_path.as_str(),
            include_str!("./aliases.ps1"),
            include_str!("./additionalFns.ps1"),
        ];
        let (temp_dir, profile_path) =
            create_working_dir(profile_prefix_data).expect("create successful");

        TestEnv {
            shell: shell.to_string(),
            temp_dir,
            profile_path,
        }
    }

    pub fn run_with_profile(&self, command: &str) -> Result<Output, io::Error> {
        let root: &Path = self.temp_dir.path();
        let file_contents = format!(". {}\n{command}", self.profile_path.to_str().unwrap());
        let file_path = root.join("file.ps1");
        fs::File::create(&file_path)?.write_all(file_contents.as_bytes())?;
        let target_dir = debug_target_dir();
        let paths_var = prepend_to_path_var(&target_dir);

        println!("target_dir {target_dir:?}");
        let output = Command::new(&self.shell)
            .arg("-NoProfile")
            .arg("-File")
            .env_remove(TABCOMPLETE_FILE)
            .arg(file_path.to_str().unwrap())
            .env(PATH, paths_var)
            .current_dir(root)
            .output()
            .expect("failed to execute");
        if !output.status.success() {
            panic!("{}", format_exit_error(command, &output));
        }

        Ok(output)
    }

    pub fn create_package_json(self, package_json_contents: &str) -> Result<TestEnv, io::Error> {
        let package_json_path = self.temp_dir.path().join("package.json");
        create_package_json(&package_json_path, package_json_contents)?;
        Ok(self)
    }
}

fn prepend_to_path_var(path: &Path) -> OsString {
    let current_path = env::var_os(PATH).expect("PATH must be defined");
    let split_paths = env::split_paths(&current_path);
    let mut new_paths = vec![path.to_path_buf()];
    for existing_path in split_paths {
        new_paths.push(existing_path);
    }

    env::join_paths(&new_paths).expect("can join")
}

fn create_working_dir(profile_prefix_data: Vec<&str>) -> Result<(TempDir, PathBuf), io::Error> {
    let temp_dir = tempfile::Builder::new()
        .prefix("tabcomplete-tests")
        .tempdir()?;

    let profile_path = {
        let root = temp_dir.path();
        println!("root: {root:?}");
        let mut init_str = profile_prefix_data.join("\n\n");
        init_str.push('\n');
        init_str.push_str("Invoke-Expression (&posh-tabcomplete init | Out-String)");
        let profile_path: PathBuf = root.join("tabcompleteProfile.ps1");
        fs::File::create(&profile_path)?.write_all(init_str.as_bytes())?;

        let run_git = |args: &[&str]| {
            let output = Command::new("git")
                .current_dir(root)
                .args(args)
                .output()
                .unwrap();
            assert!(
                output.status.success(),
                "expected success from git: {}",
                format_exit_error_args(args, &output)
            );
        };
        run_git(&["init"]);
        run_git(&["add", "."]);
        run_git(&["branch", "-M", "testbranch"]);
        run_git(&["config", "user.email", "you@example.com"]);
        run_git(&["config", "user.name", "yourname"]);
        run_git(&["commit", "-m", "test"]);
        run_git(&["checkout", "-b", "testbranch23"]);
        run_git(&["remote", "add", "origin", "test@test.test"]);

        profile_path
    };

    Ok((temp_dir, profile_path))
}

fn create_package_json(
    package_json_path: &Path,
    package_json_contents: &str,
) -> Result<(), io::Error> {
    let mut file = fs::File::create(package_json_path)?;
    file.write_all(package_json_contents.as_bytes())?;

    Ok(())
}

fn debug_target_dir() -> PathBuf {
    // Tests exe is in target/debug/deps, posh-tabcomplete.exe is in `target`
    let target_dir = env::current_exe()
        .expect("tests executable")
        .parent()
        .expect("tests executable directory")
        .parent()
        .expect("executable directory")
        .to_path_buf();
    target_dir
}

fn format_exit_error_args(args: &[&str], output: &Output) -> String {
    format_exit_error(&args.join(" "), output)
}

fn format_exit_error(command: &str, output: &Output) -> String {
    format!(
        "`tabcomplete {}` did not exit successfully.\nstdout:\n---\n{}---\nstderr:\n---\n{}---",
        command,
        String::from_utf8_lossy(&output.stdout),
        String::from_utf8_lossy(&output.stderr)
    )
}
