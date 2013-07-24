#!/bin/bash

TOP=`pwd`
HOUDINI_PATH=$1
HOUDINI_VERSION=`strings ${HOUDINI_PATH}/system/lib/libhoudini.so | grep version: | awk '{print $2}'`
PRODUCT_OUT=${TOP}/$2

mkdir -p ${PRODUCT_OUT}/obj/SHARED_LIBRARIES/libhoudini_intermediates/LINKED/
mkdir -p ${PRODUCT_OUT}/symbols/system/lib/
mkdir -p ${PRODUCT_OUT}/system/lib/

### Copy libhoudini with version
echo "Copying libhoudini"
cp -f ${HOUDINI_PATH}/system/lib/libhoudini.so ${PRODUCT_OUT}/obj/SHARED_LIBRARIES/libhoudini_intermediates/LINKED/libhoudini.so.${HOUDINI_VERSION}
cp -f ${HOUDINI_PATH}/system/lib/libhoudini.so ${PRODUCT_OUT}/symbols/system/lib/libhoudini.so.${HOUDINI_VERSION}
cp -f ${HOUDINI_PATH}/system/lib/libhoudini.so ${PRODUCT_OUT}/system/lib/libhoudini.so.${HOUDINI_VERSION}

### Create soft link for the libhoudini.so
cd ${PRODUCT_OUT}/obj/SHARED_LIBRARIES/libhoudini_intermediates/LINKED
ln -sf libhoudini.so.${HOUDINI_VERSION} libhoudini.so
cd ${PRODUCT_OUT}/symbols/system/lib/
ln -sf libhoudini.so.${HOUDINI_VERSION} libhoudini.so
cd ${PRODUCT_OUT}/system/lib
ln -sf libhoudini.so.${HOUDINI_VERSION} libhoudini.so

### Extra files needs to copy for houdini
cd $TOP
