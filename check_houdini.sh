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
DOS2UNIX=dos2unix
DEVICE=$2

houdini_bin=/system/bin/houdini
houdini_lib=/system/lib/libhoudini.so
houdini_binfmt=/proc/sys/fs/binfmt_misc/arm
cpuinfo_string=/system/lib/arm/cpuinfo

check_exist()
{
    string=$1;
    file=$2;

    printf "Checking %-60s\t... " "$string"
    ret=`$ADB -s $DEVICE shell "if [ -e $file ]; then echo 0; else echo 1; fi" | $DOS2UNIX | $DOS2UNIX`;
    if [ 0 -eq $ret ]; then
        printf "\033[32mEXSIT\033[0m\t\n";
    else
        printf "\033[31mMISSING\033[0m\t\n";
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
    warning=$3
    printf "CASE: %-20s\t " "$string:" >> result/test_log.txt
    printf "CASE: %-20s\t " "$string:"
    diff result/cpuinfo$index.txt cpuinfo.txt > result/cpuinfo$index.diff.log
    if [[ $? -ne 0 ]]
    then
	printf "\033[31mFAIL  \033[0m\t\n"
        printf "\033[31mFAIL  Warning: ${warning}\033[0m\t\n" >> result/test_log.txt
    else
	printf "\033[32mPASS\033[0m\t\n"
        printf "\033[32mPASS\033[0m\t\n" >> result/test_log.txt
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
        printf "\033[31mFAIL\033[0m\t\n"
    else
        printf "\033[32mPASS\033[0m\t\n"
    fi
}


echo_usage1()
{
    echo
    echo "Please input correct platform you want to check:"
    echo "./check_houdini.sh jb42 RHBEC244200955 -- Houdini Sanity Check for JellyBean 4.2 phone"
    echo "./check_houdini.sh jb43 RHBEC244200955 -- Houdini Sanity Check for JellyBean 4.3 phone"
    echo "./check_houdini.sh kk44 RHBEC244200955 -- Houdini Sanity Check for KitKat 4.4 phone"
    echo "./check_houdini.sh L RHBEC244200955 -- Houdini Sanity Check for L 5.0 phone"
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

kill_logcat()
{
    logcat_pids=`ps -A x | grep "adb" | grep "logcat" | awk '{print $1}'`
    for pid in $logcat_pids
    do
        kill -9 $pid >& /dev/null
    done
}


if [[ $1 != "ics" && $1 != "jb41" && $1 != "jb42" && $1 != "jb43" && $1 != "kk44" && $1 != "L" ]]
then
    echo_usage1
fi
if [[ -z $2 ]]
then
    echo_usage1

fi


# Check device connection
$ADB -s $DEVICE root >& /dev/null && sleep 2
if [ $? -ne 0 ]
then
    echo_usage2
fi
sleep 1
$ADB connect $DEVICE&
sleep 2




check_exist "houdini binary" $houdini_bin
check_exist "houdini library" $houdini_lib
#check_exist "Enable for executable" $houdini_binfmt
check_exist "Enable for cpuinfo" $cpuinfo_string


while read line
do
    check_exist "ARM library $line" $line
done < test/arm_libs_$1.txt

# Test Houdini hooks in framework and emulated ARM cpuinfo
APK2=cpuinfo-native.apk
ELF=cpuinfo.elf

PACKAGE2=com.intel.ubt.cpuinfo
COM2=com.intel.ubt.cpuinfo/android.app.NativeActivity
ACTION=android.intent.action.MAIN

TESTDIR=/data/cpuinfo/

printf "Running Sanity Check for Houdini"
printf "\n"

###############################################
#Prepare test envrionment
rm -rf result >& /dev/null
mkdir -p result

$ADB -s $DEVICE remount >& /dev/null && process_hint 3

$ADB -s $DEVICE shell rm -r $TESTDIR >& /dev/null
$ADB -s $DEVICE shell mkdir $TESTDIR >& /dev/null
$ADB -s $DEVICE shell chmod 777 $TESTDIR >& /dev/null

###############################################

        while read line
        do
                passnum=0
                failnum=0
                TESTNAME=`echo $line | awk -F '#' '{print $1}'`
                APK=`echo $line | awk -F '#' '{print $2}'`
                PACKAGE=`echo $line | awk -F '#' '{print $3}'`
                MATCHSTR=`echo $line | awk -F '#' '{print $5}'`
                CLASS=`echo $line | awk -F '#' '{print $4}'`
                WARNING=`echo $line | awk -F '#' '{print $6}'`
		if [ "$TESTNAME" = "native_activity" ]
		then
			COM=${PACKAGE}/${CLASS}
		else
                	COM=${PACKAGE}/${PACKAGE}.${CLASS}
		fi
                $ADB -s $DEVICE  uninstall $PACKAGE >& /dev/null
                $ADB -s $DEVICE  install -r test/apk/$APK >& /dev/null
##################
		kill_logcat			>& /dev/null
                $ADB -s $DEVICE  logcat -c                       >& /dev/null
                sleep 2
                $ADB  -s $DEVICE logcat >& result/logcat_${TESTNAME}.log&
######################

                $ADB -s $DEVICE  shell am start -a $ACTION -n $COM >& /dev/null
                sleep 5
		if [ "$TESTNAME" = "CHECK_HOUDINI_VERSION" ]
		then
			echo "CHECK_HOUDINI_VERSION"
            ./test/check_houdini_version.sh $DEVICE
			passnum=`./test/check_houdini_version.sh $DEVICE | grep "PASS" | wc -l`
			echo "passnum = ${passnum}"
			if [ $passnum -gt 0 ]
                        then
                                printf "CASE: $TESTNAME :         \033[32mPASS\033[0m\t\n" >> result/test_log.txt
                                printf "subtest $TESTNAME         \033[32mPASS\033[0m\t\n"
                                let "PASS=$PASS+1"
                        else
                                printf "CASE: $TESTNAME :      \033[31mFAIL   Warning:${WARNING}\033[0m\t\n" >> result/test_log.txt
                                printf "subtest $TESTNAME      \033[31mFAIL \033[0m\t\n"
                                let "FAIL=$FAIL+1"
                        fi

		else
                	passnum=`grep "$MATCHSTR" result/logcat_${TESTNAME}.log | grep "PASS" | wc -l`
                	echo "passnum = ${passnum}"
                	if [ $passnum -gt 0 ]
                	then
                        	printf "CASE: $TESTNAME :         \033[32mPASS\033[0m\t\n" >> result/test_log.txt
                        	printf "subtest $TESTNAME         \033[32mPASS\033[0m\t\n"
                        	let "PASS=$PASS+1"
                	else
                        	printf "CASE: $TESTNAME :      \033[31mFAIL   Warning:${WARNING}\033[0m\t\n" >> result/test_log.txt
                        	printf "subtest $TESTNAME      \033[31mFAIL \033[0m\t\n"
                        	let "FAIL=$FAIL+1"
                	fi
		fi
        $ADB -s $DEVICE  uninstall $PACKAGE
        let "ALL=$ALL+1"
        done< test/testlist_$1.txt

echo $ALL,$PASS,$FAIL


kill_logcat

rm -rf houdini libhoudini.so

sleep 1

echo " "
echo " "
echo " "
echo " "
echo " "
echo "Summary:"
cat result/test_log.txt
