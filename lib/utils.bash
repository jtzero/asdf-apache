set -euo pipefail

TOOL_PRODUCT_NAME="$(basename "$(dirname ${ASDF_INSTALL_PATH})")"

TOOL_NAME="asdf-apache"

fail() {
  echo -e "asdf-$TOOL_NAME|$TOOL_PRODUCT_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)
