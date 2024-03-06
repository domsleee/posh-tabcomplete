#[macro_use]
extern crate log;
use args::RootArgs;
use clap::Parser;
use itertools::Itertools;
use posh_tabcomplete::TABCOMPLETE_FILE;
use reedline::Completer;
use regex::Regex;
use std::{
    collections::HashSet,
    env, fs,
    io::{self},
};

use crate::args::{CompleteArgs, TabCompleteSubCommand};

mod args;
mod nu_util;
use std::str;

fn main() -> Result<(), std::io::Error> {
    env_logger::init();
    run_with_args(&RootArgs::parse())
}

pub fn run_with_args(root_args: &RootArgs) -> Result<(), std::io::Error> {
    match &root_args.subcommand {
        TabCompleteSubCommand::Complete(complete_args) => complete(root_args, complete_args),
        TabCompleteSubCommand::NuCommands => print_nu_commands(root_args),
        TabCompleteSubCommand::Init => init(root_args),
    }?;
    Ok(())
}

static DEFAULT_CONFIG_DATA: &[u8] = include_bytes!("../resource/completions.nu");
fn complete(root_args: &RootArgs, complete_args: &CompleteArgs) -> Result<(), std::io::Error> {
    let arg_str = &complete_args.args_str;
    let pwd = env::current_dir()?;
    trace!("pwd: {:?}, arg_str '{arg_str}'", pwd);
    let string_from_files = get_string_from_files(root_args);
    let nu_file_data = if string_from_files.is_empty() {
        DEFAULT_CONFIG_DATA
    } else {
        string_from_files.as_bytes()
    };
    let mut completer = nu_util::extern_completer(&pwd, nu_file_data);
    let suggestions = completer.complete(arg_str, arg_str.len());
    let suggestion_strings: Vec<String> = suggestions
        .iter()
        .map(|x| maybe_process_path(&x.value.clone().to_string()))
        .collect();

    println!("{}", suggestion_strings.join("\n"));
    Ok(())
}

fn maybe_process_path(arg: &str) -> String {
    if arg.len() > 1 && arg.starts_with('`') && arg.ends_with('`') {
        // replace the start and end backticks with single quotes
        // also replace all single quotes with double single quote
        let replaced_single_quotes = &arg[1..arg.len() - 1].replace('\'', "''");
        return format!("'{replaced_single_quotes}'",);
    }

    arg.to_string()
}

fn get_string_from_files(root_args: &RootArgs) -> String {
    match &root_args.file_override {
        Some(file_override) => fs::read_to_string(file_override)
            .unwrap_or_else(|_| panic!("unable to read {file_override:?}")),
        None => match env::var(TABCOMPLETE_FILE) {
            Ok(file_override) => fs::read_to_string(&file_override)
                .unwrap_or_else(|_| panic!("unable to read {TABCOMPLETE_FILE} '{file_override}'")),
            _ => "".to_string(),
        },
    }
}

static INIT_DATA: &[u8] = include_bytes!("../resource/init.ps1");
pub fn init(root_args: &RootArgs) -> Result<(), io::Error> {
    let string_data = str::from_utf8(INIT_DATA).unwrap();
    let commands = get_nu_commands(root_args)?;
    let joined_commands = format!("@('{}')", commands.iter().join("', '"));
    let replaced_string = string_data.replace("::TABCOMPLETE_NU_COMMANDS::", &joined_commands);
    println!("{}", replaced_string);
    Ok(())
}

pub fn print_nu_commands(root_args: &RootArgs) -> Result<(), io::Error> {
    let s = get_nu_commands(root_args)?;
    println!("{}", s.iter().join("\n"));
    Ok(())
}

pub fn get_nu_commands(root_args: &RootArgs) -> Result<HashSet<String>, io::Error> {
    let string_from_files = get_string_from_files(root_args);
    let nu_file_data = if string_from_files.is_empty() {
        String::from_utf8_lossy(DEFAULT_CONFIG_DATA).to_string()
    } else {
        string_from_files
    };
    let re = Regex::new(r#"(?:^|\n)\s*export extern "\S+"#).unwrap();
    let matches = re
        .find_iter(&nu_file_data)
        .map(|x| x.as_str().split('"').nth(1).unwrap());
    let s: HashSet<String> = HashSet::from_iter(matches.map(|m| m.to_string()));
    Ok(s)
}
