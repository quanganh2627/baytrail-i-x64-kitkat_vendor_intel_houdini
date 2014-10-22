# Copyright (C) 20[14] Intel Corporation.  All rights reserved.
# Intel Confidential                                  RS-NDA # RS-8051151
# This [file/library] contains Houdini confidential information of Intel Corporation
# which is subject to a non-disclosure agreement between Intel Corporation
# and you or your company.

#Houdini prebuilt
HOUDINI_ARM_PREBUILTS_DIR := hardware/intel/houdini/arm
houdini_prebuilt_stamp := $(HOUDINI_ARM_PREBUILTS_DIR)/stamp-prebuilt-done
houdini_prebuilt_done := $(wildcard $(houdini_prebuilt_stamp))

ifneq ($(houdini_prebuilt_done),)
INTEL_HOUDINI := true
#Houdini
PRODUCT_PACKAGES += \
    houdini_hook \
    libhoudini_hook \
    check.knobs \

#houdini arm libraries

### Extra files needs to copy for houdini
HOUDINI_PATH := hardware/intel/houdini
#"Copying Houdini arm libs"
PRODUCT_COPY_FILES += \
    ${HOUDINI_PATH}/arm/linker:system/lib/arm/linker:intel_oblumg \
    ${HOUDINI_PATH}/arm/libandroidfw.so:system/lib/arm/libandroidfw.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libandroid_runtime.so:system/lib/arm/libandroid_runtime.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libandroid.so:system/lib/arm/libandroid.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libaudioutils.so:system/lib/arm/libaudioutils.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libbcc.so:system/lib/arm/libbcc.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libbcinfo.so:system/lib/arm/libbcinfo.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libbinder.so:system/lib/arm/libbinder.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libcamera_client.so:system/lib/arm/libcamera_client.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libcamera_metadata.so:system/lib/arm/libcamera_metadata.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libc_orig.so:system/lib/arm/libc_orig.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libconnectivitymanager.so:system/lib/arm/libconnectivitymanager.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libcorkscrew.so:system/lib/arm/libcorkscrew.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libcrypto.so:system/lib/arm/libcrypto.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libc.so:system/lib/arm/libc.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libcutils.so:system/lib/arm/libcutils.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libdl.so:system/lib/arm/libdl.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libdrmframework.so:system/lib/arm/libdrmframework.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libdvm.so:system/lib/arm/libdvm.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libEGL.so:system/lib/arm/libEGL.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libETC1.so:system/lib/arm/libETC1.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libexpat.so:system/lib/arm/libexpat.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libfilterfw.so:system/lib/arm/libfilterfw.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libfilterpack_imageproc.so:system/lib/arm/libfilterpack_imageproc.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libft2.so:system/lib/arm/libft2.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libgabi++.so:system/lib/arm/libgabi++.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libgccdemangle.so:system/lib/arm/libgccdemangle.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libGLESv1_CM.so:system/lib/arm/libGLESv1_CM.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libGLESv2.so:system/lib/arm/libGLESv2.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libgui.so:system/lib/arm/libgui.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libhardware_legacy.so:system/lib/arm/libhardware_legacy.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libhardware.so:system/lib/arm/libhardware.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libharfbuzz_ng.so:system/lib/arm/libharfbuzz_ng.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libharfbuzz.so:system/lib/arm/libharfbuzz.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libhwui.so:system/lib/arm/libhwui.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libicui18n.so:system/lib/arm/libicui18n.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libicuuc.so:system/lib/arm/libicuuc.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libinput.so:system/lib/arm/libinput.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libjnigraphics.so:system/lib/arm/libjnigraphics.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libjpeg.so:system/lib/arm/libjpeg.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libLLVM.so:system/lib/arm/libLLVM.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/liblog.so:system/lib/arm/liblog.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libmedia.so:system/lib/arm/libmedia.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libmemtrack.so:system/lib/arm/libmemtrack.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libm_orig.so:system/lib/arm/libm_orig.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libm.so:system/lib/arm/libm.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libnativehelper.so:system/lib/arm/libnativehelper.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libnetutils.so:system/lib/arm/libnetutils.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libnfc_ndef.so:system/lib/arm/libnfc_ndef.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libOpenMAXAL.so:system/lib/arm/libOpenMAXAL.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libOpenSLES.so:system/lib/arm/libOpenSLES.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libpixelflinger.so:system/lib/arm/libpixelflinger.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libpng.so:system/lib/arm/libpng.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libpowermanager.so:system/lib/arm/libpowermanager.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libRS.so:system/lib/arm/libRS.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libRScpp.so:system/lib/arm/libRScpp.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libRSDriver.so:system/lib/arm/libRSDriver.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libselinux.so:system/lib/arm/libselinux.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libskia.so:system/lib/arm/libskia.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libsonivox.so:system/lib/arm/libsonivox.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libspeexresampler.so:system/lib/arm/libspeexresampler.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libsqlite.so:system/lib/arm/libsqlite.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libssl.so:system/lib/arm/libssl.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libstagefright_foundation.so:system/lib/arm/libstagefright_foundation.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libstagefright_avc_common.so:system/lib/arm/libstagefright_avc_common.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libstagefright_enc_common.so:system/lib/arm/libstagefright_enc_common.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libstagefright_omx.so:system/lib/arm/libstagefright_omx.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libstagefright_yuv.so:system/lib/arm/libstagefright_yuv.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libstagefright.so:system/lib/arm/libstagefright.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libstdc++.so:system/lib/arm/libstdc++.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libstlport.so:system/lib/arm/libstlport.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libsurfaceflinger.so:system/lib/arm/libsurfaceflinger.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libsync.so:system/lib/arm/libsync.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libui.so:system/lib/arm/libui.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libusbhost.so:system/lib/arm/libusbhost.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libutils.so:system/lib/arm/libutils.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libvorbisidec.so:system/lib/arm/libvorbisidec.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libwebrtc_audio_coding.so:system/lib/arm/libwebrtc_audio_coding.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libwpa_client.so:system/lib/arm/libwpa_client.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libz.so:system/lib/arm/libz.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libaudioflinger.so:system/lib/arm/libaudioflinger.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libcommon_time_client.so:system/lib/arm/libcommon_time_client.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libeffects.so:system/lib/arm/libeffects.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libnbaio.so:system/lib/arm/libnbaio.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libvideoeditor_core.so:system/lib/arm/libvideoeditor_core.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libvideoeditor_jni.so:system/lib/arm/libvideoeditor_jni.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libvideoeditor_osal.so:system/lib/arm/libvideoeditor_osal.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libvideoeditorplayer.so:system/lib/arm/libvideoeditorplayer.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libvideoeditor_videofilters.so:system/lib/arm/libvideoeditor_videofilters.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libGLES_trace.so:system/lib/arm/libGLES_trace.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libRSCpuRef.so:system/lib/arm/libRSCpuRef.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libwilhelm.so:system/lib/arm/libwilhelm.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libz_orig.so:system/lib/arm/libz_orig.so:intel_oblumg \
    ${HOUDINI_PATH}/arm/libsysutils.so:system/lib/arm/libsysutils.so:intel_oblumg \


