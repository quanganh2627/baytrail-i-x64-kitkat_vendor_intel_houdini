# Copyright (C) 20[14] Intel Corporation.  All rights reserved.
# Intel Confidential                                  RS-NDA # RS-8051151
# This [file/library] contains Houdini confidential information of Intel Corporation
# which is subject to a non-disclosure agreement between Intel Corporation
# and you or your company.

# Native Bridge Build Flag
WITH_NATIVE_BRIDGE := true

# Installing Native Bridge
ifeq ($(WITH_NATIVE_BRIDGE),true)

# Native Bridge Lib Name
NATIVE_BRIDGE_LIB_NAME := libhoudini.so

# Native Bridge Executable Name
NATIVE_BRIDGE_EXECUTABLE_NAME := houdini

# Native Bridge Path
NATIVE_BRIDGE_PATH := vendor/intel/houdini

# Native Bridge Registration Path
NATIVE_BRIDGE_BINFMT_MISC_PATH := $(NATIVE_BRIDGE_PATH)/system/etc/binfmt_misc

# Native Bridge Bin Path
NATIVE_BRIDGE_BIN_PATH := $(NATIVE_BRIDGE_PATH)/system/bin

# Native Bridge Lib Path
NATIVE_BRIDGE_LIB_PATH := $(NATIVE_BRIDGE_PATH)/system/lib

# Native Bridge Target Lib Path
NATIVE_BRIDGE_TARGET_LIB_PATH := $(NATIVE_BRIDGE_LIB_PATH)/arm

# Native Bridge Target Image Lib Path
NATIVE_BRIDGE_TARGET_IMG_LIB_PATH := /system/lib/arm

# Native Bridge 64 Bit Lib Path
NATIVE_BRIDGE_LIB64_PATH := $(NATIVE_BRIDGE_PATH)/system/lib64

# Native Bridge Target 64 Bit Lib Path
NATIVE_BRIDGE_TARGET_LIB64_PATH := $(NATIVE_BRIDGE_LIB64_PATH)/arm64

# Native Bridge Target Image 64 Bit Lib Path
NATIVE_BRIDGE_TARGET_IMG_LIB64_PATH := /system/lib64/arm64

# Native Bridge ABI List
NATIVE_BRIDGE_ABI_LIST_32_BIT := armeabi

# Native Bridge ABI 64 Bit List
NATIVE_BRIDGE_ABI_LIST_64_BIT :=

# Native Bridge for 64 Bit Kernel
NATIVE_BRIDGE_64_BIT_KERNEL := false

