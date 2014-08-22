#!/bin/sh

#  Automatic build script for libpng
#  for iPhoneOS and iPhoneSimulator
###########################################################################

VERSION="1.6.12"
ZLIBVERSION="1.2.8"
SDKVERSION="7.1"

CURRENTPATH=`pwd`
BINPATH=${CURRENTPATH}/libpng/bin
OUTPATH=${CURRENTPATH}/libpng
DEVELOPER=`xcode-select --print-path`

LIPO="xcrun -sdk iphoneos lipo"
STRIP="xcrun -sdk iphoneos strip"
ios_deploy_version="7.0"

# test for Xcode
if ! test -d "${DEVELOPER}/Platforms" ; then
    echo "You must install Xcode first"
fi

xcode_base="${DEVELOPER}/Platforms"
ios_sdk_root=""
ios_toolchain="${DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin"
ios_sdk_version=${SDKVERSION}

if [ -d ${BINPATH} ]; then
	rm -rf ${BINPATH}
fi

cd "${CURRENTPATH}/../libpng"


# set the compilers
export AS="$ios_toolchain"/as
export CC="$ios_toolchain"/clang
export CXX="$ios_toolchain"/clang++
export CPP="$ios_toolchain/clang -E"
export LD="$ios_toolchain"/ld
export AR="$ios_toolchain"/ar
export RANLIB="$ios_toolchain"/ranlib
export STRIP="$ios_toolchain"/strip

export ZLIBLIB=${CURRENTPATH}/zlib/prebuilt/ios
export ZLIBINC=${ZLIBLIB}/include
export LD_LIBRARY_PATH="$ZLIBLIB:$LD_LIBRARY_PATH"


function compile_ios_static_library {
    PLATFORM_ARCH=$1
    ARCH=${PLATFORM_ARCH}
    PLATFORM=$2
    PLATFORM_TARGET=${PLATFORM}
    echo "Building libpng for ${PLATFORM} ${SDKVERSION} ${ARCH}"
    echo "Please stand by..."

    # test to see if the actual sdk exists
    ios_sdk_root="$xcode_base"/$PLATFORM_TARGET.platform/Developer/SDKs/$PLATFORM_TARGET"$ios_sdk_version".sdk

    if ! test -d "$ios_sdk_root" ; then
        echo "Invalid SDK version"
    fi

    export LDFLAGS="-isysroot $ios_sdk_root -arch $PLATFORM_ARCH -v -L$ZLIBLIB"
    export CFLAGS="-isysroot $ios_sdk_root -arch $PLATFORM_ARCH -miphoneos-version-min=$ios_deploy_version -I$ios_sdk_root/usr/include -pipe -Wno-implicit-int -Wno-return-type"
    export CXXFLAGS="$CFLAGS -I$ZLIBINC"
    export CPPFLAGS=""

    mkdir -p "${BINPATH}/${PLATFORM}${SDKVERSION}-${ARCH}.sdk"

    LOG="${BINPATH}/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/build-libpng-${VERSION}.log"

    echo "Configure libpng for ${PLATFORM} ${SDKVERSION} ${ARCH}"

    if [ "$1" = "armv7" ] || [ "$1" = "armv7s" ]; then
        ./configure -prefix=${BINPATH}/${PLATFORM}${SDKVERSION}-${ARCH}.sdk --host=${ARCH}-apple-darwin --enable-shared=no --enable-static=yes 
    elif [ "$1" = "arm64" ] || [ "$1" = "x86-64" ]; then
        ./configure -prefix=${BINPATH}/${PLATFORM}${SDKVERSION}-${ARCH}.sdk --host=arm-apple-darwin --enable-shared=no --enable-static=yes 
    else
        ./configure -prefix=${BINPATH}/${PLATFORM}${SDKVERSION}-${ARCH}.sdk --enable-shared=no --enable-static=yes 
    fi
    

    echo "Make libpng for ${PLATFORM} ${SDKVERSION} ${ARCH}"

    make  >> "${LOG}" 2>&1
    make install  >> "${LOG}" 2>&1
    make clean >> "${LOG}" 2>&1

    echo "Building libpng for ${PLATFORM} ${SDKVERSION} ${ARCH}, finished"
}

