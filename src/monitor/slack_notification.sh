slack_notification__notify() {
  local text="$1"
  local type="$2"
  local slack_text="${NAME}: ${text}"
  local username="Hello Monitoring"
  local emoji="$(_slack_notification__emoji_from_type "${type}")"

  > /dev/null http__post \
"${SLACK_WEBHOOK_URL}" \
"{\"text\": \"${slack_text}\", \"username\": \"${username}\", \"icon_emoji\": \"${emoji}\"}" \

  if (( $? != 0 )); then
    >&2 echo "Impossible to notify via slack"
  fi
}

_slack_notification__emoji_from_type() {
  local type="$1"
  if [[ "${type}" = "success" ]]; then
    echo ":white_check_mark:"
  else
    echo ":exclamation:"
  fi
}
