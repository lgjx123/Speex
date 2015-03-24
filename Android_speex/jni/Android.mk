LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := speex

LOCAL_CFLAGS = -DFIXED_POINT -DUSE_KISS_FFT -DEXPORT="" -UHAVE_CONFIG_H

INC_DIR:=..\speex-1.2rc1\include  
SRC_PATH:=..\speex-1.2rc1\libspeex

curdir:=$(shell cd)
SRCDIRTREE := $(curdir)\$(SRC_PATH)

#生成编译的源文件
SRC_FILES := $(foreach sdir,$(SRCDIRTREE),$(wildcard $(sdir)/*.cpp))
SRC_FILES += $(foreach sdir,$(SRCDIRTREE),$(wildcard $(sdir)/*.c))
SRC_FILES := $(subst $(LOCAL_PATH),,$(SRC_FILES))

LOCAL_SRC_FILES := $(SRC_FILES)
LOCAL_C_INCLUDES:=$(curdir)\$(INC_DIR)

#$(warning $(LOCAL_SRC_FILES))
#$(warning $(LOCAL_C_INCLUDES))

include $(BUILD_SHARED_LIBRARY)
