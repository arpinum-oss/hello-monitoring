monitor__run() {
  monitor__check_requirements
  _monitor__set_defaults

  local response
  response="$(http__get "${URL}")"
  local get_status=$?

  local error="$(_monitor__create_error_if_any ${get_status} "${response}")"
  _monitor__handle_outcome "${error}"
}

monitor__check_requirements() {
  if [[ -z "${URL}" ]]; then
    echo "URL is not set." >&2
    exit 1
  fi

  if [[ -z "${EXPECTED_RESPONSE}" ]]; then
    echo "EXPECTED_RESPONSE is not set." >&2
    exit 1
  fi
}

_monitor__set_defaults() {
  NAME="${NAME:-"$(util__truncate "${URL}" 30)"}"
  NOTIFY_ON_SUCCESS="${NOTIFY_ON_SUCCESS:-"no"}"
  NOTIFY_ON_ERROR="${NOTIFY_ON_ERROR:-"no"}"
  NOTIFY_ON_CHANGE="${NOTIFY_ON_CHANGE:-"yes"}"
}

_monitor__create_error_if_any() {
  local status=$1
  local response="$2"
  if (( ${status} != 0 )); then
    echo "Unable to get response from URL."
  elif [[ ! "${response}" =~ ${EXPECTED_RESPONSE} ]]; then
    echo "Unexpected response: $(util__truncate "${response}" 50)."
  fi
}

_monitor__handle_outcome() {
  local error="$1"
  if [[ -z "${error}" ]]; then
    _monitor__handle_success
  else
    _monitor__handle_error "${error}"
  fi
}

_monitor__handle_error() {
  local error="$1"
  local text="Monitoring failed for ${URL}. ${error}"
  notification__notify "${text}" "error"
}

_monitor__handle_success() {
  local text="Everything is fine"
  notification__notify "${text}" "success"
}
