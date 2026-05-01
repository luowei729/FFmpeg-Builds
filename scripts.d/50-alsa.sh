#!/bin/bash

SCRIPT_REPO="https://github.com/alsa-project/alsa-lib.git"
SCRIPT_COMMIT="75ed5f05babcae7515aff5277e038ffd854c7669"

ffbuild_enabled() {
    [[ $TARGET == linux* ]] || return 1
    return 0
}

ffbuild_dockerbuild() {
    # ALSA needs librt.a libpthread.a libm.a libdl.a in the cross-compilation sysroot
    # These are required by alsa.pc Libs.private entries for static linking

    autoreconf -fi

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --without-pic
        --without-versioned
        --with-configdir=/usr/share/alsa
        --with-plugindir=/usr/lib/alsa-lib
        --disable-python
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

ffbuild_libs() {
    echo -Wl,--whole-archive -lasound -Wl,--no-whole-archive -lm -ldl -lpthread -lrt
}

ffbuild_unconfigure() {
    echo --disable-alsa
}
