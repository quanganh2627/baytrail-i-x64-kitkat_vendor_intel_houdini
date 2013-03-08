#
# file: vendor/intel/PREBUILT/SG/src/Android.mk

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := pams.c

LOCAL_CFLAGS :=

LOCAL_MODULE := pams

LOCAL_MODULE_TAGS := optional

include $(BUILD_HOST_EXECUTABLE)

