register__run() {
  _register__check_variables
  _register__set_defaults
  _register__print_info
  _register__register_cron
  /usr/sbin/crond -f -d 8
}

_register__set_defaults() {
  export CRON=${CRON:-* * * * *}
  export NAME=${NAME:-"$(util__truncate "${URL}" 30)"}
}

_register__print_info() {
  echo "Monitoring ${URL} with cron ${CRON}"
}

_register__check_variables() {
  if [[ -z "${URL}" ]]; then
    >&2 echo "URL is not set"
    exit 1
  fi
  
  if [[ -z "${EXPECTED_RESPONSE}" ]]; then
    >&2 echo "EXPECTED_RESPONSE is not set"
    exit 1
  fi
}

_register__register_cron() {
  touch crontab.tmp
  echo "${CRON} ${ROOT}/run.sh monitor" > crontab.tmp
  crontab crontab.tmp
  rm crontab.tmp
}
