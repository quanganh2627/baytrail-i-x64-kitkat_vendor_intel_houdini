#!/bin/bash

# ----------------------------------------------------------------------------------------
#
#   INTEL CONFIDENTIAL
#   Copyright (2012) Intel Corporation All Rights Reserved.
#
#   The source code contained or described herein and all documents related to the
#   source code ("Material") are owned by Intel Corporation or its suppliers or
#   licensors. Title to the Material remains with Intel Corporation or its suppliers
#   and licensors. The Material is protected by worldwide copyright and trade secret
#   laws and treaty provisions. No part of the Material may be used, copied, reproduced,
#   modified, published, uploaded, posted, transmitted, distributed, or disclosed in any
#   way without prior express written permission from Intel.
#
#   No license under any patent, copyright, trade secret or other intellectual property
#   right is granted to or conferred upon you by disclosure or delivery of the Materials,
#   either expressly, by implication, inducement, estoppel or otherwise. Any license under
#   such intellectual property rights must be express and approved by Intel in writing.
#
# ----------------------------------------------------------------------------------------

ADB=adb
if  type fromdos > /dev/null;then
DOS2UNIX=fromdos
else
DOS2UNIX=dos2unix
fi


houdini_bin=/system/bin/houdini
houdini_lib=/system/lib/libhoudini.so
houdini_binfmt=/proc/sys/fs/binfmt_misc/arm
cpuinfo_string=/system/lib/arm/cpuinfo
neon_cpuinfo_string=/system/lib/arm/cpuinfo.neon

check_exist()
{
    string=$1;
    file=$2;

    printf "Checking %-60s\t... " "$string"
    ret=`$ADB shell "if [ -e $file ]; then echo 0; else echo 1; fi" | $DOS2UNIX`;
    if [ 0 -eq $ret ]; then
        printf "\033[32mEXSIT!\033[0m\t\n";
    else
        printf "\033[31mMISSING!\033[0m\t\n";
    fi
}

process_hint()
{
    printf "."
    sleep $1
}

check_result()
{
    index=$1;
    string=$2;
    printf "Testing %-60s\t... " "$string"
    diff result/cpuinfo$index.txt cpuinfo.txt > result/cpuinfo$index.diff.log
    if [[ $? -ne 0 ]]
    then
        printf "\033[31mFAIL!\033[0m\t\n"
    else
        printf "\033[32mPASS!\033[0m\t\n"
    fi
}

check_file_result()
{
    index=$1;
    string=$2;
    file=$3
    printf "Testing %-60s\t... " "$string"
    cat result/$file | grep PASS >& /dev/null 
    if [[ $? -ne 0 ]]
    then
        printf "\033[31mFAIL!\033[0m\t\n"
    else
        printf "\033[32mPASS!\033[0m\t\n"
    fi
}


echo_usage1()
{
    echo
    echo "Please input correct platform you want to check:"
    echo "./check_houdini.sh ics  -- Houdini Sanity Check for ICS phone"
    echo "./check_houdini.sh jb41 -- Houdini Sanity Check for JellyBean 4.1 phone"
    echo "./check_houdini.sh jb42 -- Houdini Sanity Check for JellyBean 4.2 phone"
    echo
    exit
}

echo_usage2()
{
    echo
    echo "Please make sure you have only one device attached!"
    echo
    exit
}

if [[ $1 != "ics" && $1 != "jb41" && $1 != "jb42" ]]
then
    echo_usage1
fi

# Check device connection
$ADB root >& /dev/null && sleep 2
if [ $? -ne 0 ]
then
    echo_usage2
fi

check_exist "houdini binary" $houdini_bin
check_exist "houdini library" $houdini_lib
check_exist "Enable for executable" $houdini_binfmt
check_exist "Enable for cpuinfo" $cpuinfo_string

if [[ $1 != "ics" ]]
then
check_exist "Enable for neon cpuinfo" $neon_cpuinfo_string
fi

while read line
do
    check_exist "ARM library $line" $line
done < arm_libs_$1.txt

# Test Houdini hooks in framework and emulated ARM cpuinfo
APK1=cpuinfo.apk
APK2=cpuinfo-native.apk
APK3=checkLibraryPath.apk
ELF=cpuinfo.elf

PACKAGE1=com.intel.ubt.cpuinfo
PACKAGE2=com.intel.ubt.cpuinfo
PACKAGE3=com.intel.checklibrarypath
COM1=com.intel.ubt.cpuinfo/.CpuinfoActivity
COM2=com.intel.ubt.cpuinfo/android.app.NativeActivity
COM3=com.intel.checklibrarypath/.MainActivity
ACTION=android.intent.action.MAIN

TESTDIR=/data/cpuinfo/

printf "Running Sanity Check for Houdini"

###############################################
#Prepare test envrionment
rm -rf result >& /dev/null
mkdir -p result

$ADB remount >& /dev/null && process_hint 3

$ADB shell rm -r $TESTDIR >& /dev/null
$ADB shell mkdir $TESTDIR >& /dev/null
$ADB shell chmod 777 $TESTDIR >& /dev/null

###############################################
$ADB logcat -c

$ADB uninstall $PACKAGE1 >& /dev/null && process_hint 0
$ADB install -r $APK1 >& /dev/null && process_hint 0

$ADB shell am start -a $ACTION -n $COM1 >& /dev/null && process_hint 3
$ADB logcat -d > result/logcat1.log

###############################################
$ADB logcat -c
 
$ADB uninstall $PACKAGE2 >& /dev/null && process_hint 0
$ADB install -r $APK2 >& /dev/null && process_hint 0

$ADB shell am start -a $ACTION -n $COM2 >& /dev/null && process_hint 3
$ADB logcat -d > result/logcat2.log

###############################################
$ADB logcat -c
 
$ADB push $ELF $TESTDIR >& /dev/null && process_hint 0

$ADB shell chmod 777 $TESTDIR/$ELF >& /dev/null && process_hint 0
$ADB shell "su system $TESTDIR/$ELF > $TESTDIR/cpuinfo5.txt" >& /dev/null && process_hint 3
$ADB logcat -d > result/logcat3.log

###############################################
$ADB logcat -c
 
$ADB uninstall $PACKAGE3 >& /dev/null && process_hint 0
$ADB install -r $APK3 >& /dev/null && process_hint 0

$ADB shell am start -a $ACTION -n $COM3 >& /dev/null && process_hint 3
$ADB logcat -d > result/logcat4.log

###############################################
#Analysis test result
$ADB pull /system/lib/arm/cpuinfo cpuinfo.txt >& /dev/null && process_hint 0
$ADB pull /data/cpuinfo result >& /dev/null && process_hint 0
$ADB pull /sdcard/checkARMLibraryPathResult result >& /dev/null && process_hint 0
printf "\n"

check_result 1 "cat"
check_result 2 "java"
check_result 3 "native"
check_result 4 "native_activity"
check_result 5 "mmap"
check_file_result 6 "library_path" checkARMLibraryPathResult

