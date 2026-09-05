#!/usr/bin/env bash

shellcheck --shell=bash --external-sources \
  bin/* --source-path=template/lib/ \
  lib/* \
  scripts/*

# removing the "dialect" from template so that editorconfig is used
shfmt --diff \
  ./**/*
