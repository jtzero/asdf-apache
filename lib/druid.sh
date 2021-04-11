
PRODUCT_SPECIFIC_EXTENSION="tar.gz"

get_product_specific_download_url() {
  local product_name="$1"
  local semver="$2"
  local versions="$3"
  echo "https://archive.apache.org/dist/${product_name}/${semver}/apache-${product_name}-${versions}.${PRODUCT_SPECIFIC_EXTENSION}"
}
