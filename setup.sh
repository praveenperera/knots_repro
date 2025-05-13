#!/bin/bash

set -eu pipefail

# Download Xcode15.xip if not present
if [ ! -f Xcode_15.xip ]; then
    curl https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_15/Xcode_15.xip -o Xcode_15.xip
fi
