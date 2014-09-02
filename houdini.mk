# Copyright (C) 20[14] Intel Corporation.  All rights reserved.
# Intel Confidential                                  RS-NDA # RS-8051151
# This [file/library] contains Houdini confidential information of Intel Corporation
# which is subject to a non-disclosure agreement between Intel Corporation
# and you or your company.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# __NOTE__:
# 1. The Native Bridge Helper library must be deployed as below:
#    On 32-bit target: /system/lib/libnativebridgehelper.so
#    On 64-bit target: /system/lib64/libnativebridgehelper.so
# 2. The Native Bridge Lib path must be:
#    On 32-bit target: /system/lib/arm
#    On 64-bit target: /system/lib64/arm
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Native Bridge Build Flag
WITH_NATIVE_BRIDGE := true

# Native Bridge Helper Build Flag
REBUILD_NATIVE_BRIDGE_HELPER := false

# Installing Native Bridge
ifeq ($(WITH_NATIVE_BRIDGE),true)

# Native Bridge Lib Name
NATIVE_BRIDGE_LIB_NAME := libhoudini.so

# Native Bridge Executable Name
NATIVE_BRIDGE_EXECUTABLE_NAME := houdini

# Native Bridge Helper Lib Name
NATIVE_BRIDGE_HELPER_LIB_NAME := libnativebridgehelper.so

# Native Bridge Helper Knobs Name
NATIVE_BRIDGE_HELPER_KNOBS_NAME := nativebridge.knobs

# Native Bridge Path
NATIVE_BRIDGE_PATH := vendor/intel/houdini

# Native Bridge Prebuilt Path
NATIVE_BRIDGE_PREBUILT_PATH := $(NATIVE_BRIDGE_PATH)/prebuilt

# Native Bridge Bin Path
NATIVE_BRIDGE_BIN_PATH := $(NATIVE_BRIDGE_PATH)/system/bin

# Native Bridge Lib Path
NATIVE_BRIDGE_LIB_PATH := $(NATIVE_BRIDGE_PATH)/system/lib

# Native Bridge Target Lib Path
NATIVE_BRIDGE_TARGET_LIB_PATH := $(NATIVE_BRIDGE_LIB_PATH)/arm

# Native Bridge 64 Bit Lib Path
NATIVE_BRIDGE_LIB64_PATH := $(NATIVE_BRIDGE_PATH)/system/lib64

# Native Bridge Target 64 Bit Lib Path
NATIVE_BRIDGE_TARGET_LIB64_PATH := $(NATIVE_BRIDGE_LIB64_PATH)/arm

# Native Bridge ABI List
NATIVE_BRIDGE_ABI_LIST_32_BIT := armeabi

# Native Bridge ABI 64 Bit List
NATIVE_BRIDGE_ABI_LIST_64_BIT :=

