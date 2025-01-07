semver_from_user_input() {
  local -r raw_user_version_arg="${1}"
  if [[ ! "${raw_user_version_arg}" =~ .*flink-\d+\.d+(\.d+)?(-[a-z0-9]+)?$ ]]; then
    printf '%s' "${raw_user_version_arg}" | cut -d- -f-2
  else
    echo "${raw_user_version_arg}" | sed -E 's/([0-9]+\.[0-9]+(\.[0-9]+)?)-.*/\1/'
  fi
}
