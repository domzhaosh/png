#!/bin/sh

source ~/.bashrc
ANDROID_API_LEVEL=19

# generate the android toolchain of arm
sh $ANDROID_NDK/build/tools/make-standalone-toolchain.sh --platform=android-$ANDROID_API_LEVEL --install-dir=./android-toolchain --system=darwin-x86_64 --ndk-dir="${ANDROID_NDK}" --toolchain=arm-linux-androideabi-4.8

# generate thte android toolchain of x86
sh $ANDROID_NDK/build/tools/make-standalone-toolchain.sh --platform=android-$ANDROID_API_LEVEL --install-dir=./android-toolchain-x86 --system=darwin-x86_64 --ndk-dir="${ANDROID_NDK}" --toolchain=x86-4.8

export PATH=`pwd`/android-toolchain/bin:$PATH
echo $PATH

CC=arm-linux-androideabi-gcc
CXX=arm-linux-androideabi-g++
outputpath=`pwd`/androidoutput
echo $outputpath
android_system_root=`pwd`/android-toolchain/sysroot
echo "sysroot is $android_system_root"


# build for armeabi-v7a
CFLAGS="--sysroot=$android_system_root -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
LDFLAGS="--sysroot=$android_system_root -march=armv7-a -Wl,--fix-cortex-a8"

cd libpng/
./configure --prefix=$outputpath --enable-static=yes --host=arm-linux-androideabi
make
make install

#strip and copy
cd ..
arm-linux-androideabi-strip --strip-unneeded $outputpath/lib/libpng16.a
mkdir -p prebuilt/android/armeabi-v7a
cp $outputpath/lib/libpng16.a prebuilt/android/armeabi-v7a/libpng.a


