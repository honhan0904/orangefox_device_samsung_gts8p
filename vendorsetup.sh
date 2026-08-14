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

__gts8p_apply_patches() {
    local top patchdir
    top="$(gettop 2>/dev/null)"
    [ -z "$top" ] && top="$ANDROID_BUILD_TOP"
    [ -z "$top" ] && return 0

    patchdir="$top/device/samsung/gts8p/patches"
    [ -d "$patchdir" ] || return 0

    __gts8p_apply_patch "$top/system/vold" "$patchdir/0001-vold-gts8wifi-fbe-weaver.patch"
}

# The patch hook is intentionally best-effort: missing/incompatible patches
# must never make build/envsetup.sh fail for the X806B tree.
__gts8p_apply_patches
