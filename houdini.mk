### Extra files needs to copy for houdini
HOUDINI_PATH := vendor/intel/houdini
#"Copying Houdini arm libs"
PRODUCT_COPY_FILES += \
    ${HOUDINI_PATH}/arm/linker:system/lib/arm/linker \
    ${HOUDINI_PATH}/arm/libandroidfw.so:system/lib/arm/libandroidfw.so \
    ${HOUDINI_PATH}/arm/libandroid_runtime.so:system/lib/arm/libandroid_runtime.so \
    ${HOUDINI_PATH}/arm/libandroid.so:system/lib/arm/libandroid.so \
    ${HOUDINI_PATH}/arm/libaudioutils.so:system/lib/arm/libaudioutils.so \
    ${HOUDINI_PATH}/arm/libbcc.so:system/lib/arm/libbcc.so \
    ${HOUDINI_PATH}/arm/libbcinfo.so:system/lib/arm/libbcinfo.so \
    ${HOUDINI_PATH}/arm/libbinder.so:system/lib/arm/libbinder.so \
    ${HOUDINI_PATH}/arm/libcamera_client.so:system/lib/arm/libcamera_client.so \
    ${HOUDINI_PATH}/arm/libcamera_metadata.so:system/lib/arm/libcamera_metadata.so \
    ${HOUDINI_PATH}/arm/libc_orig.so:system/lib/arm/libc_orig.so \
    ${HOUDINI_PATH}/arm/libconnectivitymanager.so:system/lib/arm/libconnectivitymanager.so \
    ${HOUDINI_PATH}/arm/libcorkscrew.so:system/lib/arm/libcorkscrew.so \
    ${HOUDINI_PATH}/arm/libcrypto.so:system/lib/arm/libcrypto.so \
    ${HOUDINI_PATH}/arm/libc.so:system/lib/arm/libc.so \
    ${HOUDINI_PATH}/arm/libcutils.so:system/lib/arm/libcutils.so \
    ${HOUDINI_PATH}/arm/libdl.so:system/lib/arm/libdl.so \
    ${HOUDINI_PATH}/arm/libdrmframework.so:system/lib/arm/libdrmframework.so \
    ${HOUDINI_PATH}/arm/libdvm.so:system/lib/arm/libdvm.so \
    ${HOUDINI_PATH}/arm/libEGL.so:system/lib/arm/libEGL.so \
    ${HOUDINI_PATH}/arm/libETC1.so:system/lib/arm/libETC1.so \
    ${HOUDINI_PATH}/arm/libexpat.so:system/lib/arm/libexpat.so \
    ${HOUDINI_PATH}/arm/libfilterfw.so:system/lib/arm/libfilterfw.so \
    ${HOUDINI_PATH}/arm/libfilterpack_imageproc.so:system/lib/arm/libfilterpack_imageproc.so \
    ${HOUDINI_PATH}/arm/libft2.so:system/lib/arm/libft2.so \
    ${HOUDINI_PATH}/arm/libgabi++.so:system/lib/arm/libgabi++.so \
    ${HOUDINI_PATH}/arm/libgccdemangle.so:system/lib/arm/libgccdemangle.so \
    ${HOUDINI_PATH}/arm/libGLESv1_CM.so:system/lib/arm/libGLESv1_CM.so \
    ${HOUDINI_PATH}/arm/libGLESv2.so:system/lib/arm/libGLESv2.so \
    ${HOUDINI_PATH}/arm/libgui.so:system/lib/arm/libgui.so \
    ${HOUDINI_PATH}/arm/libhardware_legacy.so:system/lib/arm/libhardware_legacy.so \
    ${HOUDINI_PATH}/arm/libhardware.so:system/lib/arm/libhardware.so \
    ${HOUDINI_PATH}/arm/libharfbuzz_ng.so:system/lib/arm/libharfbuzz_ng.so \
    ${HOUDINI_PATH}/arm/libhwui.so:system/lib/arm/libhwui.so \
    ${HOUDINI_PATH}/arm/libicui18n.so:system/lib/arm/libicui18n.so \
    ${HOUDINI_PATH}/arm/libicuuc.so:system/lib/arm/libicuuc.so \
    ${HOUDINI_PATH}/arm/libinput.so:system/lib/arm/libinput.so \
    ${HOUDINI_PATH}/arm/libjnigraphics.so:system/lib/arm/libjnigraphics.so \
    ${HOUDINI_PATH}/arm/libjpeg.so:system/lib/arm/libjpeg.so \
    ${HOUDINI_PATH}/arm/libLLVM.so:system/lib/arm/libLLVM.so \
    ${HOUDINI_PATH}/arm/liblog.so:system/lib/arm/liblog.so \
    ${HOUDINI_PATH}/arm/libmedia.so:system/lib/arm/libmedia.so \
    ${HOUDINI_PATH}/arm/libmemtrack.so:system/lib/arm/libmemtrack.so \
    ${HOUDINI_PATH}/arm/libm_orig.so:system/lib/arm/libm_orig.so \
    ${HOUDINI_PATH}/arm/libm.so:system/lib/arm/libm.so \
    ${HOUDINI_PATH}/arm/libnativehelper.so:system/lib/arm/libnativehelper.so \
    ${HOUDINI_PATH}/arm/libnetutils.so:system/lib/arm/libnetutils.so \
    ${HOUDINI_PATH}/arm/libnfc_ndef.so:system/lib/arm/libnfc_ndef.so \
    ${HOUDINI_PATH}/arm/libOpenMAXAL.so:system/lib/arm/libOpenMAXAL.so \
    ${HOUDINI_PATH}/arm/libOpenSLES.so:system/lib/arm/libOpenSLES.so \
    ${HOUDINI_PATH}/arm/libpixelflinger.so:system/lib/arm/libpixelflinger.so \
    ${HOUDINI_PATH}/arm/libpng.so:system/lib/arm/libpng.so \
    ${HOUDINI_PATH}/arm/libpowermanager.so:system/lib/arm/libpowermanager.so \
    ${HOUDINI_PATH}/arm/libRS.so:system/lib/arm/libRS.so \
    ${HOUDINI_PATH}/arm/libRScpp.so:system/lib/arm/libRScpp.so \
    ${HOUDINI_PATH}/arm/libselinux.so:system/lib/arm/libselinux.so \
    ${HOUDINI_PATH}/arm/libskia.so:system/lib/arm/libskia.so \
    ${HOUDINI_PATH}/arm/libsonivox.so:system/lib/arm/libsonivox.so \
    ${HOUDINI_PATH}/arm/libspeexresampler.so:system/lib/arm/libspeexresampler.so \
    ${HOUDINI_PATH}/arm/libsqlite.so:system/lib/arm/libsqlite.so \
    ${HOUDINI_PATH}/arm/libssl.so:system/lib/arm/libssl.so \
    ${HOUDINI_PATH}/arm/libstagefright_foundation.so:system/lib/arm/libstagefright_foundation.so \
    ${HOUDINI_PATH}/arm/libstagefright_avc_common.so:system/lib/arm/libstagefright_avc_common.so \
    ${HOUDINI_PATH}/arm/libstagefright_enc_common.so:system/lib/arm/libstagefright_enc_common.so \
    ${HOUDINI_PATH}/arm/libstagefright_omx.so:system/lib/arm/libstagefright_omx.so \
    ${HOUDINI_PATH}/arm/libstagefright_yuv.so:system/lib/arm/libstagefright_yuv.so \
    ${HOUDINI_PATH}/arm/libstagefright.so:system/lib/arm/libstagefright.so \
    ${HOUDINI_PATH}/arm/libstdc++.so:system/lib/arm/libstdc++.so \
    ${HOUDINI_PATH}/arm/libstlport.so:system/lib/arm/libstlport.so \
    ${HOUDINI_PATH}/arm/libsurfaceflinger.so:system/lib/arm/libsurfaceflinger.so \
    ${HOUDINI_PATH}/arm/libsync.so:system/lib/arm/libsync.so \
    ${HOUDINI_PATH}/arm/libui.so:system/lib/arm/libui.so \
    ${HOUDINI_PATH}/arm/libusbhost.so:system/lib/arm/libusbhost.so \
    ${HOUDINI_PATH}/arm/libutils.so:system/lib/arm/libutils.so \
    ${HOUDINI_PATH}/arm/libvorbisidec.so:system/lib/arm/libvorbisidec.so \
    ${HOUDINI_PATH}/arm/libwpa_client.so:system/lib/arm/libwpa_client.so \
    ${HOUDINI_PATH}/arm/libz.so:system/lib/arm/libz.so \

#"Copying Houdini executables"
PRODUCT_COPY_FILES += \
    ${HOUDINI_PATH}/system/bin/houdini:system/bin/houdini \
    ${HOUDINI_PATH}/system/bin/enable_houdini:system/bin/enable_houdini \
    ${HOUDINI_PATH}/system/bin/disable_houdini:system/bin/disable_houdini \

#"Copying Houdini misc files"
PRODUCT_COPY_FILES += \
    ${HOUDINI_PATH}/system/lib/arm/cpuinfo:system/lib/arm/cpuinfo \
    ${HOUDINI_PATH}/system/lib/arm/cpuinfo.neon:system/lib/arm/cpuinfo.neon \
