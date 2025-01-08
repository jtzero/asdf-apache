#!/usr/bin/env bash

set -euo pipefail

latest_stable_pattern() {
  printf '%s' '.*'
}

case "$1" in
latest_stable_pattern)
  latest_stable_pattern
  ;;
*)
  echo "Unknown function $1" >&2
  exit 1
  ;;
esac
