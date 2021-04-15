#!/usr/bin/env bash

set -Eeuo pipefail

if [ -z "${BASH_SOURCE}" ]; then
  # zsh
  readonly LIB_DIR="$( cd "$( dirname "${(%):-%N}" )" && pwd )"
else
  readonly LIB_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fi

source "${LIB_DIR}/utils.bash"

FILE_EXTENSIONS="tgz|tar.gz"

get_dist_folder() {
  local product_name="$1"
  echo "https://archive.apache.org/dist/${product_name}"
}

get_version_folder() {
  local product_name="$1"
  local semverish="$2"
  local dist_folder_url="$(get_dist_folder "${product_name}")"
  echo "$(curl "${curl_opts}" "${dist_folder_url}/" 2>/dev/null | grep -o -E 'href=".+">' | grep -o -E "\".*${semverish}/\"" | tr -d '"/>')"
}

get_filename() {
  local product_name="$1"
  local version_type="$2"
  local version_folder_url="$3"
  echo "$(curl "${curl_opts}" "${version_folder_url}/" 2>/dev/null | grep -o -E 'href=".+">' | grep -o -E "\".*${product_name}-${version_type}.(${FILE_EXTENSIONS})\"" | tr -d '"/>')"
}

get_download_url() {
  local product_name="$1"
  local semverish="$2"
  local version_type="$3"
  local dist_folder_url="$(get_dist_folder "${product_name}")"
  local version_folder="$(get_version_folder "${product_name}" "${semverish}")"
  [ -z "${version_folder}" ] && fail "Could not get subversion folder for '${semverish}' in '${dist_folder_url}'"
  local filename="$(get_filename "${product_name}" "${version_type}" "${dist_folder_url}/${version_folder}")"
  echo "${dist_folder_url}/${version_folder}/${filename}"
}
