include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/harfbuzz-1.6.3)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/behdad/harfbuzz/releases/download/1.6.3/harfbuzz-1.6.3.tar.bz2"
    FILENAME "harfbuzz-1.6.3.tar.bz2"
    SHA512 e31eb367beb61a9399d2c78b51c225ab2b1cbd46f364f2d80d97bb422b44101a
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/0001-fix-uwp-build.patch"
)

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm" OR VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    SET(HAVE_GLIB "OFF")
    SET(BUILTIN_UCDN "ON")
else()
    SET(HAVE_GLIB "ON")
    SET(BUILTIN_UCDN "OFF")
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DHB_HAVE_FREETYPE=ON
        -DHB_HAVE_GLIB=${HAVE_GLIB}
        -DHB_BUILTIN_UCDN=${BUILTIN_UCDN}
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/harfbuzz)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/harfbuzz/COPYING ${CURRENT_PACKAGES_DIR}/share/harfbuzz/copyright)
