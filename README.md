libpng
======

## About this repository

 - This is NOT the official libpng standalone project. Official website is [here](http://www.libpng.org/pub/png/libpng.html). And zlib official website is [here](http://www.zlib.net/)
 - The version of libpng is 1.6.12, and the version of zlib is 1.2.8

## How to build

### Build IOS & Mac static library

```
cd ios_mac
./build_zlib.sh
./build_libpng.sh
```

### Build Android static library
At first, you should configure your NDK_ROOT and ANDROID_SDK_ROOT environment variable.

```
cd android
./libpng.sh
```

### Build Linux library


### Build Win32 library
Before running the following commands, you should rename *zlib-1.2.8* to *zlib* at first.

```
nmake /f scripts\makefile.vcwin32
```

Note: why we put zlib-1.2.8 here. Because if you use *projects/vcprojects* to generate the
static library, the file path must be zlib-1.2.8

Please refer to [here](http://blog.morzproject.com/build-static-libpng-using-visual-studio/) for more information.
