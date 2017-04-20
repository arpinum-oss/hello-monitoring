console_notification__notify() {
  local text="$1"
  local type="$2"
  echo "[$(date "+%Y-%m-%d %H:%M:%S")][${NAME}][${type}]: ${text}"
}
