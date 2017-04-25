notification__notify() {
  local text="$1"
  local type="$2"
  console_notification__notify "${text}" "${type}"
  _notification__maybe_notify "${text}" "${type}"
  _notification__set_last_notification_type "${type}"
}

_notification__maybe_notify() {
  local text="$1"
  local type="$2"
  if _notification__should_notify "${type}"; then
    _notification__maybe_notify_via_slack "${text}" "${type}"
  fi
}

_notification__should_notify() {
  local type="$1"
  _notification__satisfies_notify_on_error "${type}" ||\
  _notification__satisfies_notify_on_success "${type}" ||\
  _notification__satisfies_NOTIFY_ON_CHANGE "${type}"
}

_notification__satisfies_notify_on_error() {
  [[ "${NOTIFY_ON_ERROR}" == "yes" && "${type}" == "error" ]]
}

_notification__satisfies_notify_on_success() {
  [[ "${NOTIFY_ON_SUCCESS}" == "yes" && "${type}" == "success" ]]
}

_notification__satisfies_NOTIFY_ON_CHANGE() {
  [[ "${NOTIFY_ON_CHANGE}" == "yes" && "${type}" != "$(_notification__get_last_notification_type)" ]]
}

_notification__maybe_notify_via_slack() {
  local text="$1"
  local type="$2"
  if [[ "${SLACK_WEBHOOK_URL}" != "" ]]; then
    slack_notification__notify "${text}" "${type}"
  fi
}

_notification__get_last_notification_type() {
  [[ -f /tmp/last_notification_type ]] && cat /tmp/last_notification_type
}

_notification__set_last_notification_type() {
  local type="$1"
  echo "${type}" > /tmp/last_notification_type
}
