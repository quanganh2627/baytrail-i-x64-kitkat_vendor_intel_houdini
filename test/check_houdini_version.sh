#!/bin/bash

DEVICE=$1


echo_usage1()
{
    echo
    echo "Please input correct platform you want to check:"
    echo "./check_houdini_version.sh RHBEC244200955"
    echo
    exit
}



if [ -z $DEVICE ]
then
	echo_usage1

fi

rm -rf libhoudini.so houdini

adb connect $DEVICE >& /dev/null
sleep 2
adb -s $DEVICE root >& /dev/null
sleep 2

adb connect $DEVICE >& /dev/null
sleep 2
adb -s $DEVICE remount >& /dev/null

adb -s $DEVICE pull /system/lib/libhoudini.so ./ >& /dev/null

adb -s $DEVICE pull /system/bin/houdini ./ >& /dev/null

adb -s $DEVICE push test/apk/test_kernel /data/ >& /dev/null

adb -s $DEVICE shell chmod 777 /data/test_kernel >& /dev/null

if [ ! -f libhoudini.so ] || [ ! -f houdini ]
then
	echo "FAIL !  houdini not exist in phone!"
	exit 1;
fi


num=`adb -s $DEVICE shell ./data/test_kernel | grep x86_64 | wc -l`
echo $num

#### 64-bit kernel
if [ $num -eq 1 ]
then

	num_so_y=`strings libhoudini.so | grep version: | grep _y.| wc -l`
 	num_bin_y=`strings houdini | grep version: | grep _y.| wc -l`
        if [ $num_so_y -eq 1 ] && [ $num_bin_y -eq 1 ]
	then
		echo "64-bit kernel with Houdini X32 version PASS!"
	else
		echo "64-bit kernel with Houdini X32 version FAIL!"
	fi

fi

if [ $num -eq 0 ]
then
	num_so_x=`strings libhoudini.so | grep version: | grep _x. | wc -l`
        num_bin_x=`strings houdini | grep version: | grep _x. | wc -l`
        if [ $num_so_x -eq 1 ] && [ $num_bin_x -eq 1 ]
        then
                echo "32-bit kernel with Houdini x86 version PASS!"
        else
                echo "32-bit kernel with Houdini x86 version FAIL!"
        fi


fi
