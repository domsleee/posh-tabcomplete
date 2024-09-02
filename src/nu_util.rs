use std::path::{Path, PathBuf};

use nu_cli::NuCompleter;
use nu_engine::eval_block;
use nu_parser::parse;
use nu_protocol::debugger::WithoutDebug;
use nu_protocol::report_error;
use nu_protocol::{
    engine::{EngineState, Stack, StateWorkingSet},
    PipelineData, ShellError, Span, Value,
};

// from env.rs https://github.com/nushell/nushell/blob/60769ac1ba3ea036d889f140095d855e5597840c/crates/nu-engine/src/env.rs#L14-L19
#[cfg(windows)]
const ENV_PATH_NAME: &str = "Path";
#[cfg(windows)]
const ENV_PATH_NAME_SECONDARY: &str = "PATH";
#[cfg(not(windows))]
const ENV_PATH_NAME: &str = "PATH";

pub fn extern_completer(pwd: &Path, nu_file_data: &[u8]) -> NuCompleter {
    let (dir, _, mut engine, mut stack) = new_engine(pwd);
    assert!(merge_input(nu_file_data, &mut engine, &mut stack, dir).is_ok());
    NuCompleter::new(std::sync::Arc::new(engine), std::sync::Arc::new(stack))
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

    let res = eval_block::<WithoutDebug>(
        engine_state,
        stack,
        &block,
        PipelineData::Value(
            Value::Nothing {
                internal_span: Span::unknown(),
            },
            None,
        ),
    );

    debug_assert!(res.is_ok());

    engine_state.merge_env(stack, &dir)
}

fn new_engine(pwd: &Path) -> (PathBuf, String, EngineState, Stack) {
    let dir_str: String = pwd.display().to_string();
    let mut engine_state =
        nu_command::add_shell_command_context(nu_cmd_lang::create_default_context());
    let mut stack = Stack::new();
    add_variable_to_stack(&mut stack, "PWD", &dir_str);

    add_environment_variables_to_stack(&mut stack);

    let merge_result = engine_state.merge_env(&mut stack, &PathBuf::from(&dir_str));
    assert!(merge_result.is_ok());

    (PathBuf::from(&dir_str), dir_str, engine_state, stack)
}

fn add_environment_variables_to_stack(stack: &mut Stack) {
    // needed when running commands, e.g. https://github.com/nushell/nushell/blob/60769ac1ba3ea036d889f140095d855e5597840c/crates/nu-command/src/system/run_external.rs#L77-L83

    #[cfg(windows)]
    add_environment_variable_to_stack(stack, ENV_PATH_NAME);
    #[cfg(windows)]
    add_environment_variable_to_stack(stack, ENV_PATH_NAME_SECONDARY);

    #[cfg(not(windows))]
    add_environment_variable_to_stack(stack, crate::nu_util::ENV_PATH_NAME);
}

fn add_environment_variable_to_stack(stack: &mut Stack, key: &str) {
    if let Ok(val) = std::env::var(key) {
        add_variable_to_stack(stack, key, &val);
    }
}

fn add_variable_to_stack(stack: &mut Stack, key: &str, value: &str) {
    stack.add_env_var(
        key.to_string(),
        Value::String {
            val: value.to_string(),
            internal_span: nu_protocol::Span::new(0, value.len()),
        },
    );
}