#"Copying Houdini executables"
PRODUCT_COPY_FILES += \
    ${HOUDINI_PATH}/system/bin/enable_houdini:system/bin/enable_houdini:intel_oblumg \
    ${HOUDINI_PATH}/system/bin/disable_houdini:system/bin/disable_houdini:intel_oblumg \

ifeq ($(TARGET_KERNEL_ARCH),x86_64)
PRODUCT_COPY_FILES += \
    ${HOUDINI_PATH}/system/bin/houdini_x64_32:system/bin/houdini:intel_oblumg \
    $(HOUDINI_PATH)/system/lib/libhoudini_x64_32.so:system/lib/libhoudini.so:intel_oblumg \

else
PRODUCT_COPY_FILES += \
    ${HOUDINI_PATH}/system/bin/houdini:system/bin/houdini:intel_oblumg \
    $(HOUDINI_PATH)/system/lib/libhoudini.so:system/lib/libhoudini.so:intel_oblumg \

endif

#"Copying Houdini misc files"
PRODUCT_COPY_FILES += \
    ${HOUDINI_PATH}/system/lib/arm/cpuinfo:system/lib/arm/cpuinfo:intel_oblumg \
    ${HOUDINI_PATH}/system/lib/arm/cpuinfo.neon:system/lib/arm/cpuinfo.neon:intel_oblumg \
    ${HOUDINI_PATH}/system/lib/arm/.assets_lib_list:system/lib/arm/.assets_lib_list:intel_oblumg \

#Set CPU ABI
ADDITIONAL_BUILD_PROPERTIES += ro.product.cpu.abi2=armeabi-v7a

#memory layout
ADDITIONAL_BUILD_PROPERTIES += ro.config.personality=compat_layout
endif
