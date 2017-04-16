notification__notify() {
  local text="$1"
  local type="$2"
  
  console_notification__notify "${text}" "${type}"
  
  if notification__should_notify "${type}"; then
    notification__maybe_notify_via_slack "${text}" "${type}"
  fi
}

notification__should_notify() {
  local type="$1"
  [[ -z "${NOTIFY_ERRORS_ONLY}" ]] || [[ "${type}" = "error" ]]
}

notification__maybe_notify_via_slack() {
  if [[ "${SLACK_WEBHOOK_URL}" != "" ]]; then
    slack_notification__notify "${text}" "${type}"
  fi
}

