#!/bin/sh

cd ios_mac/

sh build_zlib.sh
sh build_libpng.sh

cd ..

mkdir -p prebuilt/ios
mv libpng/prebuilt/ios/libpng.a ./prebuilt/ios

mkdir -p prebuilt/mac
mv libpng/prebuilt/mac/libpng.a ./prebuilt/mac
