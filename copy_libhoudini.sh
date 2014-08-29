#!/bin/bash

TOP=`pwd`
HOUDINI_PATH=$1
HOUDINI_VERSION=`strings ${HOUDINI_PATH}/system/lib/libhoudini.so | grep version: | awk '{print $2}'`
PRODUCT_OUT=${TOP}/$2
HOUDINI_X64_32=$3
echo "HOUDINI_X64_32 ${HOUDINI_X64_32}"

mkdir -p ${PRODUCT_OUT}/obj/SHARED_LIBRARIES/libhoudini_intermediates/LINKED/
mkdir -p ${PRODUCT_OUT}/symbols/system/lib/
mkdir -p ${PRODUCT_OUT}/system/lib/

### Copy libhoudini with version
echo "Copying libhoudini"
if [[ "$HOUDINI_X64_32" = "true" ]]
then
    echo "Copying libhoudini x64_32"
    HOUDINI_VERSION=`strings ${HOUDINI_PATH}/system/lib/libhoudini_x64_32.so | grep version: | awk '{print $2}'`
### copy libhoudini x64_32 
    cp -f --remove-destination ${HOUDINI_PATH}/system/lib/libhoudini_x64_32.so ${PRODUCT_OUT}/obj/SHARED_LIBRARIES/libhoudini_intermediates/LINKED/libhoudini.so.${HOUDINI_VERSION}
    cp -f --remove-destination ${HOUDINI_PATH}/system/lib/libhoudini_x64_32.so ${PRODUCT_OUT}/symbols/system/lib/libhoudini.so.${HOUDINI_VERSION}
    cp -f --remove-destination ${HOUDINI_PATH}/system/lib/libhoudini_x64_32.so ${PRODUCT_OUT}/system/lib/libhoudini.so.${HOUDINI_VERSION}
else
    echo "Copying libhoudini x86"
### copy libhoudini X86
    HOUDINI_VERSION=`strings ${HOUDINI_PATH}/system/lib/libhoudini.so | grep version: | awk '{print $2}'`
    cp -f --remove-destination ${HOUDINI_PATH}/system/lib/libhoudini.so ${PRODUCT_OUT}/obj/SHARED_LIBRARIES/libhoudini_intermediates/LINKED/libhoudini.so.${HOUDINI_VERSION}
    cp -f --remove-destination ${HOUDINI_PATH}/system/lib/libhoudini.so ${PRODUCT_OUT}/symbols/system/lib/libhoudini.so.${HOUDINI_VERSION}
    cp -f --remove-destination ${HOUDINI_PATH}/system/lib/libhoudini.so ${PRODUCT_OUT}/system/lib/libhoudini.so.${HOUDINI_VERSION}
fi
### Create soft link for the libhoudini.so
cd ${PRODUCT_OUT}/obj/SHARED_LIBRARIES/libhoudini_intermediates/LINKED
ln -sf libhoudini.so.${HOUDINI_VERSION} libhoudini.so
cd ${PRODUCT_OUT}/symbols/system/lib/
ln -sf libhoudini.so.${HOUDINI_VERSION} libhoudini.so
cd ${PRODUCT_OUT}/system/lib
ln -sf libhoudini.so.${HOUDINI_VERSION} libhoudini.so

### Extra files needs to copy for houdini
cd $TOP
echo "Copying Houdini executables"
mkdir -p ${PRODUCT_OUT}/system/bin/
if [[ "$HOUDINI_X64_32" = "true" ]]
then
###copy houdini_x64_32
    echo "Copying houdini x64_32"
    cp -f --remove-destination ${HOUDINI_PATH}/system/bin/houdini_x64_32 ${PRODUCT_OUT}/system/bin/houdini
else
###copy houdini_x86
    echo "Copying houdini x86"
    cp -f --remove-destination ${HOUDINI_PATH}/system/bin/houdini ${PRODUCT_OUT}/system/bin/houdini
fi
cp -f --remove-destination ${HOUDINI_PATH}/system/bin/enable_houdini ${PRODUCT_OUT}/system/bin/
cp -f --remove-destination ${HOUDINI_PATH}/system/bin/disable_houdini ${PRODUCT_OUT}/system/bin/

echo "Copying Houdini arm libs"
mkdir -p ${PRODUCT_OUT}/system/lib/arm/
cp -f --remove-destination ${HOUDINI_PATH}/arm/*.so ${PRODUCT_OUT}/system/lib/arm/
cp -f --remove-destination ${HOUDINI_PATH}/arm/linker ${PRODUCT_OUT}/system/lib/arm/

echo "Copying Houdini misc files"
cp -f --remove-destination ${HOUDINI_PATH}/system/lib/arm/check.xml ${PRODUCT_OUT}/system/lib/arm/
cp -f --remove-destination ${HOUDINI_PATH}/system/lib/arm/.assets_lib_list ${PRODUCT_OUT}/system/lib/arm/
cp -f --remove-destination ${HOUDINI_PATH}/system/lib/arm/cpuinfo ${PRODUCT_OUT}/system/lib/arm/
cp -f --remove-destination ${HOUDINI_PATH}/system/lib/arm/cpuinfo.neon ${PRODUCT_OUT}/system/lib/arm/
