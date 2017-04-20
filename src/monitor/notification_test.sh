HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"
source "${HERE}/notification.sh"

setup() {
  slack_notify_called="no"
  slack_notify_arg_text=""
  slack_notify_arg_type=""
  console_notify_called="no"
  console_notify_arg_text=""
  console_notify_arg_type=""
  mock__make_function_call "console_notification__notify" "_console_notify"
  mock__make_function_call "slack_notification__notify" "_slack_notify"
}

should_notify_an_error_via_console() {
  notification__notify "error occured" "error"

  assertion__equal "yes" "${console_notify_called}"
  assertion__equal "error occured" "${console_notify_arg_text}"
  assertion__equal "error" "${console_notify_arg_type}"
}

should_notify_a_success_via_console() {
  notification__notify "all ok" "success"

  assertion__equal "yes" "${console_notify_called}"
  assertion__equal "all ok" "${console_notify_arg_text}"
  assertion__equal "success" "${console_notify_arg_type}"
}

should_notify_an_error_via_slack() {
  SLACK_WEBHOOK_URL="some url"

  notification__notify "error occured" "error"

  assertion__equal "yes" "${slack_notify_called}"
  assertion__equal "error occured" "${slack_notify_arg_text}"
  assertion__equal "error" "${slack_notify_arg_type}"
}

should_notify_a_success_via_slack() {
  SLACK_WEBHOOK_URL="some url"

  notification__notify "all ok" "success"

  assertion__equal "yes" "${slack_notify_called}"
  assertion__equal "all ok" "${slack_notify_arg_text}"
  assertion__equal "success" "${slack_notify_arg_type}"
}

wont_notify_success_via_slack_if_webhook_not_configured() {
  notification__notify "error occured" "error"

  assertion__equal "no" "${slack_notify_called}"
}

wont_notify_success_via_slack_if_configured_so() {
  NOTIFY_ERRORS_ONLY="yes"
  SLACK_WEBHOOK_URL="some url"

  notification__notify "all ok" "success"

  assertion__equal "no" "${slack_notify_called}"
}

should_notify_an_error_via_slack_anyway() {
  NOTIFY_ERRORS_ONLY="yes"
  SLACK_WEBHOOK_URL="some url"

  notification__notify "error occured" "error"

  assertion__equal "yes" "${slack_notify_called}"
}

_console_notify() {
  console_notify_called="yes"
  console_notify_arg_text="$1"
  console_notify_arg_type="$2"
}

_slack_notify() {
  slack_notify_called="yes"
  slack_notify_arg_text="$1"
  slack_notify_arg_type="$2"
}
