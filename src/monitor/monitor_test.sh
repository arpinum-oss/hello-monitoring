HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"
source "${HERE}/util.sh"
source "${HERE}/monitor.sh"

setup() {
  notify_called="no"
  notify_arg_text=""
  notify_arg_type=""
  mock__make_function_call "notification__notify" "_notify"
  mock__make_function_prints "http__get" ""
  _define_all_variables
}

should_check_requirements_successfully_when_all_variables_are_set() {
  assertion__successful monitor__check_requirements
}

should_fail_if_url_is_missing() {
  URL=""

  ( monitor__check_requirements >/dev/null 2>&1 )

  assertion__status_code_is_failure $?
}

should_fail_if_expected_response_is_missing() {
  EXPECTED_RESPONSE=""

  ( monitor__check_requirements >/dev/null 2>&1 )

  assertion__status_code_is_failure $?
}

wont_alter_given_name() {
  NAME="My project"

  monitor__run

  assertion__equal "My project" "${NAME}"
}

should_use_truncated_url_as_default_name() {
  URL="http://verylongurl.com"

  monitor__run

  assertion__string_contains "${NAME}" "http://very"
}

wont_notify_on_error_by_default() {
  monitor__run

  assertion__equal "no" "${NOTIFY_ON_ERROR}"
}

wont_alter_given_notify_on_error_value() {
  NOTIFY_ON_ERROR="yes"

  monitor__run

  assertion__equal "yes" "${NOTIFY_ON_ERROR}"
}

wont_notify_on_success_by_default() {
  monitor__run

  assertion__equal "no" "${NOTIFY_ON_SUCCESS}"
}

should_NOTIFY_ON_CHANGE_by_default() {
  monitor__run

  assertion__equal "yes" "${NOTIFY_ON_CHANGE}"
}

wont_alter_given_NOTIFY_ON_CHANGE_value() {
  NOTIFY_ON_CHANGE="no"

  monitor__run

  assertion__equal "no" "${NOTIFY_ON_CHANGE}"
}

wont_alter_given_notify_on_success_value() {
  NOTIFY_ON_SUCCESS="yes"

  monitor__run

  assertion__equal "yes" "${NOTIFY_ON_SUCCESS}"
}

should_notify_with_error_if_get_on_url_fails() {
  mock__make_function_call "http__get" "false"

  monitor__run

  assertion__equal "yes" "${notify_called}"
  assertion__equal "error" "${notify_arg_type}"
  assertion__string_contains "${notify_arg_text}" "Unable to get response from URL"
}

should_notify_with_success_if_get_on_url_succeeds() {
  mock__make_function_prints "http__get" "ok"
  EXPECTED_RESPONSE="ok"

  monitor__run

  assertion__equal "yes" "${notify_called}"
  assertion__equal "success" "${notify_arg_type}"
  assertion__string_contains "${notify_arg_text}" "Everything is fine"
}

should_notify_with_success_if_response_matches_regex() {
  mock__make_function_prints "http__get" "I have 233 cats and dogs"
  EXPECTED_RESPONSE=".*[0-9]{3}.*dogs"

  monitor__run

  assertion__equal "yes" "${notify_called}"
  assertion__equal "success" "${notify_arg_type}"
}

should_notify_with_success_if_response_matches_exactly_expected_one() {
  mock__make_function_prints "http__get" "ok"
  EXPECTED_RESPONSE="^ok$"

  monitor__run

  assertion__equal "yes" "${notify_called}"
  assertion__equal "success" "${notify_arg_type}"
}

should_notify_with_success_though_response_has_multiple_words() {
  mock__make_function_prints "http__get" "Hello world"
  EXPECTED_RESPONSE="Hello world"

  monitor__run

  assertion__equal "yes" "${notify_called}"
  assertion__equal "success" "${notify_arg_type}"
}

should_notify_with_error_if_response_is_not_expected() {
  mock__make_function_prints "http__get" "ok"
  EXPECTED_RESPONSE="right"

  monitor__run

  assertion__equal "yes" "${notify_called}"
  assertion__equal "error" "${notify_arg_type}"
  assertion__string_contains "${notify_arg_text}" "Unexpected response: ok"
}

_notify() {
  notify_called="yes"
  notify_arg_text="$1"
  notify_arg_type="$2"
}

_define_all_variables() {
  URL="http://my-url.com"
  EXPECTED_RESPONSE="ok"
}
