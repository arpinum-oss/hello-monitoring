notification__notify() {
  local text="$1"
  local type="$2"
  
  console_notification__notify "${text}" "${type}"
  
  if _notification__should_notify "${type}"; then
    _notification__maybe_notify_via_slack "${text}" "${type}"
  fi
}

_notification__should_notify() {
  local type="$1"
  [[ -z "${NOTIFY_ERRORS_ONLY}" ]] || [[ "${type}" = "error" ]]
}

_notification__maybe_notify_via_slack() {
  local text="$1"
  local type="$2"
  if [[ "${SLACK_WEBHOOK_URL}" != "" ]]; then
    slack_notification__notify "${text}" "${type}"
  fi
}

