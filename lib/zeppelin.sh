#!/usr/bin/env bash

set -euo pipefail

FILE_EXT='tgz'

list_sub_versions() {
  local -r file_names="$1"
  local -r include_src="${2:-false}"

  local -r include_netinst="true"

  if [ "${include_src}" = "true" ]; then
    fail "Cannot currently handle source download"
  elif [ "${include_netinst}" = "true" ]; then
    printf "%s\n" "${file_names}" | grep -E "(bin-all|bin-netinst).${FILE_EXT}" | sed "s/-bin-all.${FILE_EXT}//" | sed "s/-bin-netinst.${FILE_EXT}/-netinst/" | sed 's/zeppelin-//'
  else
    printf "%s\n" "${file_names}" | grep -E "bin-all.${FILE_EXT}" | sed "s/-bin-all.${FILE_EXT}//" | sed 's/zeppelin-//'
  fi
}

grep_filename() {
  local product_name="$1"
  # shellcheck disable=SC2034
  local version_folder_url="$2"
  local raw_user_version_arg="$3"

  raw_user_version_arg_to_filename "${product_name}" "${raw_user_version_arg}"
}

raw_user_version_arg_to_filename() {
  local -r product_name="$1"
  local -r raw_user_version_arg="$2"
  if printf '%s' "${raw_user_version_arg}" | grep -q '-netinst'; then
    printf '%s.%s' "${product_name}-${raw_user_version_arg}" "${FILE_EXT}" | sed 's/netinst/bin-netinst/'
  else
    printf '%s' "${product_name}-${raw_user_version_arg}-bin-all.${FILE_EXT}"
  fi
}
