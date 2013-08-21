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

include $(CLEAR_VARS)

product_path := $(TARGET_OUT_SHARED_LIBRARIES)

# Houdini prebuilt binaries

include $(CLEAR_VARS)
LOCAL_MODULE := libhoudini
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := $(TARGET_SHLIB_SUFFIX)

OVERRIDE_BUILT_MODULE_PATH := $(TARGET_OUT_INTERMEDIATE_LIBRARIES)
include $(BUILD_SYSTEM)/dynamic_binary.mk
$(linked_module):
	$(HOUDINI_BASE_PATH)/copy_libhoudini.sh $(HOUDINI_BASE_PATH) $(PRODUCT_OUT)

include $(CLEAR_VARS)
LOCAL_PREBUILT_EXECUTABLES := system/bin/houdini system/bin/enable_houdini system/bin/disable_houdini
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_OUT)/bin
include $(BUILD_MULTI_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := check.xml
LOCAL_SRC_FILES := system/lib/arm/$(LOCAL_MODULE)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/arm
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := cpuinfo
LOCAL_SRC_FILES := system/lib/arm/$(LOCAL_MODULE)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/arm
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := cpuinfo.neon
LOCAL_SRC_FILES := system/lib/arm/$(LOCAL_MODULE)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/arm
include $(BUILD_PREBUILT)

# Houdini hook libraries for different module

include $(CLEAR_VARS)
LOCAL_MODULE := libhoudini_hook
LOCAL_SRC_FILES := hooks/libhoudini_hook.cpp
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_C_INCLUDES :=
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := houdini_hook
LOCAL_SRC_FILES := hooks/houdini_hook.c
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_C_INCLUDES :=
include $(BUILD_STATIC_LIBRARY)

endif