############
# iPhone Simulator
# #############
compile_ios_static_library "i386" "iPhoneSimulator"
# #############


# #############
# # iPhoneOS armv7
# #############
compile_ios_static_library "armv7" "iPhoneOS"
# #############

# #############
# # iPhoneOS armv7s
# #############
compile_ios_static_library "armv7s" "iPhoneOS"

# #############
# # iPhoneOS arm64
compile_ios_static_library "arm64" "iPhoneOS"
# #############


# #############
# # iPhoneSimulator x86_64
compile_ios_static_library "x86_64" "iPhoneSimulator"
# #############



# #############

# #################
# mac64
PLATFORM_ARCH="x86_64"
ARCH=${PLATFORM_ARCH}
PLATFORM="mac"
PLATFORM_TARGET=${PLATFORM}

ios_sdk_root=""

echo "Building libpng for ${PLATFORM} ${ARCH}"
echo "Please stand by..."

export ZLIBLIB=${CURRENTPATH}/zlib/prebuilt/mac
export ZLIBINC=${ZLIBLIB}/include
export LD_LIBRARY_PATH="$ZLIBLIB:$LD_LIBRARY_PATH"

export LDFLAGS="-arch $PLATFORM_ARCH -v -L$ZLIBLIB"
export CFLAGS="-arch $PLATFORM_ARCH -pipe -Wno-implicit-int -Wno-return-type"
export CXXFLAGS="$CFLAGS -I$ZLIBINC"
export CPPFLAGS=""

mkdir -p "${BINPATH}/${PLATFORM}-${ARCH}.sdk"

LOG="${BINPATH}/${PLATFORM}-${ARCH}.sdk/build-libpng-${VERSION}.log"

echo "Configure libpng for ${PLATFORM} ${ARCH}"

./configure -prefix=${BINPATH}/${PLATFORM}-${ARCH}.sdk --enable-shared=no --enable-static=yes # > "${LOG}" 2>&1

echo "Make libpng for ${PLATFORM} ${ARCH}"

make >> "${LOG}" 2>&1
make install  >> "${LOG}" 2>&1
make clean >> "${LOG}" 2>&1

echo "Building libpng for ${PLATFORM} ${ARCH}, finished"


# #################


# #############
# # Universal Library
echo "Build universal library..."

# ios
$LIPO -create ${BINPATH}/iPhoneSimulator${SDKVERSION}-i386.sdk/lib/libpng.a ${BINPATH}/iPhoneSimulator${SDKVERSION}-x86_64.sdk/lib/libpng.a ${BINPATH}/iPhoneOS${SDKVERSION}-armv7.sdk/lib/libpng.a  ${BINPATH}/iPhoneOS${SDKVERSION}-armv7s.sdk/lib/libpng.a ${BINPATH}/iPhoneOS${SDKVERSION}-arm64.sdk/lib/libpng.a -output ${OUTPATH}/prebuilt/ios/libpng.a
# remove debugging info
$STRIP -S ${OUTPATH}/prebuilt/ios/libpng.a
$LIPO -info ${OUTPATH}/prebuilt/ios/libpng.a

mkdir -p ${OUTPATH}/prebuilt/ios/include
cp -R ${BINPATH}/iPhoneSimulator${SDKVERSION}-i386.sdk/include/ ${OUTPATH}/prebuilt/ios/include

# mac
cp ${BINPATH}/mac-x86_64.sdk/lib/libpng.a ${OUTPATH}/prebuilt/mac/libpng.a
$STRIP -S ${OUTPATH}/prebuilt/mac/libpng.a
$LIPO -info ${OUTPATH}/prebuilt/mac/libpng.a

mkdir -p ${OUTPATH}/prebuilt/mac/include
cp -R ${BINPATH}/mac-x86_64.sdk/include/ ${OUTPATH}/prebuilt/mac/include

echo "Building all steps done."
echo "Cleaning up..."
#rm -rf ${CURRENTPATH}/src
#rm -rf ${BINPATH}
echo "Done."
