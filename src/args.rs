use clap::{command, Parser};
use std::path::PathBuf;

/// Use nushell tab completion in powershell
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
pub struct RootArgs {
    /// Program to run
    #[command(subcommand)]
    pub subcommand: TabCompleteSubCommand,

    /// File to use for tab completions instead of the default .nu file.
    /// See also the TABCOMPLETE_FILE environment variable
    #[arg(short, long, value_name = "FILE")]
    pub file_override: Option<PathBuf>,
}

#[derive(clap::Subcommand, Debug)]
pub enum TabCompleteSubCommand {
    /// Complete the data passed in
    Complete(CompleteArgs),
    /// Generate a ps1 script to setup powershell
    Init,
    /// Return the first word of all completions in the nu script
    NuCommands,
}

#[derive(Parser, Debug)]
pub struct CompleteArgs {
    /// String/s to pass to the tab completion. Example "git ch" should return a list containing checkout
    pub args_str: String,
}
