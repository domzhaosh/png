LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := png
LOCAL_MODULE_FILENAME := libpng

LOCAL_SRC_FILES :=  \
  ../../../libpng/png.c \
  ../../../libpng/pngerror.c \
  ../../../libpng/pngget.c \
  ../../../libpng/pngmem.c \
  ../../../libpng/pngpread.c \
  ../../../libpng/pngread.c \
  ../../../libpng/pngrio.c \
  ../../../libpng/pngrtran.c \
  ../../../libpng/pngrutil.c \
  ../../../libpng/pngset.c \
  ../../../libpng/pngtrans.c \
  ../../../libpng/pngwio.c \
  ../../../libpng/pngwrite.c \
  ../../../libpng/pngwtran.c \
  ../../../libpng/pngwutil.c \

LOCAL_C_INCLUDES :=  \
	    $(LOCAL_PATH)/../../../libpng/png.h \
	    $(LOCAL_PATH)/../../../libpng/pngconf.h \
	    $(LOCAL_PATH)/../../../libpng/pngdebug.h \
	    $(LOCAL_PATH)/../../../libpng/pnginfo.h \
	    $(LOCAL_PATH)/../../../libpng/pngpriv.h \
	    $(LOCAL_PATH)/../../../libpng/pngstruct.h \

LOCAL_EXPORT_LDLIBS := -lz

LOCAL_CPPFLAGS +=-fexceptions

include $(BUILD_STATIC_LIBRARY)
