#!/bin/sh

sh build_zlib.sh
sh build_libpng.sh


mkdir -p prebuilt/include/

echo "move ios static library to prebuilt/ios"
mkdir  prebuilt/ios
mv libpng/prebuilt/ios/libpng.a ./prebuilt/ios

echo "move ios include header files to prebuilt/include/ios"
mkdir -p ./prebuilt/include/ios
cp libpng/prebuilt/include/ios/* ./prebuilt/include/ios

echo "move static library to prebuilt/mac"
mkdir  prebuilt/mac
mv libpng/prebuilt/mac/libpng.a ./prebuilt/mac

echo "move mac include header files to prebuilt/include/mac"
mkdir -p ./prebuilt/include/mac
cp libpng/prebuilt/include/mac/* ./prebuilt/include/mac

echo "remove zlib temp files"
rm -rf zlib
