#!/bin/sh

# we must specify the ndk root first before running this scripts
# export NDK_ROOT=/Users/guanghui/AndroidDev/android-ndk-r9d/
# export PATH=$NDK_ROOT:$PATH
# export ANDROID_SDK_ROOT=/Users/guanghui/AndroidDev/adt-bundle-mac-x86_64-20130522/sdk/
source ~/.bash_profile
export PATH=$ANDROID_SDK_ROOT:$PATH
export PATH=$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools:$PATH
export ANT_ROOT=/usr/local/bin
export NDK_MODULE_PATH=`pwd`
echo $NDK_MODULE_PATH

cd android/libpng

NDK-build


