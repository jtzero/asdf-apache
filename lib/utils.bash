#!/usr/bin/env bash

set -euo pipefail

command -vp curl >/dev/null 2>&1 || fail 'Missing curl'
command -v parallel >/dev/null 2>&1 || fail 'Missing gnu parallel'

LIB_DIR=""
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LIB_DIR

if [ -z "${THIS_PLUGIN_DIR:-}" ]; then
  THIS_PLUGIN_DIR="$(dirname "${LIB_DIR}")"
fi
TOOL_PRODUCT_NAME="$(basename "${THIS_PLUGIN_DIR}")"
readonly TOOL_PRODUCT_NAME

PRODUCT_NAME=""
PRODUCT_NAME="$(basename "$(dirname "${LIB_DIR}")")"
readonly PRODUCT_NAME

readonly TOOL_NAME="apache"

fail() {
  echo -e "asdf-$TOOL_NAME|$TOOL_PRODUCT_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

install_version() {
  # shellcheck disable=SC2034
  local install_type="$1"
  local raw_user_version_arg="$2"
  local version="${raw_user_version_arg}"
  local install_path="${3%/bin}"
  local product_name="${PRODUCT_NAME}"
  local download_url filename add_version_info

  local product_file="${LIB_DIR}/${product_name}.sh"
  if [ -f "${product_file}" ]; then
    # shellcheck disable=SC1090
    . "${product_file}"
  fi
  local semver=""
  if [[ $(type -t semver_from_user_input) == function ]]; then
    semver="$(semver_from_user_input "${raw_user_version_arg}")"
  else
    semver="$(echo "${raw_user_version_arg}" | sed -E 's/([0-9]+\.[0-9]+(\.[0-9]+)?)-.*/\1/')"
  fi
  download_url="$(get_download_url "${product_name}" "${semver}" "${raw_user_version_arg}")"
  filename="$(basename "${download_url}")"

  mkdir -p "${ASDF_DOWNLOAD_PATH}"
  local filepath="${ASDF_DOWNLOAD_PATH}/${filename}"
  if [ ! -f "${filepath}" ]; then
    echo "Downloading ${product_name}-${raw_user_version_arg} from ${download_url}"
    download "${download_url}" "${filepath}" || (echo >&2 'not a valid version number' && exit 1)
  fi
  mkdir -p "${install_path}"
  extract "${filepath}" "${install_path}"
  if [ -z "${TOOL_TEST:-}" ]; then
    # not sure why this returns a status code of 1 on github actions
    local test_filepath=""
    test_filepath="$(find "${install_path}/bin" -type f \( -perm -u=x -o -perm -g=x -o -perm -o=x \) -exec test -x {} \; -print | head -n 1 || true)"
    TOOL_TEST="bin/$(basename "${test_filepath}")"
  fi
  (
    #mkdir -p "${install_path}"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    # TODO: Assert <YOUR TOOL> executable exists.
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}

extract() {
  local filename="$1"
  local output="$2"
  if [ -n "${DEBUG:-}" ]; then
    local VERBOSE="v"
  else
    local VERBOSE=""
  fi
  tar -x"${VERBOSE}f" "${filepath}" --strip-components=1 -C "${output}"
}

download() {
  local download_url="${1}"
  local output_path="${2}"
  local curl_cmd=""
  curl_cmd="$(command -vp curl)"
  $curl_cmd -fS -# "$download_url" -o "$output_path"
}

get_dist_folder() {
  local product_name="$1"
  echo "https://archive.apache.org/dist/${product_name}"
}

get_version_folder() {
  local product_name="$1"
  local semverish="$2"
  local dist_folder_url=""
  dist_folder_url="$(get_dist_folder "${product_name}")"
  curl "${curl_opts[*]}" "${dist_folder_url}/" 2>/dev/null | grep -o -E 'href=".+">' | grep -o -E "\".*${semverish}/\"" | tr -d '"/>'
}

default_filename_extended_pattern() {
  local product_name="$1"
  local raw_user_version_arg="$2"
  local version_folder_url="$3"
  local -r file_extensions="tgz|tar.gz"
  local version=""
  if [[ ! "${raw_user_version_arg}" =~ .*-src$ ]]; then
    add_version_info="$(cut -s -d'-' -f2 <<<"${raw_user_version_arg}")"
    if [ -n "${add_version_info}" ]; then
      add_version_info="-${add_version_info}"
    fi
    version="${semver}-bin${add_version_info}"
  fi

  echo "\".*${product_name}-${version}.(${file_extensions})\""
}

default_grep_filename() {
  local product_name="$1"
  local version_folder_url="$2"
  local raw_user_version_arg="$3"

  local pattern=""
  if [[ $(type -t filename_extended_pattern) == function ]]; then
    pattern="$(filename_extended_pattern "${product_name}" "${raw_user_version_arg}" "${version_folder_url}")"
  else
    pattern="$(default_filename_extended_pattern "${product_name}" "${raw_user_version_arg}" "${version_folder_url}")"
  fi
  curl "${curl_opts[*]}" "${version_folder_url}/" 2>/dev/null | grep -o -E 'href=".+">' | grep -o -E "${pattern}" | tr -d '"/>'
}

get_download_url() {
  local product_name="$1"
  local semver="$2"
  local raw_user_version_arg="$3"
  local -r product_file="${LIB_DIR}/${PRODUCT_NAME}.sh"
  if [ -f "${product_file}" ]; then
    # shellcheck disable=SC1090
    . "${product_file}"
  fi
  local dist_folder_url=""
  dist_folder_url="$(get_dist_folder "${product_name}")"
  local version_folder=""
  version_folder="$(get_version_folder "${product_name}" "${semver}")"
  [ -z "${version_folder}" ] && fail "Could not get subversion folder for '${semver}' in '${dist_folder_url}'"
  local filename=""
  if [[ $(type -t grep_filename) == function ]]; then
    filename="$(grep_filename "${product_name}" "${dist_folder_url}/${version_folder}" "${raw_user_version_arg}")"
  else
    filename="$(default_grep_filename "${product_name}" "${dist_folder_url}/${version_folder}" "${raw_user_version_arg}")"
  fi
  echo "${dist_folder_url}/${version_folder}/${filename}"
}
