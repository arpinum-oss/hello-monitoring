#!/usr/bin/env bash

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"
source "${HERE}/util.sh"
source "${HERE}/http.sh"
source "${HERE}/console_notification.sh"
source "${HERE}/slack_notification.sh"
source "${HERE}/notification.sh"

monitor__main() {
  local response="$(http__get "${URL}")"
  local error
  
  if (( $? != 0 )); then
    error="Unable to get response from URL"
  fi
  
  if [[ "${response}" != ${EXPECTED_RESPONSE} ]]; then
    error="Unexpected response: $(util__truncate "${response}" 50)"
  fi
  
  if [[ -n "${error}" ]]; then
    monitor__handle_error "${error}"
  else
    monitor__handle_success
  fi
}

monitor__handle_error() {
  local error="$1"
  local text="Monitoring failed for ${URL}: ${error}"
  notification__notify "${text}" "error"
}

monitor__handle_success() {
  local text="Everything is fine"
  notification__notify "${text}" "success"
}

monitor__main "$@"
