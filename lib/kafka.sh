#!/usr/bin/env bash

TOOL_TEST="bin/kafka-cluster.sh"

semver_from_user_input() {
  local raw_user_arg="${1}"
  printf "${raw_user_arg}" | cut -d- -f2
}

default_filename_extended_pattern() {
  local product_name="$1"
  local version_type="$2"
  local version_folder_url="$3"
  local readonly file_extensions="tgz|tar.gz"
  echo "\".*${product_name}_${version_type}.(${file_extensions})\""
}

# asdf auto parses args and gets user_version_arg.split('-')[0]
list_sub_versions() {
  local file_names="${1}"
  local include_src="${2}"
  local include_site_docs="${3:-1}"
  local compressed="$(printf "%s" "${file_names}" | \
  grep -E 'tgz|tar\.gz' | \
  sed -E 's/'"${product_name}"'[-_](.+)(\.tgz|\.tar.gz)/\1/g')"

  if [ "${include_src}" = "0" ]; then
    printf "${compressed}"
  else
    printf "${compressed}" | grep -E -v "\-src|\-site-docs"
  fi
}
