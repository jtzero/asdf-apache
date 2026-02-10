#!/usr/bin/env bash

set -euo pipefail

latest_stable_pattern() {
  printf '%s' '^[0-9]+(\.[0-9]+)?(\.[0-9]+)?-bin'
}

semver_from_user_input() {
  local -r raw_user_version_arg="$1"
  if [[ "${raw_user_version_arg}" =~ ^[0-9]+(\.[0-9]+)?(\.[0-9]+)?-bin- ]]; then
    printf '%s' "${raw_user_version_arg}" | cut -d- -f-1
  else
    printf '%s' "${raw_user_version_arg}" | cut -d- -f-2
  fi
}

list_sub_versions() {
  local -r include_src="$1"
  local -r file_names="$2"

  if [ "${include_src}" = "true" ]; then
    fail "Cannot currently handle source download"
  else
    printf "%s\n" "${file_names}" | grep -E "^flink-[0-9]+\.[0-9]+" | sed -E 's/^flink-//g' | sed 's/.tgz.*//g'
  fi
}

filename_extended_pattern() {
  local -r product_name="$1"
  local -r raw_user_version_arg="$2"
  local -r version_folder_url="$3"
  local -r semver="${4:-}"
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

filter_dist_folder_page() {
  local -r semverish="${1}"
  local -r page="${2}"
  printf '%s' "${page}" | grep -o -E 'href=".+">' | grep -o -E "\"flink-${semverish}/\"" | tr -d '"/>'

}

case "$1" in
latest_stable_pattern)
  latest_stable_pattern
  ;;
list_sub_versions)
  list_sub_versions "${2}" "${3}"
  ;;
semver_from_user_input)
  semver_from_user_input "${2}"
  ;;
filename_extended_pattern)
  filename_extended_pattern "${2}" "${3}" "${4}" "${5}"
  ;;
filter_dist_folder_page)
  filter_dist_folder_page "${2}" "${3}"
  ;;
*)
  echo "Unknown function $1" >&2
  exit 1
  ;;
esac
