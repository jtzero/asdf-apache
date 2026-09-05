#!/usr/bin/env bash

# removing the "dialect" from template so that editorconfig is used
shfmt -w ./**/*
