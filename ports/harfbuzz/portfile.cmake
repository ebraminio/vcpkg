vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO harfbuzz/harfbuzz
    REF a01c7a380b9a3351bc7056c816e1340b5374a6f8 # 2.7.0
    SHA512 7e038aa640194d532c6eb22a7f47c8ee1bd7a6e22f80f025e8cd8a8886cd2170f10a812e4d03018a915ff2ec7e13c89c1381b269be057b5d9b1c52d3a14db3b8
    HEAD_REF master
    PATCHES
        0002-fix-uwp-build.patch
        # This patch is required for propagating the full list of dependencies from glib
        glib-cmake.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    icu         icu
    graphite2   graphite
    glib        glib
)

vcpkg_configure_meson(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS # ${FEATURE_OPTIONS}
        -Dglib=disabled
        -Dgobject=disabled
        -Ddocs=disabled
        -Dtests=disabled
        --backend=ninja
)

vcpkg_install_meson()
vcpkg_copy_pdbs()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
