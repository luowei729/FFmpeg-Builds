#!/bin/bash
source "$(dirname "$BASH_SOURCE")"/linux-install-static.sh
source "$(dirname "$BASH_SOURCE")"/defaults-lgpl.sh
FF_CONFIGURE="$FF_CONFIGURE --enable-alsa"
