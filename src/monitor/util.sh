util__truncate() {
  local string="$1"
  local length=$2
  local maxLength=$((${length}-3))
  if (( ${#string} > ${maxLength} )); then
    echo "${string:0:${maxLength}}..."
  else
    echo "${string}"
  fi
}
