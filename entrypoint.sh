#!/bin/bash

set -e

# copy dotfiles into home dir if they don't exist
rsync \
    --links \
    --recursive \
    --ignore-existing \
    --chown="$(id -u):$(id -u)" \
    /opt/dotfiles/ "/home/$(whoami)/"

/usr/sbin/zsh "$@"
