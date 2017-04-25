register__run() {
  monitor__check_requirements
  _register__set_defaults
  _register__print_info
  _register__register_cron
  /usr/sbin/crond -f -d 8
}

_register__set_defaults() {
  CRON=${CRON:-* * * * *}
}

_register__print_info() {
  echo "Monitoring ${URL} with cron ${CRON}."
}

_register__register_cron() {
  touch crontab.tmp
  echo "${CRON} ${ROOT}/run.sh monitor" > crontab.tmp
  crontab crontab.tmp
  rm crontab.tmp
}
