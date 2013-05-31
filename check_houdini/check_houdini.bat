@rem
@rem # ----------------------------------------------------------------------------------------
@rem #
@rem #   INTEL CONFIDENTIAL
@rem #   Copyright (2012) Intel Corporation All Rights Reserved.
@rem #
@rem #   The source code contained or described herein and all documents related to the
@rem #   source code ("Material") are owned by Intel Corporation or its suppliers or
@rem #   licensors. Title to the Material remains with Intel Corporation or its suppliers
@rem #   and licensors. The Material is protected by worldwide copyright and trade secret
@rem #   laws and treaty provisions. No part of the Material may be used, copied, reproduced,
@rem #   modified, published, uploaded, posted, transmitted, distributed, or disclosed in any
@rem #   way without prior express written permission from Intel.
@rem #
@rem #   No license under any patent, copyright, trade secret or other intellectual property
@rem #   right is granted to or conferred upon you by disclosure or delivery of the Materials,
@rem #   either expressly, by implication, inducement, estoppel or otherwise. Any license under
@rem #   such intellectual property rights must be express and approved by Intel in writing.
@rem #
@rem # ----------------------------------------------------------------------------------------
@rem

@echo off

setlocal

set ADB=adb
set houdini_bin=/system/bin/houdini
set houdini_lib=/system/lib/libhoudini.so
set houdini_binfmt=/proc/sys/fs/binfmt_misc/arm
set cpuinfo_string=/system/lib/arm/cpuinfo
set neon_cpuinfo_string=/system/lib/arm/cpuinfo.neon

if not "%1" == "ics" if not "%1" == "jb41" if not "%1" == "jb42" call :echo_usage1 && goto :eof

@rem # Check device connection
%ADB% root >nul 2>nul
if errorlevel 1 call :echo_usage2

@rem #start adb server first
%ADB% kill-server >nul 2>nul
%ADB% devices >nul 2>nul

call :check_exist "houdini binary" %houdini_bin%
call :check_exist "houdini library" %houdini_lib%
call :check_exist "Enable for executable" %houdini_binfmt%
call :check_exist "Enable for cpuinfo" %cpuinfo_string%
if not "%1" == "ics" call :check_exist "Enable for neon cpuinfo" %neon_cpuinfo_string%

for /f %%i in (arm_libs_%1.txt) do call :check_exist "ARM library %%i" %%i

@rem Test Houdini hooks in framework and emulated ARM cpuinfo
set APK1=cpuinfo.apk
set APK2=cpuinfo-native.apk
set APK3=checkLibraryPath.apk
set ELF=cpuinfo.elf

set PACKAGE1=com.intel.ubt.cpuinfo
set PACKAGE2=com.intel.ubt.cpuinfo
set PACKAGE3=com.intel.checklibrarypath
set COM1=com.intel.ubt.cpuinfo/.CpuinfoActivity
set COM2=com.intel.ubt.cpuinfo/android.app.NativeActivity
set COM3=com.intel.checklibrarypath/.MainActivity
set ACTION=android.intent.action.MAIN

set TESTDIR=/data/cpuinfo/

echo Running Sanity Check for Houdini

@rem ###############################################
@rem #Prepare test envrionment
rmdir result >nul 2>nul
mkdir result >nul 2>nul

%ADB% remount >nul 2>nul && call :process_hint 3

%ADB% shell rm -r %TESTDIR% >nul 2>nul
%ADB% shell mkdir %TESTDIR% >nul 2>nul
%ADB% shell chmod 777 %TESTDIR% >nul 2>nul

@rem ###############################################
%ADB% logcat -c

%ADB% uninstall %PACKAGE1% >nul 2>nul && call :process_hint 0
%ADB% install -r %APK1% >nul 2>nul && call :process_hint 0

%ADB% shell am start -a %ACTION% -n %COM1% >nul 2>nul && call :process_hint 3
%ADB% logcat -d > result\logcat1.log

@rem ###############################################
%ADB% logcat -c

%ADB% uninstall %PACKAGE2% >nul 2>nul && call :process_hint 0
%ADB% install -r %APK2% >nul 2>nul && call :process_hint 0

%ADB% shell am start -a %ACTION% -n %COM2% >nul 2>nul && call :process_hint 3
%ADB% logcat -d > result\logcat2.log

@rem ###############################################

%ADB% logcat -c

%ADB% push %ELF% %TESTDIR% >nul 2>nul && call :process_hint 0

%ADB% shell chmod 777 %TESTDIR%/%ELF% >nul 2>nul && call :process_hint 0
%ADB% shell "su system %TESTDIR%/%ELF% > %TESTDIR%/cpuinfo5.txt" >nul 2>nul && call :process_hint 3
%ADB% logcat -d > result\logcat3.log

@rem ###############################################
%ADB% logcat -c

%ADB% uninstall %PACKAGE3% >nul 2>nul && call :process_hint 0
%ADB% install -r %APK3% >nul 2>nul && call :process_hint 0

%ADB% shell am start -a %ACTION% -n %COM3% >nul 2>nul && call :process_hint 3
%ADB% logcat -d > result\logcat4.log

@rem ###############################################
@rem #Analysis test result
%ADB% pull /system/lib/arm/cpuinfo cpuinfo.txt >nul 2>nul && call :process_hint 0
%ADB% pull /data/cpuinfo result >nul 2>nul && call :process_hint 0
%ADB% pull /sdcard/checkARMLibraryPathResult result >nul 2>nul && call :process_hint 0

echo .

@rem Check test result "cat java native native_activity mmap"
call :check_result 1 "cat"
call :check_result 2 "java"
call :check_result 3 "native"
call :check_result 4 "native_activity"
call :check_result 5 "mmap"
call :check_file_result 6 "library_path" checkARMLibraryPathResult

endlocal

goto :eof
:check_exist

set string=%1
set file=%2

%ADB% shell "if [ -e %file% ]; then echo 0; else echo 1; fi" > result.tmp
set /p ret=<result.tmp
if %ret% == 0 echo EXSIT!   ... Checking %string%
if %ret% == 1 echo MISSING! ... Checking %string%
del result.tmp

goto :eof
:process_hint

set /a sec=%1+1
@rem emulate sleep function
ping 127.0.0.1 -n %sec% -w 1000 >nul 2>nul
set /p=^.<nul

goto :eof
:check_result

set index=%1
set string=%2

fc cpuinfo.txt result\cpuinfo%index%.txt > result\cpuinfo%index%.diff.log
if errorlevel 1 echo FAIL!  ... TEST %string% && goto :eof
if errorlevel 0 echo PASS!  ... TEST %string% && goto :eof

goto :eof
:check_file_result

set index=%1
set string=%2
set file=%3

find "PASS" result\%file% >nul 2>nul
if errorlevel 1 echo FAIL!  ... TEST %string% && goto :eof
if errorlevel 0 echo PASS!  ... TEST %string% && goto :eof

goto :eof
:echo_usage1

echo\
echo Please indicate which platform you want to check:
echo .\check_houdini.bat ics  -- Houdini Sanity Check for ICS phone
echo .\check_houdini.bat jb41 -- Houdini Sanity Check for JellyBean 4.1 phone"
echo .\check_houdini.bat jb42 -- Houdini Sanity Check for JellyBean 4.2 phone"
echo\

goto :eof
:echo_usage2

echo\
echo Please make sure you have only one device attached!
echo\

goto :eof