# Support 64 Bit Apps
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)

  # Set Native Bridge with 64 Bit Kernel
  NATIVE_BRIDGE_64_BIT_KERNEL := true

  # Set 64 Bit ABI List
  TARGET_CPU_ABI ?= x86_64
  TARGET_CPU_ABI2 ?= arm64-v8a
  TARGET_CPU_ABI_LIST_64_BIT := $(TARGET_CPU_ABI) $(TARGET_CPU_ABI2) $(NATIVE_BRIDGE_ABI_LIST_64_BIT)

  # Copying Native Bridge 64 Bit Lib
  # PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_LIB64_PATH)/libhoudini_z.so:/system/lib64/$(NATIVE_BRIDGE_LIB_NAME):intel

  # Copying Native Bridge Target 64 Bit Libs
  # PRODUCT_COPY_FILES += $(foreach LIB64, $(notdir $(wildcard $(NATIVE_BRIDGE_TARGET_LIB64_PATH)/*)), \
      $(NATIVE_BRIDGE_TARGET_LIB64_PATH)/$(LIB64):$(NATIVE_BRIDGE_TARGET_IMG_LIB64_PATH)/$(LIB64):intel)

  # Reset Dex Code Instruction Set
  ADDITIONAL_BUILD_PROPERTIES += ro.dalvik.vm.isa.arm64=x86_64

  # Also Support 32 Bit Apps
  ifeq ($(TARGET_SUPPORTS_32_BIT_APPS),true)

    # Set 32 Bit ABI List
    TARGET_2ND_CPU_ABI ?= x86
    TARGET_2ND_CPU_ABI2 ?= armeabi-v7a
    TARGET_CPU_ABI_LIST_32_BIT := $(TARGET_2ND_CPU_ABI) $(TARGET_2ND_CPU_ABI2) $(NATIVE_BRIDGE_ABI_LIST_32_BIT)

    # Copying Native Bridge Lib
    PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_LIB_PATH)/libhoudini_y.so:/system/lib/$(NATIVE_BRIDGE_LIB_NAME):intel

    # Copying Native Bridge Target Libs
    PRODUCT_COPY_FILES += $(foreach LIB, $(notdir $(wildcard $(NATIVE_BRIDGE_TARGET_LIB_PATH)/*)), \
        $(NATIVE_BRIDGE_TARGET_LIB_PATH)/$(LIB):$(NATIVE_BRIDGE_TARGET_IMG_LIB_PATH)/$(LIB):intel)

    # Reset Dex Code Instruction Set
    ADDITIONAL_BUILD_PROPERTIES += ro.dalvik.vm.isa.arm=x86

  # End of TARGET_SUPPORTS_32_BIT_APPS
  endif

# Support 32 Bit Apps Only
else

  # Set Native Bridge with 64 Bit Kernel
  ifeq ($(TARGET_KERNEL_ARCH),x86_64)
    NATIVE_BRIDGE_64_BIT_KERNEL := true
  else
    NATIVE_BRIDGE_64_BIT_KERNEL := $(BOARD_USE_64BIT_KERNEL)
  endif

  # Set 32 Bit ABI List
  TARGET_CPU_ABI ?= x86
  TARGET_CPU_ABI2 ?= armeabi-v7a
  TARGET_CPU_ABI_LIST_32_BIT := $(TARGET_CPU_ABI) $(TARGET_CPU_ABI2) $(NATIVE_BRIDGE_ABI_LIST_32_BIT)

  # Supoort 64 Bit Kernel
  ifeq ($(NATIVE_BRIDGE_64_BIT_KERNEL),true)

    # Copying Native Bridge 64 Bit Lib
    PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_LIB_PATH)/libhoudini_y.so:/system/lib/$(NATIVE_BRIDGE_LIB_NAME):intel

  # Supoort 32 Bit Kernel
  else

    # Copying Native Bridge 32 Bit Lib
    PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_LIB_PATH)/libhoudini_x.so:/system/lib/$(NATIVE_BRIDGE_LIB_NAME):intel

  # End of NATIVE_BRIDGE_64_BIT_KERNEL
  endif

  # Copying Native Bridge Target Libs
  PRODUCT_COPY_FILES += $(foreach LIB, $(notdir $(wildcard $(NATIVE_BRIDGE_TARGET_LIB_PATH)/*)), \
      $(NATIVE_BRIDGE_TARGET_LIB_PATH)/$(LIB):$(NATIVE_BRIDGE_TARGET_IMG_LIB_PATH)/$(LIB):intel)

  # Reset Dex Code Instruction Set
  ADDITIONAL_BUILD_PROPERTIES += ro.dalvik.vm.isa.arm=x86

# End of TARGET_SUPPORTS_64_BIT_APPS
endif

# Support 64 Bit Kernel
ifeq ($(NATIVE_BRIDGE_64_BIT_KERNEL),true)

  # Copying Native Bridge 64 Bit Executables
  PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_BIN_PATH)/houdini_y:/system/bin/$(NATIVE_BRIDGE_EXECUTABLE_NAME):intel

# Support 32 Bit Kernel
else

  # Copying Native Bridge 32 Bit Executables
  PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_BIN_PATH)/houdini_x:/system/bin/$(NATIVE_BRIDGE_EXECUTABLE_NAME):intel

# End of NATIVE_BRIDGE_64_BIT_KERNEL
endif

# Copying BINFMT_MISC Interpreter Registration Files
PRODUCT_COPY_FILES += $(foreach FMT, $(notdir $(wildcard $(NATIVE_BRIDGE_BINFMT_MISC_PATH)/*)), \
    $(NATIVE_BRIDGE_BINFMT_MISC_PATH)/$(FMT):/system/etc/binfmt_misc/$(FMT):intel)

# Enable Native Bridge Executable by default
ADDITIONAL_BUILD_PROPERTIES += ro.enable.native.bridge.exec=1

# Native Bridge Lib Name
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.dalvik.vm.native.bridge=$(NATIVE_BRIDGE_LIB_NAME)

# End of WITH_NATIVE_BRIDGE
endif
