http__get() {
  local url="$1"
  curl -sSL "${url}"
}

http__post() {
  local url="$1"
  local body="$2"
  curl -sS -X POST -H 'Content-type: application/json' \
       --data "${body}" "${url}"
}
