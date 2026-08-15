#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

__gts8p_apply_patch() {
    local repo="$1" patch="$2"
    [ -f "$patch" ] || { echo "gts8p: missing patch $patch"; return 0; }
    [ -d "$repo/.git" ] || return 0

    # Already applied (reverse applies cleanly) -> nothing to do.
    if git -C "$repo" apply --reverse --check "$patch" >/dev/null 2>&1; then
        return 0
    fi

    # Applies cleanly against pristine -> apply it.
    if git -C "$repo" apply --check "$patch" >/dev/null 2>&1; then
        git -C "$repo" apply "$patch" && echo "gts8p: applied $(basename "$patch") to $repo"
    else
        echo "gts8p: WARNING: could not apply $(basename "$patch") to $repo (already partially applied or upstream context changed)"
    fi
}

__gts8p_install_theme() {
    local top theme dest file
    top="$(gettop 2>/dev/null)"
    [ -z "$top" ] && top="$ANDROID_BUILD_TOP"
    [ -z "$top" ] && return 0

    # OrangeFox's build expects these files under the device recovery root.
    # The X806B tree follows the reference gts8wifi portrait_hdpi theme.
    theme="$top/bootable/recovery/gui/theme/portrait_hdpi"
    dest="$top/device/samsung/gts8p/recovery/root/twres"

    [ -d "$theme" ] || { echo "gts8p: WARNING: theme directory not found: $theme"; return 0; }

    mkdir -p "$dest"
    for file in splash.xml ui.xml; do
        if [ -f "$theme/$file" ]; then
            cp -f "$theme/$file" "$dest/$file"
            echo "gts8p: installed theme asset $file"
        else
            echo "gts8p: WARNING: missing theme asset $theme/$file"
        fi
    done
}

__gts8p_apply_patches() {
    local top patchdir
    top="$(gettop 2>/dev/null)"
    [ -z "$top" ] && top="$ANDROID_BUILD_TOP"
    [ -z "$top" ] && return 0

    patchdir="$top/device/samsung/gts8p/patches"
    [ -d "$patchdir" ] || return 0

    __gts8p_apply_patch "$top/system/vold" "$patchdir/0001-vold-gts8wifi-fbe-weaver.patch"
}

# The theme hook and patch hook are intentionally best-effort: missing/incompatible
# assets or patches must never make build/envsetup.sh fail for the X806B tree.
__gts8p_install_theme
__gts8p_apply_patches
