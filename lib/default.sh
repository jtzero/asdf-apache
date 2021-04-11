#!/usr/bin/env bash

set -Eeuo pipefail

if [ -z "${BASH_SOURCE}" ]; then
  # zsh
  readonly LIB_DIR="$( cd "$( dirname "${(%):-%N}" )" && pwd )"
else
  readonly LIB_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fi

DEFAULT_EXTENSION="tgz"


get_default_download_url() {
  local product_name="$1"
  local semver="$2"
  local versions="$3"
  echo "https://archive.apache.org/dist/${product_name}/${product_name}-${semver}/${product_name}-${versions}.${DEFAULT_EXTENSION}"
}

load_specific_config() {
  local product_name="$1"

  if [[ -f "${LIB_DIR}/${product_name}.sh" ]]; then
    source "${LIB_DIR}/${product_name}.sh"
  fi

  if [[ "${PRODUCT_SPECIFIC_EXTENSION:-}" ]]; then
    EXTENSION="${PRODUCT_SPECIFIC_EXTENSION}"
  else
    EXTENSION="${DEFAULT_EXTENSION}"
  fi

  if type 'get_product_specific_download_url' 2>&1 >/dev/null; then
    get_download_url() {
      get_product_specific_download_url $*
    }
  else
    get_download_url() {
      get_default_download_url $*
    }
  fi
}
