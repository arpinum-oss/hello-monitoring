slack_notification__notify() {
  local text="$1"
  local type="$2"
  local slack_text="${NAME}: ${text}"
  local username="Hello Monitoring"
  local emoji="$(slack_notification__emoji_from_type "${type}")"

  > /dev/null curl -sS -X POST --data-urlencode \
"payload={\"text\": \"${slack_text}\", \"username\": \"${username}\", \"icon_emoji\": \"${emoji}\"}" \
"${SLACK_WEBHOOK_URL}"

  if (( $? != 0 )); then
    >&2 echo "Impossible to notify via slack"
  fi
}

slack_notification__emoji_from_type() {
  local type="$1"
  if [[ "${type}" = "success" ]]; then
    echo ":white_check_mark:"
  else
    echo ":exclamation:"
  fi
}
