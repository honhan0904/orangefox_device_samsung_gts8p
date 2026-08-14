#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from gts8p device
$(call inherit-product, device/samsung/gts8p/device.mk)

PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,device/samsung/gts8p/recovery/root,recovery/root)

PRODUCT_DEVICE := gts8p
PRODUCT_NAME := orangefox_gts8p
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-X806B
PRODUCT_MANUFACTURER := samsung

PRODUCT_GMS_CLIENTID_BASE := android-samsung

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="gts8pxxx-user 15 AP3A.240905.015.A2 X806BXXS9DYI1 release-keys"

BUILD_FINGERPRINT := samsung/gts8pxxx/gts8p:15/AP3A.240905.015.A2/X806BXXS9DYI1:user/release-keys

# OrangeFox-specific
OF_MAINTAINER := honhan0904
FOX_TARGET_DEVICES := gts8p
FOX_RECOVERY_INSTALL_PARTITION := /dev/block/bootdevice/by-name/recovery
