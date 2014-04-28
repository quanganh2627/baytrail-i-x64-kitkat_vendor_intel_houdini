# Copyright (C) 20[14] Intel Corporation.  All rights reserved.
# Intel Confidential                                  RS-NDA # RS-8051151
# This [file/library] contains Houdini confidential information of Intel Corporation
# which is subject to a non-disclosure agreement between Intel Corporation
# and you or your company.

# file: vendor/intel/PREBUILT/SG/Android.mk
#
# This makefile is to generate the final version of the source
# ISA libraries. It only does so if the prebuilt ARM libraries
# were already copied to the libs_prebuilt folder. Otherwise it
# does nothing.
#

LOCAL_PATH := $(call my-dir)
HOUDINI_BASE_PATH := $(LOCAL_PATH)

ifeq ($(INTEL_HOUDINI),true)

# Houdini hook libraries for different module

include $(CLEAR_VARS)
LOCAL_MODULE := libhoudini_hook
LOCAL_MODULE_OWNER := intel_oblumg
LOCAL_SRC_FILES := hooks/libhoudini_hook.cpp
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := houdini_hook
LOCAL_MODULE_OWNER := intel_oblumg
LOCAL_SRC_FILES := hooks/houdini_hook.c
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := check.xml
LOCAL_MODULE_OWNER := intel_oblumg
LOCAL_SRC_FILES := system/lib/arm/$(LOCAL_MODULE)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/arm
include $(BUILD_PREBUILT)

endif
