#!/bin/bash
source "$(dirname "$BASH_SOURCE")"/linux-install-shared.sh
source "$(dirname "$BASH_SOURCE")"/defaults-gpl-shared.sh
FF_CONFIGURE="$FF_CONFIGURE --enable-alsa"
