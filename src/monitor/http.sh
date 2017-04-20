http__get() {
  local url="$1"
  curl -sS "${url}"
}

http__post() {
  local url="$1"
  local body="$2"
  curl -sS -X POST -H 'Content-type: application/json' \
       --data "${body}" "${url}"
}
