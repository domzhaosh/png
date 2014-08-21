LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := libzlib
LOCAL_CFLAGS := -Wall
LOCAL_MODULE_FILENAME := libz

LOCAL_SRC_FILES :=   \
    ../../../zlib/adler32.c \
    ../../../zlib/compress.c \
    ../../../zlib/crc32.c \
    ../../../zlib/deflate.c \
    ../../../zlib/gzclose.c \
    ../../../zlib/gzlib.c \
    ../../../zlib/gzread.c \
    ../../../zlib/gzwrite.c \
    ../../../zlib/inflate.c \
    ../../../zlib/infback.c \
    ../../../zlib/inftrees.c \
    ../../../zlib/inffast.c \
    ../../../zlib/trees.c \
    ../../../zlib/uncompr.c \
    ../../../zlib/zutil.c \


include $(BUILD_STATIC_LIBRARY)
