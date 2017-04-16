HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"
source "${HERE}/util.sh"

should_truncate_long_string_and_add_ellipsis() {
  local string="my tailor is rich"

  local truncated="$(util__truncate "${string}" 7)"

  assertion__equal "my t..." "${truncated}"
}

wont_truncate_short_string() {
  local string="my"

  local truncated="$(util__truncate "${string}" 7)"

  assertion__equal "my" "${truncated}"
}

