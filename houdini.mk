# Copyright (C) 20[14] Intel Corporation.  All rights reserved.
# Intel Confidential                                  RS-NDA # RS-8051151
# This [file/library] contains Houdini confidential information of Intel Corporation
# which is subject to a non-disclosure agreement between Intel Corporation
# and you or your company.

# Enable Native Bridge Build Flag
WITH_NATIVE_BRIDGE := true

# Install Native Bridge
ifeq ($(WITH_NATIVE_BRIDGE),true)

# Native Bridge Binary Name
NB_EXE_NAME := houdini
NB_EXE64_NAME := houdini64
NB_LIB_NAME := libhoudini.so

NB_PATH := vendor/intel/houdini
NB_LIB_PATH := system/lib
NB_ARM_PATH := $(NB_LIB_PATH)/arm
NB_NBLIB_PATH := $(NB_ARM_PATH)/nb
NB_LIB64_PATH := system/lib64
NB_ARM64_PATH := $(NB_LIB64_PATH)/arm64
NB_NBLIB64_PATH := $(NB_ARM64_PATH)/nb
NB_BIN_PATH := system/bin
NB_FMT_PATH := system/etc/binfmt_misc

NB_32BIT_ENABLE := false
NB_64BIT_ENABLE := false
NB_32BIT_SUFFIX := x

# Support 64 Bit Apps
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)
  NB_64BIT_ENABLE = true
  ifeq ($(TARGET_SUPPORTS_32_BIT_APPS),true)
    NB_32BIT_ENABLE = true
    NB_32BIT_SUFFIX = y
  endif
else
  NB_32BIT_ENABLE = true
  ifeq ($(TARGET_KERNEL_ARCH),x86_64)
    NB_32BIT_SUFFIX = y
  else
    ifeq ($(BOARD_USE_64BIT_KERNEL),true)
      NB_32BIT_SUFFIX = y
    endif
  endif
endif

ifeq ($(NB_64BIT_ENABLE),disabled)
  PRODUCT_COPY_FILES += $(NB_PATH)/$(NB_BIN_PATH)/houdini_z:$(NB_BIN_PATH)/$(NB_EXE64_NAME):intel
  PRODUCT_COPY_FILES += $(NB_PATH)/$(NB_LIB64_PATH)/libhoudini_z.so:$(NB_LIB64_PATH)/$(NB_LIB_NAME):intel
  PRODUCT_COPY_FILES += $(foreach LIB64, $(filter-out nb, $(notdir $(wildcard $(NB_PATH)/$(NB_ARM64_PATH)/*))), \
      $(NB_PATH)/$(NB_ARM64_PATH)/$(LIB64):$(NB_ARM64_PATH)/$(LIB64):intel)
  PRODUCT_COPY_FILES += $(foreach NB64, $(notdir $(wildcard $(NB_PATH)/$(NB_NBLIB64_PATH)/*)), \
      $(NB_PATH)/$(NB_NBLIB64_PATH)/$(NB64):$(NB_NBLIB64_PATH)/$(NB64):intel)
  PRODUCT_COPY_FILES += $(foreach FMT64, $(filter arm64_%, $(notdir $(wildcard $(NB_PATH)/$(NB_FMT_PATH)/*))), \
      $(NB_PATH)/$(NB_FMT_PATH)/$(FMT64):$(NB_FMT_PATH)/$(FMT64):intel)
  ADDITIONAL_BUILD_PROPERTIES += ro.dalvik.vm.isa.arm64=x86_64 ro.enable.native.bridge.exec64=1
endif

ifeq ($(NB_32BIT_ENABLE),true)
  PRODUCT_COPY_FILES += $(NB_PATH)/$(NB_BIN_PATH)/houdini_$(NB_32BIT_SUFFIX):$(NB_BIN_PATH)/$(NB_EXE_NAME):intel
  PRODUCT_COPY_FILES += $(NB_PATH)/$(NB_LIB_PATH)/libhoudini_$(NB_32BIT_SUFFIX).so:$(NB_LIB_PATH)/$(NB_LIB_NAME):intel
  PRODUCT_COPY_FILES += $(foreach LIB, $(filter-out nb, $(notdir $(wildcard $(NB_PATH)/$(NB_ARM_PATH)/*))), \
      $(NB_PATH)/$(NB_ARM_PATH)/$(LIB):$(NB_ARM_PATH)/$(LIB):intel)
  PRODUCT_COPY_FILES += $(foreach NB, $(notdir $(wildcard $(NB_PATH)/$(NB_NBLIB_PATH)/*)), \
      $(NB_PATH)/$(NB_NBLIB_PATH)/$(NB):$(NB_NBLIB_PATH)/$(NB):intel)
  PRODUCT_COPY_FILES += $(foreach FMT, $(filter arm_%, $(notdir $(wildcard $(NB_PATH)/$(NB_FMT_PATH)/*))), \
      $(NB_PATH)/$(NB_FMT_PATH)/$(FMT):$(NB_FMT_PATH)/$(FMT):intel)
  ADDITIONAL_BUILD_PROPERTIES += ro.dalvik.vm.isa.arm=x86 ro.enable.native.bridge.exec=1
endif

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.dalvik.vm.native.bridge=$(NB_LIB_NAME)

endif
