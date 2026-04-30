#!/bin/bash

SCRIPT_REPO="https://github.com/alsa-project/alsa-lib.git"
SCRIPT_COMMIT="75ed5f05babcae7515aff5277e038ffd854c7669"

ffbuild_enabled() {
    [[ $TARGET == linux* ]] || return 1
    return 0
}

ffbuild_dockerbuild() {
    autoreconf -fi

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --with-configdir=/usr/share/alsa
        --with-plugindir=/usr/lib/alsa-lib
        --disable-python
        --disable-rawmidi
        --disable-sequencer
        --disable-alisp
        --disable-old-symbols
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
}

ffbuild_configure() {
    echo --enable-alsa
}

ffbuild_unconfigure() {
    echo --disable-alsa
}
