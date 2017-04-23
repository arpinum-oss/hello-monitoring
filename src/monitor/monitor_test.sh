HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"
source "${HERE}/monitor.sh"
source "${HERE}/../common/util.sh"

setup() {
  notify_called="no"
  notify_arg_text=""
  notify_arg_type=""
  mock__make_function_call "notification__notify" "_notify"
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
