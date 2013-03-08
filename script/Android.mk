# file: vendor/intel/PREBUILT/SG/script/Android.mk

LOCAL_PATH:=$(call my-dir)

include $(CLEAR_VARS)

PAMS_CMD := $(HOST_OUT_EXECUTABLES)/pams

$(HOST_OUT_EXECUTABLES)/run_pams : $(LOCAL_PATH)/run_pams $(PAMS_CMD) | $(ACP)
	$(hide) $(ACP) -fpt $< $@
