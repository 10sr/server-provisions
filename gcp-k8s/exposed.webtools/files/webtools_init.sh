#!/bin/sh
set -eux

envsubst \
    <$WEBTOOLS_SETTINGS_TOML_ENVSUBST \
    >$WEBTOOLS_SETTINGS_TOML

env

cat $WEBTOOLS_SETTINGS_TOML
