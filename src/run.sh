#!/usr/bin/env bash

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"
source "${HERE}/util.sh"

run__main() {
  run__check_variables
  run__set_defaults
  run__print_info
  run__register_cron
  /usr/sbin/crond -f -d 8
}

run__set_defaults() {
  export CRON=${CRON:-* * * * *}
  export NAME=${NAME:-"$(util__truncate "${URL}" 30)"}
}

run__print_info() {
  echo "Monitoring ${URL} with cron ${CRON}"
}

run__check_variables() {
  if [[ -z "${URL}" ]]; then
    >&2 echo "URL is not set"
    exit 1
  fi
  
  if [[ -z "${EXPECTED_RESPONSE}" ]]; then
    >&2 echo "EXPECTED_RESPONSE is not set"
    exit 1
  fi
}

run__register_cron() {
  touch crontab.tmp
  echo "${CRON} /src/monitor.sh" > crontab.tmp
  crontab crontab.tmp
  rm crontab.tmp
}

run__main "$@"
