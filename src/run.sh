#!/usr/bin/env bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"
source "${ROOT}/monitor/util.sh"
source "${ROOT}/monitor/http.sh"
source "${ROOT}/monitor/console_notification.sh"
source "${ROOT}/monitor/slack_notification.sh"
source "${ROOT}/monitor/notification.sh"
source "${ROOT}/monitor/monitor.sh"
source "${ROOT}/register/register.sh"

_run__main() {
  if (( $# != 1 )); then
    _run__invalid_usage
  fi

  case "$1" in
    register)
      register__run
      ;;
    monitor)
      monitor__run
      ;;
    *)
      _run__invalid_usage
      ;;
  esac
}

_run__invalid_usage() {
  echo "Invalid usage. Available commands: register or monitor." >&2
  exit 1
}

_run__main "$@"
