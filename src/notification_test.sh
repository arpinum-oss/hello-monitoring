HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"
source "${HERE}/notification.sh"

should_notify_an_error() {
  assertion__successful notification__should_notify "error"
}

should_notify_a_success() {
  assertion__successful notification__should_notify "success"
}

wont_notify_success_if_configured_so() {
  NOTIFY_ERRORS_ONLY=true

  assertion__failing notification__should_notify "success"
}

should_notify_an_error_anyway() {
  NOTIFY_ERRORS_ONLY=true

  assertion__successful notification__should_notify "error"
}
