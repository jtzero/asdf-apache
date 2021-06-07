#!/usr/bin/env bash

if [ -z "${BASH_SOURCE[0]:-}" ]; then
  # zsh
  SCRIPTS_DIR="${0:A:h}"
else
  SCRIPTS_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
fi

old_pwd="${PWD}"

SCRIPTS_ROOT="$(dirname "${SCRIPTS_BIN_DIR}")"

cd "${SCRIPTS_ROOT}" || exit 1
for file in $(shfmt -f .); do
  shfmt -w "${file}"
done
cd "${old_pwd}" || exit 1
