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
prebuilt_path := $(LOCAL_PATH)/../../../$(HOUDINI_ARM_PREBUILTS_DIR)
syml_path := $(LOCAL_PATH)/libs_sym
filter_path := $(syml_path)/filter
glue_path := $(LOCAL_PATH)/libs_glue
stamp_prebuilt_done := $(prebuilt_path)/stamp-prebuilt-done
pfb := pfb
pst := pst


PAMS := $(HOST_OUT_EXECUTABLES)/run_pams

LIBS_PAM := libc.so libm.so

LIBS_MAP := libandroid.so \
			libdl.so \
			libEGL.so \
			libGLESv1_CM.so \
			libGLESv2.so \
			libjnigraphics.so \
			libOpenMAXAL.so \
			libOpenSLES.so

LIBS_TRL := liblog.so \
			libstdc++.so \
			libz.so \
			libandroid_runtime.so \
			libbinder.so \
			libcamera_client.so \
			libcrypto.so \
			libcutils.so \
			libdrmframework.so \
			libemoji.so \
			libgabi++.so \
			libgui.so \
			libhwui.so \
			libicui18n.so \
			libicuuc.so \
			libmedia.so \
			libnativehelper.so \
			libpixelflinger.so \
			libskia.so \
			libsqlite.so \
			libssl.so \
			libstagefright.so \
			libstagefright_foundation.so \
			libsurfaceflinger.so \
			libui.so \
			libutils.so \
			libvorbisidec.so \
			linker

LIBS_PCH := libandroidfw.so \
			libaudioutils.so \
			libcorkscrew.so \
			libdvm.so \
			libETC1.so \
			libexpat.so \
			libfilterfw.so \
			libfilterpack_imageproc.so \
			libgccdemangle.so \
			libhardware.so \
			libhardware_legacy.so \
			libharfbuzz.so \
			libjpeg.so \
			libmedia_native.so \
			libnetutils.so \
			libnfc_ndef.so \
			libsonivox.so \
			libspeexresampler.so \
			libstlport.so \
			libsync.so \
			libusbhost.so \
			libwpa_client.so

define transform-syml-to-lib
PROD_ARM_LIBS += $(4)
$(4): $(1) $(2) $(3) | $(PAMS)
	@echo "SYM to LIB: $(3) -> $$@"
	@mkdir -p $(dir $(4))
	@$(PAMS) $(pfb) $$^ $(product_path)/arm $(HOST_PREBUILT_TAG)
endef

# Do not call copy-one-file, we need better control here.
define transform-glue-to-lib
PROD_ARM_LIBS += $(2)
$(2): $(1) | $(ACP)
	@echo "GLUE to LIB: $(1) -> $(2)"
	$$(transform-prebuilt-to-target)
endef

define transform-preb-to-lib
PROD_ARM_LIBS += $(2)
$(2): $(1) | $(ACP)
	@echo "PREB to LIB: $(1) -> $(2)"
	$$(transform-prebuilt-to-target)
endef

define patch-symtab-to-lib
PROD_ARM_LIBS += $(3)
$(3): $(1) $(2) | $(PAMS)
	@echo "Patch lib: $(1) -> $(3)"
	@mkdir -p $(dir $(3))
	$(PAMS) $(pst) $$^ $(product_path)/arm $(HOST_PREBUILT_TAG)
endef

arm_prebuilt_done := $(wildcard $(stamp_prebuilt_done))

$(if $(arm_prebuilt_done), \
  $(foreach lib, $(LIBS_PCH), \
	$(eval _libn := $(basename $(lib))) \
	$(eval _lib := $(prebuilt_path)/$(_libn).so) \
	$(eval _dest := $(product_path)/arm/$(_libn).so) \
	$(eval _filter := $(filter_path)/$(_libn).sym) \
	$(eval $(call patch-symtab-to-lib,$(_lib),$(_filter),$(_dest))) \
  ) \
  $(foreach lib, $(LIBS_PAM), \
	$(eval _libn := $(basename $(lib))) \
	$(eval _dest := $(product_path)/arm/$(_libn).so) \
	$(eval _orig := $(product_path)/arm/$(_libn)_orig.so) \
	$(eval _preb := $(prebuilt_path)/$(_libn).so) \
	$(eval _glue := $(glue_path)/$(_libn)_glue.so) \
	$(eval _syml := $(syml_path)/$(_libn).sym) \
	$(eval $(call transform-syml-to-lib,$(_preb),$(_glue),$(_syml),$(_dest))) \
	$(eval $(call transform-preb-to-lib,$(_preb),$(_orig))) \
   ) \
  $(foreach lib, $(LIBS_MAP), \
	$(eval _libn := $(basename $(lib))) \
	$(eval _dest := $(product_path)/arm/$(_libn).so) \
	$(eval _glue := $(glue_path)/$(_libn)_glue.so) \
	$(eval $(call transform-glue-to-lib,$(_glue),$(_dest))) \
   ) \
  $(foreach lib, $(LIBS_TRL), \
	$(eval _dest := $(product_path)/arm/$(lib)) \
	$(eval _preb := $(prebuilt_path)/$(lib)) \
	$(eval $(call transform-preb-to-lib,$(_preb),$(_dest))) \
   ), \
)


# Build ARM product libraries

$(TARGET_OUT)/bin/houdini: $(stamp_prebuilt_done)

# Houdini prebuilt binaries

include $(CLEAR_VARS)
LOCAL_MODULE := libhoudini
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := $(TARGET_SHLIB_SUFFIX)

OVERRIDE_BUILT_MODULE_PATH := $(TARGET_OUT_INTERMEDIATE_LIBRARIES)
include $(BUILD_SYSTEM)/dynamic_binary.mk
$(linked_module): $(stamp_prebuilt_done) $(PROD_ARM_LIBS)
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

# Build tool utilities

include $(CLEAR_VARS)

subdirs := $(addprefix $(LOCAL_PATH)/, \
			 $(addsuffix /Android.mk, \
			   src \
			   script \
			  ))

ifeq ($(TARGET_ARCH),x86)
include $(subdirs)
endif
endif
