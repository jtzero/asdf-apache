#!/usr/bin/env bash

export TOOL_TEST="bin/kafka-cluster.sh"

semver_from_user_input() {
  local raw_user_arg="${1}"
  printf "%s" "${raw_user_arg}" | cut -d- -f2
}

default_filename_extended_pattern() {
  local product_name="$1"
  local version_type="$2"
  local -r file_extensions="tgz|tar.gz"
  echo "\".*${product_name}_${version_type}.(${file_extensions})\""
}

list_sub_versions() {
  local file_names="${1}"
  local include_src="${2}"
  local include_site_docs="${INCLUDE_SITE_DOCS:-0}"
  local compressed
  include_site_docs="${3:-1}"
  compressed="$(printf "%s" "${file_names}" |
    grep -E 'tgz|tar\.gz' |
    sed -E 's/'"${product_name}"'[-_](.+)(\.tgz|\.tar.gz)/\1/g')"

  local filters=()
  if [ "${include_src}" = "1" ]; then
    filters[1]='\-src'
  fi
  if [ "${include_site_docs}" = "1" ]; then
    filters[2]='\-site-docs'
  fi

  local filter_clause=""
  filter_clause="$(join_by '|' "${filters[1]}" "${filters[2]}")"

  if [ -n "${filter_clause}" ]; then
    printf "%s" "${compressed}" | grep -E -v "${filter_clause}"
  else
    printf "%s" "${compressed}"
  fi
}

function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}
