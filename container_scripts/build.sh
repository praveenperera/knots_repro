#!/bin/bash

set -eu pipefail

# 1) Bring Guix up‑to‑date (`guix pull`) and mimic the .profile edits
mkdir -p /var/guix/daemon-socket 
guix-daemon --listen=/var/guix/daemon-socket/socket & 
sleep 5

guix pull

# append the following two lines to your $HOME/.profile file:
export GUIX_PROFILE="$HOME/.config/guix/current"
. "$GUIX_PROFILE/etc/profile"

guix install glibc-locales
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"

# run the build
./contrib/guix/guix-build

# Keep artefacts for a skinny follow‑up image
mkdir -p /artifacts
cp -r contrib/guix/result /artifacts/
