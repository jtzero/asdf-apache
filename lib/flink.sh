semver_from_user_input() {
  local -r raw_user_version_arg="${1}"
  if [[ ! "${raw_user_version_arg}" =~ .*flink-\d+\.d+(\.d+)?(-[a-z0-9]+)?$ ]]; then
    printf '%s' "${raw_user_version_arg}" | cut -d- -f-2
  else
    echo "${raw_user_version_arg}" | sed -E 's/([0-9]+\.[0-9]+(\.[0-9]+)?)-.*/\1/'
  fi
}

list_sub_versions() {
  local -r file_names="$1"
  local -r include_src="${2:-false}"

  if [ "${include_src}" = "true" ]; then
    fail "Cannot currently handle source download"
  else
    printf "%s\n" "${file_names}" | grep -E "^flink-[0-9]+\.[0-9]+" | sed -E 's/^flink-//g' | sed 's/.tgz.*//g'
  fi
}

filename_extended_pattern() {
  local product_name="$1"
  local raw_user_version_arg="$2"
  local version_folder_url="$3"
  local -r file_extensions="tgz|tar.gz"
  local version=""
  if [[ ! "${raw_user_version_arg}" =~ .*-src$ ]]; then
    add_version_info="$(printf '%s' "${raw_user_version_arg}" | sed -E "s/^${semver}//" | cut -s -d'-' -f2)"
    if [ -n "${add_version_info}" ]; then
      add_version_info="-${add_version_info}"
    fi
    version="${semver}${add_version_info}"
  fi

  echo "\".*${product_name}-${version}.*(${file_extensions})\""
}

latest_stable_pattern() {
  printf '%s' '\.[0-9]+$'
}
