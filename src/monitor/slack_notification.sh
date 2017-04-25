slack_notification__notify() {
  local text="$1"
  local type="$2"
  local username="Hello Monitoring"
  local emoji="$(_slack_notification__emoji_from_type "${type}")"
  local slack_text="${emoji} [${NAME}] ${text}"

  > /dev/null http__post \
"${SLACK_WEBHOOK_URL}" \
"{\"text\": \"${slack_text}\", \"username\": \"${username}\", \"icon_emoji\": \":ambulance:\"}" \

  if (( $? != 0 )); then
    echo "Impossible to notify via slack." >&2
  fi
}

_slack_notification__emoji_from_type() {
  local type="$1"
  if [[ "${type}" == "success" ]]; then
    echo ":white_check_mark:"
  else
    echo ":exclamation:"
  fi
}
