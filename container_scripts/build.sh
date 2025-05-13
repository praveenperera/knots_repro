#!/usr/bin/bash
set -eu pipefail

# start the daemon (unprivileged, chroot disabled)
mkdir -p /var/guix/daemon-socket
guix-daemon \
  --disable-chroot \
  --max-jobs=8 \
  --listen=/var/guix/daemon-socket/socket & 

sleep 5

# try to run guix pull
set +e
guix pull
result=$?
set -e

# install locales and update Guix itself
guix install glibc-locales
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"

if [ "$result" -ne 0 ]; then
  echo "➤ guix pull failed (exit code $result), installed glibc-locales,  retrying..."
  guix pull
fi

# 4) Set up your profile environment
export GUIX_PROFILE="$HOME/.config/guix/current"
. "$GUIX_PROFILE/etc/profile"

# 6) Now run your Knots build
echo "Running guix build, building knots..."
./contrib/guix/guix-build

# 7) Preserve the result
cp -r result /home/guix/artifacts/
