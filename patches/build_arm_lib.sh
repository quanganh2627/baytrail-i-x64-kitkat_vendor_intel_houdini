#!/bin/bash
#
# Script to build prebuilt ARM libraries with pathces on Linux.
#
# This script does not download the ARM Android source code.
# Please go Android official website to download Android 
# source first:
#
#   http://source.android.com/source/downloading.html
#
# Before running this script, please set the global paths
# arm_android_src_root and x86_android_src_root.
#
# --
#
# XXX: This script will discard all local changes to ARM Android
# code in <arm_android_src_root>. Please ensure you are working 
# on a clean Android source.
#

usage() {
    echo "Script to build prebuilt ARM libraries with pathces on Linux"
    echo
    echo "Usage:"
    echo "    ./build_arm_lib.sh"
    echo "    ./build_arm_lib.sh /path/to/google/AOSP/src/root /path/to/x86/android/src/root"
    echo
}

if [ $# -eq 2 ]; then
    arm_android_src_root=$1
    x86_android_src_root=$2
else
    # Set global paths. TODO: Change them first.
    arm_android_src_root=/path/to/google/AOSP/src/root
    x86_android_src_root=/path/to/x86/android/src/root
fi

# Validate paths
if [ ! -d $arm_android_src_root ] || [ ! -d $x86_android_src_root ]; then
    usage
    echo "    Please set arm_android_src_root and x86_android_src_root variables"
    echo 
    exit -1
fi

# Checkout the tag version android-4.2.2_r1:
pushd $arm_android_src_root
for p in `repo list | awk '{ print $1 }'`; do
    cd $p ; git checkout android-4.2.2_r1 ; cd -
done

# Applying patches:
# (Discard local changes if there are)
if [ -d $x86_android_src_root/vendor/intel/houdini ]; then
    prefix=$x86_android_src_root/vendor/intel/houdini/patches
fi
cd bionic && git checkout . && git apply $prefix/0001-bionic-build.patch && cd -
cd build && git checkout . && git apply $prefix/0001-build-tls-no-thumb.patch && cd -
cd dalvik && git checkout . && git apply $prefix/0001-dalvik-fpic-fix.patch && cd -
cd external/openssl && git checkout . && git apply $prefix/0001-external-openssl-fpic-fix.patch && cd -
cd external/tremolo && git checkout . && git apply $prefix/0001-external-tremolo-fpic-fix.patch && cd -
cd prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.6/ && git checkout .
cp arm-linux-androideabi/bin/ld.bfd arm-linux-androideabi/bin/ld
cp bin/arm-linux-androideabi-ld.bfd bin/arm-linux-androideabi-ld
cd -

if [ "$?" != "0" ]; then
    echo "Patch failure!"
    exit -1
fi

# Build ARM libraries:
# Only part of ARM Android libraries are required
source ./build/envsetup.sh
lunch generic-eng
make clean
make -j4 libETC1 \
         libandroidfw \
         libandroid_runtime \
         libaudioutils \
         libbinder \
         libc \
         libcamera_client \
         libcorkscrew \
         libcrypto \
         libcutils \
 libdbus \
         libdl \
         libdrmframework \
         libdvm \
         libemoji \
         libexpat \
         libfilterfw \
         libfilterpack_imageproc \
         libgabi++ \
         libgccdemangle \
         libgui \
         libhardware \
         libhardware_legacy \
         libharfbuzz \
         libhwui \
         libicui18n \
         libicuuc \
         libjpeg \
         liblog \
         libm \
         libmedia \
         libmedia_native \
         libnativehelper \
         libnetutils \
         libnfc_ndef \
         libpixelflinger \
         libskia \
         libsonivox \
         libspeexresampler \
         libsqlite \
         libssl \
         libstagefright \
         libstagefright_foundation \
         libstdc++ \
         libstlport \
         libsurfaceflinger \
         libsync \
         libui \
         libusbhost \
         libutils \
         libvorbisidec \
         libwpa_client \
         libz \
         linker


if [ "$?" != "0" ]; then
    echo "Build failure. Exit"
    exit -1
fi

# Copy the generated ARM libraries to HOUDINI_ARM_PREBUILTS_DIR
#
# HOUDINI_ARM_PREBUILTS_DIR should be defined in COMMON_MK
# if not defined, then exit
COMMON_MK=device/intel/common/common.mk
HOUDINI_ARM_PREBUILTS_DIR=`cat $x86_android_src_root/$COMMON_MK | grep "HOUDINI_ARM_PREBUILTS_DIR :=" | awk '{print $3}'`
if [ "x$HOUDINI_ARM_PREBUILTS_DIR" = "x" ]; then
    echo "HOUDINI_ARM_PREBUILTS_DIR not defined in $COMMON_MK. Exit"
    exit -2
fi

src_dir=$arm_android_src_root/out/target/product/generic/system
dst_dir=$x86_android_src_root/$HOUDINI_ARM_PREBUILTS_DIR
systemstub=$x86_android_src_root/vendor/intel/PRIVATE/systemstub

if [ -d $systemstub ]; then
    rm -rf $systemstub
fi

if [ ! -d $dst_dir ]; then
    mkdir -p $dst_dir
fi

cp -f \
       $src_dir/lib/libETC1.so \
       $src_dir/lib/libandroidfw.so \
       $src_dir/lib/libandroid_runtime.so \
       $src_dir/lib/libaudioutils.so \
       $src_dir/lib/libbinder.so \
       $src_dir/lib/libc.so \
       $src_dir/lib/libcamera_client.so \
       $src_dir/lib/libcorkscrew.so \
       $src_dir/lib/libcrypto.so \
       $src_dir/lib/libcutils.so \
 $src_dir/lib/libdbus.so \
       $src_dir/lib/libdl.so \
       $src_dir/lib/libdrmframework.so \
       $src_dir/lib/libdvm.so \
       $src_dir/lib/libemoji.so \
       $src_dir/lib/libexpat.so \
       $src_dir/lib/libfilterfw.so \
       $src_dir/lib/libfilterpack_imageproc.so \
       $src_dir/lib/libgabi++.so \
       $src_dir/lib/libgccdemangle.so \
       $src_dir/lib/libgui.so \
       $src_dir/lib/libhardware.so \
       $src_dir/lib/libhardware_legacy.so \
       $src_dir/lib/libharfbuzz.so \
       $src_dir/lib/libhwui.so \
       $src_dir/lib/libicui18n.so \
       $src_dir/lib/libicuuc.so \
       $src_dir/lib/libjpeg.so \
       $src_dir/lib/liblog.so \
       $src_dir/lib/libm.so \
       $src_dir/lib/libmedia.so \
       $src_dir/lib/libmedia_native.so \
       $src_dir/lib/libnativehelper.so \
       $src_dir/lib/libnetutils.so \
       $src_dir/lib/libnfc_ndef.so \
       $src_dir/lib/libpixelflinger.so \
       $src_dir/lib/libskia.so \
       $src_dir/lib/libsonivox.so \
       $src_dir/lib/libspeexresampler.so \
       $src_dir/lib/libsqlite.so \
       $src_dir/lib/libssl.so \
       $src_dir/lib/libstagefright.so \
       $src_dir/lib/libstagefright_foundation.so \
       $src_dir/lib/libstdc++.so \
       $src_dir/lib/libstlport.so \
       $src_dir/lib/libsurfaceflinger.so \
       $src_dir/lib/libsync.so \
       $src_dir/lib/libui.so \
       $src_dir/lib/libusbhost.so \
       $src_dir/lib/libutils.so \
       $src_dir/lib/libvorbisidec.so \
       $src_dir/lib/libwpa_client.so \
       $src_dir/lib/libz.so \
       $src_dir/bin/linker \
       $dst_dir


if [ "$?" != "0" ]; then
    echo "Copy failure Exit"
    exit -1
fi

touch $dst_dir/stamp-prebuilt-done

popd
