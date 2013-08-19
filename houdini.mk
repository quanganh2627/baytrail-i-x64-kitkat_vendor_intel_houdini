# Use inherit-product-if-exists on this file to enable the conditional
# inclusion into the build everywhere.

INTEL_HOUDINI := true
ADDITIONAL_BUILD_PROPERTIES += \
		ro.product.cpu.abi2=armeabi-v7a \
		ro.config.personality=compat_layout \
		ro.kernel.android.checkjni=0 \

HOUDINI_ARM_PREBUILTS_DIR := vendor/intel/PRIVATE/houdini-armlibs

PRODUCT_PACKAGES += \
	libhoudini \
	houdini \
	enable_houdini \
	disable_houdini \
	check.xml \
	cpuinfo \
	cpuinfo.neon \

# end of file
