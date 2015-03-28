LOCAL_PATH:= $(call my-dir)/

#编译参数设置
MYCOMPILE_CFLAG:= -g -D_ANDROID_ -DFIXED_POINT -DUSE_KISS_FFT -DEXPORT="" -UHAVE_CONFIG_H
MYCOMPILE_CXXFLAG:= -g -D_ANDROID_  -fpermissive

################## 头文件设置 ##################

#头文件目录
INC_DIR:=../../speex-1.2rc1/include

# 需要排除的目录,要以'%'打头,中间用空格分隔
EXCLUDE_DIRS := %IOS %Win 

# 需要排除的文件,要以'%'打头,中间用空格分隔
EXCLUDE_FILES := 

# 取得当前目录的所有子目录名称
INC_DIRTREE := $(shell find $(LOCAL_PATH)$(INC_DIR) -maxdepth 99 -type d)
INC_DIRTREE := $(filter-out $(EXCLUDE_DIRS),$(INC_DIRTREE))

################## 源码文件设置 ##################

#源码根目录
SRC_DIR:=../../speex-1.2rc1/libspeex

$(warning $(SRC_DIR))
$(warning $(INC_DIR))

# 需要排除的目录,要以'%'打头,中间用空格分隔
EXCLUDE_DIRS := %IOS %Win32 %Win32/ImpSound 

# 需要排除的文件,要以'%'打头,中间用空格分隔
EXCLUDE_FILES := 

# 取得当前目录的所有子目录名称
SRC_DIR := $(shell find $(LOCAL_PATH)$(SRC_DIR) -maxdepth 99 -type d)
SRC_DIR := $(filter-out $(EXCLUDE_DIRS),$(SRC_DIR))

SRC_FILES       := $(foreach sdir,$(SRC_DIR),$(wildcard $(sdir)/*.cpp))
SRC_FILES       += $(foreach sdir,$(SRC_DIR),$(wildcard $(sdir)/*.c))
SRC_FILES		:= $(subst $(LOCAL_PATH),,$(SRC_FILES))

#过滤掉某些不能编译进去的cpp
SRC_FILES := $(filter-out $(EXCLUDE_FILES), $(SRC_FILES))

#生成 Spexx 库
include $(CLEAR_VARS)

LOCAL_C_INCLUDES:=$(INC_DIRTREE)
LOCAL_C_INCLUDES+=$(SRC_DIR)

LOCAL_SRC_FILES = $(SRC_FILES)

#生成库名
LOCAL_MODULE:=speex

LOCAL_STATIC_LIBRARIES:=

LOCAL_CFLAGS := $(MYCOMPILE_CFLAG)
LOCAL_CXXFLAGS:= $(MYCOMPILE_CXXFLAG)

include $(BUILD_STATIC_LIBRARY)
