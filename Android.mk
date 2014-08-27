
# Copyright (C) 20[14] Intel Corporation.  All rights reserved.
# Intel Confidential                                  RS-NDA # RS-8051151
# This [file/library] contains Houdini confidential information of Intel Corporation
# which is subject to a non-disclosure agreement between Intel Corporation
# and you or your company.

LOCAL_PATH := $(call my-dir)

ifeq ($(WITH_NATIVE_BRIDGE),true)

ifneq ($(REBUILD_NATIVE_BRIDGE_HELPER),true)

include $(CLEAR_VARS)
LOCAL_MODULE := cat

# For 64 Bit Kernel
ifeq ($(TARGET_IS_64_BIT),true)
LOCAL_SRC_FILES := prebuilt/cat_x86_64
# For 32 Bit Kernel
else
LOCAL_SRC_FILES := prebuilt/cat_x86
# End of TARGET_IS_64_BIT
endif

LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_OWNER := intel
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT)/bin
include $(BUILD_PREBUILT)

# Rebuild Native Bridge Helper
else

-include $(LOCAL_PATH)/nativebridgehelper/nativebridgehelper.mk

# End of REBUILD_NATIVE_BRIDGE_HELPER
endif

# End of WITH_NATIVE_BRIDGE
endif
