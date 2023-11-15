use std::path::{Path, PathBuf};

use nu_cli::NuCompleter;
use nu_engine::eval_block;
use nu_parser::parse;
use nu_protocol::report_error;
use nu_protocol::{
    engine::{EngineState, Stack, StateWorkingSet},
    PipelineData, ShellError, Span, Value,
};

pub fn extern_completer(pwd: &Path, nu_file_data: &[u8]) -> NuCompleter {
    let (dir, _, mut engine, mut stack) = new_engine(pwd);
    // engine.currently_parsed_cwd = Some(dir.clone());
    assert!(merge_input(nu_file_data, &mut engine, &mut stack, dir).is_ok());
    NuCompleter::new(std::sync::Arc::new(engine), stack)
}

// see completions_helper.rs from nushell
// no doubt performance here could be improved

fn merge_input(
    input: &[u8],
    engine_state: &mut EngineState,
    stack: &mut Stack,
    dir: PathBuf,
) -> Result<(), ShellError> {
    let (block, delta) = {
        let mut working_set = StateWorkingSet::new(engine_state);
        let block = parse(&mut working_set, None, input, false);
        if let Some(err) = working_set.parse_errors.first() {
            report_error(&working_set, err);
            std::process::exit(1);
        }
        (block, working_set.render())
    };

    engine_state.merge_delta(delta)?;

    debug_assert!(eval_block(
        engine_state,
        stack,
        &block,
        PipelineData::Value(
            Value::Nothing {
                internal_span: Span::unknown(),
            },
            None
        ),
        false,
        false
    )
    .is_ok());

    engine_state.merge_env(stack, &dir)
}

fn new_engine(pwd: &Path) -> (PathBuf, String, EngineState, Stack) {
    let dir_str: String = pwd.display().to_string();
    let mut engine_state =
        nu_command::add_shell_command_context(nu_cmd_lang::create_default_context());
    let mut stack = Stack::new();
    stack.add_env_var(
        "PWD".to_string(),
        Value::String {
            val: dir_str.clone(),
            internal_span: nu_protocol::Span::new(0, dir_str.len()),
        },
    );

    let path_str = "";
    #[cfg(windows)]
    stack.add_env_var(
        "Path".to_string(),
        Value::String {
            val: path_str.to_string(),
            internal_span: nu_protocol::Span::new(0, path_str.len()),
        },
    );
    #[cfg(not(windows))]
    stack.add_env_var(
        "path".to_string(),
        Value::String {
            val: path_str.to_string(),
            internal_span: nu_protocol::Span::new(0, path_str.len()),
        },
    );
    let merge_result = engine_state.merge_env(&mut stack, &PathBuf::from(&dir_str));
    assert!(merge_result.is_ok());

    (PathBuf::from(&dir_str), dir_str, engine_state, stack)
}
