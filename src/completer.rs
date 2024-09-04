use crate::nu_util;
use reedline::{Completer, Suggestion};
use std::path::Path;

pub fn get_suggestions(nu_file_data: &[u8], pwd: &Path, arg_str: &str) -> Vec<String> {
    let mut completer = nu_util::extern_completer(pwd, nu_file_data);
    let suggestions = completer.complete(arg_str, arg_str.len());
    let suggestion_strings: Vec<String> = suggestions.iter().map(get_suggestion_string).collect();
    suggestion_strings
}

fn get_suggestion_string(suggestion: &Suggestion) -> String {
    let arg = suggestion.value.clone().to_string();
    if arg.len() > 1 && arg.starts_with('`') && arg.ends_with('`') {
        // replace the start and end backticks with single quotes
        // also replace all single quotes with double single quote
        // e.g. completion of `git add ` with a file with a space in it
        let replaced_single_quotes = &arg[1..arg.len() - 1].replace('\'', "''");
        return format!("'{replaced_single_quotes}'",);
    }

    // for example, `git ch` should be `checkout`, not `git checkout`
    if suggestion.span.start == 0 {
        return arg.split(' ').last().unwrap().to_string();
    }

    // if the arg contains a special character, wrap it in single quotes
    if !arg.is_empty()
        && !arg.starts_with('\'')
        && (arg.contains(' ')
            || arg.contains('\"')
            || arg.contains('\'')
            || arg.contains('`')
            || arg.contains('&'))
    {
        let replaced_arg = arg.replace('\'', "''");
        return format!("'{replaced_arg}'");
    }

    arg.to_string()
}

#[cfg(test)]
mod tests {
    use crate::DEFAULT_CONFIG_DATA;

    use super::*;

    #[test]
    fn test_get_suggestions() {
        let nu_file_data: &[u8] = DEFAULT_CONFIG_DATA;
        let pwd = std::env::current_dir().unwrap();
        let arg_str = "git checkou";
        let expected = vec!["checkout".to_string()];
        let suggestions = get_suggestions(nu_file_data, &pwd, arg_str);
        assert_eq!(suggestions, expected);
    }
}
