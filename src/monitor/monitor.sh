monitor__run() {
  local error
  local response

  response="$(http__get "${URL}")"

  if (( $? != 0 )); then
    error="Unable to get response from URL"
  elif [[ ! "${response}" =~ ${EXPECTED_RESPONSE} ]]; then
    error="Unexpected response: $(util__truncate "${response}" 50)"
  fi

  if [[ -n "${error}" ]]; then
    _monitor__handle_error "${error}"
  else
    _monitor__handle_success
  fi
}

_monitor__handle_error() {
  local error="$1"
  local text="Monitoring failed for ${URL}: ${error}"
  notification__notify "${text}" "error"
}

_monitor__handle_success() {
  local text="Everything is fine"
  notification__notify "${text}" "success"
}
