LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := png
LOCAL_CFLAGS := -Wall
LOCAL_MODULE_FILENAME := libpng

LOCAL_SRC_FILES :=  ../../libpng/png.c \
		    ../../libpng/pngerror.c \
		    ../../libpng/pngget.c \
		    ../../libpng/pngmem.c \
		    ../../libpng/pngpread.c \
		    ../../libpng/pngread.c \
		    ../../libpng/pngrio.c \
		    ../../libpng/pngrtran.c \
		    ../../libpng/pngrutil.c \
		    ../../libpng/pngset.c \
		    ../../libpng/pngtrans.c \
		    ../../libpng/pngwio.c \
		    ../../libpng/pngwrite.c \
		    ../../libpng/pngwtran.c \


LOCAL_CPPFLAGS +=-fexceptions

LOCAL_LDLIBS := -lz

include $(BUILD_STATIC_LIBRARY)
