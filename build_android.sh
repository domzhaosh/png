#!/bin/sh

source ~/.bashrc
ANDROID_API_LEVEL=19

# generate the android toolchain of arm
sh $ANDROID_NDK/build/tools/make-standalone-toolchain.sh --platform=android-$ANDROID_API_LEVEL --install-dir=./android-toolchain --system=darwin-x86_64 --ndk-dir="${ANDROID_NDK}" --toolchain=arm-linux-androideabi-4.8

# generate thte android toolchain of x86
sh $ANDROID_NDK/build/tools/make-standalone-toolchain.sh --platform=android-$ANDROID_API_LEVEL --install-dir=./android-toolchain-x86 --system=darwin-x86_64 --ndk-dir="${ANDROID_NDK}" --toolchain=x86-4.8


build_with_arch()
{
    export PATH=`pwd`/$ndk_toolchain_path/bin:$PATH
    echo $PATH

    CC=$toolname_prefix-gcc
    CXX=$toolname_prefix-g++
    outputpath=`pwd`/androidoutput
    echo $outputpath
    android_system_root=`pwd`/$ndk_toolchain_path/sysroot
    echo "sysroot is $android_system_root"

    rm -rf $outputpath

    # build for armeabi-v7a
    CFLAGS=$arch_cflags
    echo "CFLAGS is "$CFLAGS
    LDFLAGS=$arch_ldflags
    echo "LDFLAGS is "$LDFLAGS

    cd libpng/
    make clean
    ./configure --prefix=$outputpath --enable-static=yes --host=$toolname_prefix
    make 
    make install

    #strip and copy
    cd ..
    #WE can't strip it : http://stackoverflow.com/questions/15247569/warning-cannot-scan-executable-section-for-cortex-a8-erratum-because-it-has-no
    # $toolname_prefix-strip --strip-unneeded $outputpath/lib/libpng16.a
    mkdir -p prebuilt/android/$release_arch_dir
    cp $outputpath/lib/libpng16.a prebuilt/android/$release_arch_dir/libpng.a
}


#build for armeabi-v7a
release_arch_dir=armeabi-v7a
toolname_prefix=arm-linux-androideabi
ndk_toolchain_path="android-toolchain"
arch_cflags="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -mthumb -O3"
arch_ldflags="-march=armv7-a -Wl,--fix-cortex-a8"
build_with_arch

# build for armeabi
release_arch_dir=armeabi
toolname_prefix=arm-linux-androideabi
ndk_toolchain_path="android-toolchain"
arch_cflags="-march=armv5te -mtune=xscale -msoft-float -mthumb -O3"
arch_ldflags=""
build_with_arch

# build for x86
echo "buid for x86..."
release_arch_dir=x86
toolname_prefix=i686-linux-android
ndk_toolchain_path="android-toolchain-x86"
arch_cflags="-O3"
arch_ldflags=""
build_with_arch

echo "copy include file..."
mkdir -p prebuilt/include/android
cp $outputpath/include/* prebuilt/include/android/