# Support 64 Bit Apps
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)

  # Set 64 Bit ABI List
  TARGET_CPU_ABI ?= x86_64
  TARGET_CPU_ABI2 ?= arm64-v8a 
  TARGET_CPU_ABI_LIST_64_BIT := $(TARGET_CPU_ABI) $(TARGET_CPU_ABI2) $(NATIVE_BRIDGE_ABI_LIST_64_BIT)

  # Copying Native Bridge 64 Bit Lib
  PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_LIB64_PATH)/libhoudini_x86_64.so:/system/lib64/$(NATIVE_BRIDGE_LIB_NAME):intel

  # Copying Native Bridge Target 64 Bit Libs
  PRODUCT_COPY_FILES += $(foreach LIB64, $(notdir $(wildcard $(NATIVE_BRIDGE_TARGET_LIB64_PATH)/*)), \
      $(NATIVE_BRIDGE_TARGET_LIB64_PATH)/$(LIB64):/system/lib64/arm/$(LIB64):intel)

  # Copying Native Bridge Knobs File for 64 Bit Apps
  PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_PREBUILT_PATH)/knobs_x86_64:/system/lib64/arm/$(NATIVE_BRIDGE_HELPER_KNOBS_NAME):intel

  # Reset Dex Code Instruction Set
  ADDITIONAL_BUILD_PROPERTIES += ro.dalvik.vm.isa.arm64=x86_64

  # Also Support 32 Bit Apps
  ifeq ($(TARGET_SUPPORTS_32_BIT_APPS),true)

    # Set 32 Bit ABI List
    TARGET_2ND_CPU_ABI ?= x86
    TARGET_2ND_CPU_ABI2 ?= armeabi-v7a
    TARGET_CPU_ABI_LIST_32_BIT := $(TARGET_2ND_CPU_ABI) $(TARGET_2ND_CPU_ABI2) $(NATIVE_BRIDGE_ABI_LIST_32_BIT)

    # Copying Native Bridge Lib
    PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_LIB_PATH)/libhoudini_x64_x32.so:/system/lib/$(NATIVE_BRIDGE_LIB_NAME):intel
	
    # Copying Native Bridge Target Libs
    PRODUCT_COPY_FILES += $(foreach LIB, $(notdir $(wildcard $(NATIVE_BRIDGE_TARGET_LIB_PATH)/*)), \
        $(NATIVE_BRIDGE_TARGET_LIB_PATH)/$(LIB):/system/lib/arm/$(LIB):intel)

    # Copying Native Bridge Knobs File for 32 Bit Apps
    PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_PREBUILT_PATH)/knobs_x86:/system/lib/arm/$(NATIVE_BRIDGE_HELPER_KNOBS_NAME):intel

    # Reset Dex Code Instruction Set
    ADDITIONAL_BUILD_PROPERTIES += ro.dalvik.vm.isa.arm=x86

  # End of TARGET_SUPPORTS_32_BIT_APPS
  endif

# Support 32 Bit Apps Only
else

  # Set 32 Bit ABI List
  TARGET_CPU_ABI ?= x86
  TARGET_CPU_ABI2 ?= armeabi-v7a
  TARGET_CPU_ABI_LIST_32_BIT := $(TARGET_CPU_ABI) $(TARGET_CPU_ABI2) $(NATIVE_BRIDGE_ABI_LIST_32_BIT)

  # Supoort 64 Bit Kernel
  ifeq ($(TARGET_KERNEL_ARCH),x86_64)

    # Copying Native Bridge 64 Bit Lib
    PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_LIB_PATH)/libhoudini_x64_x32.so:/system/lib/$(NATIVE_BRIDGE_LIB_NAME):intel

  # Supoort 32 Bit Kernel
  else

    # Copying Native Bridge 32 Bit Lib
    PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_LIB_PATH)/libhoudini_x86.so:/system/lib/$(NATIVE_BRIDGE_LIB_NAME):intel

  # End of TARGET_KERNEL_ARCH
  endif

  # Copying Native Bridge Target Libs
  PRODUCT_COPY_FILES += $(foreach LIB, $(notdir $(wildcard $(NATIVE_BRIDGE_TARGET_LIB_PATH)/*)), \
      $(NATIVE_BRIDGE_TARGET_LIB_PATH)/$(LIB):/system/lib/arm/$(LIB):intel)

  # Copying Native Bridge Knobs File for 32 Bit Apps
  PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_PREBUILT_PATH)/knobs_x86:/system/lib/arm/$(NATIVE_BRIDGE_HELPER_KNOBS_NAME):intel

  # Reset Dex Code Instruction Set
  ADDITIONAL_BUILD_PROPERTIES += ro.dalvik.vm.isa.arm=x86

# End of TARGET_SUPPORTS_64_BIT_APPS
endif

# Support 64 Bit Kernel
ifeq ($(TARGET_KERNEL_ARCH),x86_64)

  # Copying Native Bridge 64 Bit Executables
  PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_BIN_PATH)/houdini_x64_x32:/system/bin/$(NATIVE_BRIDGE_EXECUTABLE_NAME):intel

# Support 32 Bit Kernel
else

  # Copying Native Bridge 32 Bit Executables
  PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_BIN_PATH)/houdini_x86:/system/bin/$(NATIVE_BRIDGE_EXECUTABLE_NAME):intel

# End of TARGET_KERNEL_ARCH
endif

# If Not Rebuild Native Bridge Helper
ifneq ($(REBUILD_NATIVE_BRIDGE_HELPER),true)

  # Copying Native Bridge Helper 32 Bit Lib
  PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_LIB_PATH)/libnativebridgehelper.so:/system/lib/$(NATIVE_BRIDGE_HELPER_LIB_NAME):intel

  # Support 64 Bit Apps
  ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)

    # Copying Native Bridge Helper 64 Bit Lib
    PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_LIB64_PATH)/libnativebridgehelper.so:/system/lib64/$(NATIVE_BRIDGE_HELPER_LIB_NAME):intel

  # End of TARGET_SUPPORTS_64_BIT_APPS
  endif

# End of REBUILD_NATIVE_BRIDGE_HELPER
endif

# Copying Native Bridge Scripts
PRODUCT_COPY_FILES += $(NATIVE_BRIDGE_BIN_PATH)/enable_native_bridge:/system/bin/enable_native_bridge:intel \
                      $(NATIVE_BRIDGE_BIN_PATH)/disable_native_bridge:/system/bin/disable_native_bridge:intel

# Native Bridge Lib Name
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.dalvik.vm.native.bridge=$(NATIVE_BRIDGE_LIB_NAME)

# Enabling Native Bridge By Default
ADDITIONAL_BUILD_PROPERTIES += persist.enable.native.bridge=true

# End of WITH_NATIVE_BRIDGE
endif
