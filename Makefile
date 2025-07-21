LCXX := clang++
LCC  := clang

ifeq ($(OS),Windows_NT)
	WCXX := g++
	WCC  := gcc
else
	WCXX := x86_64-w64-mingw32-g++
	WCC  := x86_64-w64-mingw32-gcc
endif

COMMON_DEBUG_FLAGS := -g -Wall -O0 -D DEBUGGING
LINUX_DEBUG_FLAGS := -fsanitize=address
COMMON_FLAGS := -frtti
COMMON_CXX_FLAGS := -std=c++20

INCLUDE := -I src/

BUILD_ROOT := build
BUILD_PATH_LINUX   := linux
BUILD_PATH_WINDOWS := windows
BUILD_PATH_OBJS    := obj_files
BUILD_PATH_OBJS_DEBUG   := debug
BUILD_PATH_OBJS_RELEASE := release

NAME_LINUX := knave
NAME_WINDOWS := knave.exe
NAME_DEBUG := debug_

export NAME_VERSION ?=

export NAME_ARCH ?= $(NAME_LINUX)
export BUILD_ARCH ?= $(BUILD_PATH_LINUX)
export DEBUG_FLAGS ?= $(COMMON_DEBUG_FLAGS) $(LINUX_DEBUG_FLAGS)
export CXX ?= $(LCXX)
export CC ?= $(LCC)
ifeq ($(OS),Windows_NT)
	export NAME_ARCH ?= $(NAME_WINDOWS)
	export BUILD_ARCH ?= $(BUILD_PATH_WINDOWS)
	export DEBUG_FLAGS ?= $(COMMON_DEBUG_FLAGS)
	export CXX ?= $(WCXX)
	export CC ?= $(WCC)
endif

export NAME ?= $(NAME_VERSION)$(NAME_ARCH)
export BUILD_PATH ?= $(BUILD_ROOT)/$(BUILD_ARCH)
export BUILD_PATH_OBJS_VERSION ?= $(BUILD_PATH_OBJS_RELEASE)
export OBJS_PATH ?= $(BUILD_PATH)/$(BUILD_PATH_OBJS)_$(BUILD_PATH_OBJS_VERSION)
export CXXFLAGS ?= $(COMMON_FLAGS) $(COMMON_CXX_FLAGS)
export CCFLAGS  ?= $(COMMON_FLAGS)

VPATH := $(SRC_DIRS)

SRC_DIRS := \
	src \

CC_SRCS  := $(foreach directory,$(SRC_DIRS),$(wildcard $(directory)/*.c))
CXX_SRCS := $(foreach directory,$(SRC_DIRS),$(wildcard $(directory)/*.cpp))

export CC_OBJS  ?= $(addprefix $(OBJS_PATH)/,$(subst .c,.o,$(CC_SRCS:src/%=%)))
export CXX_OBJS ?= $(addprefix $(OBJS_PATH)/,$(subst .cpp,.obj,$(CXX_SRCS:src/%=%)))

export RESET   ?= \\033[0m
export BLACK   ?= \\033[30m
export RED     ?= \\033[31m
export GREEN   ?= \\033[32m
export YELLOW  ?= \\033[33m
export BLUE    ?= \\033[34m
export MAGENTA ?= \\033[35m
export CYAN    ?= \\033[36m
export WHITE   ?= \\033[37m
export DEFAULT ?= \\033[39m


.PHONY: build sublime linux windows debug release clean

build:
	@ printf "$(DEFAULT)::Compiling application objects$(RESET)\n"

	@ $(MAKE) -s $(CC_OBJS) $(CXX_OBJS)

	@ printf "$(DEFAULT)::Linking application$(RESET)\n"

	@ -rm -f $(BUILD_PATH)/$(NAME) # in case it already exists
	@ $(MAKE) -s $(BUILD_PATH)/$(NAME)

# This target is for disabling the ANSI colors. The reason it's called 'sublime' (and an example use-case) is because
# Sublime Text's output panel doesn't support ANSI colors natively, so I call this target in every build system that's
# in my Sublime Text project file for Nostalgia.
sublime:
	$(eval RESET   := "")
	$(eval BLACK   := "")
	$(eval RED     := "")
	$(eval GREEN   := "")
	$(eval YELLOW  := "")
	$(eval BLUE    := "")
	$(eval MAGENTA := "")
	$(eval CYAN    := "")
	$(eval WHITE   := "")
	$(eval DEFAULT := "")
	@ printf "Output colors disabled\n"

linux:
ifeq ($(OS),Windows_NT)
	$(eval NAME := $(NAME_LINUX))
	$(eval BUILD_ARCH := $(BUILD_PATH_LINUX))
endif
	$(eval CXX := $(LCXX))
	$(eval CC := $(LCC))
	$(eval DEBUG_FLAGS := $(COMMON_DEBUG_FLAGS) $(LINUX_DEBUG_FLAGS))
	@ printf "$(DEFAULT)::Architecture - Linux$(RESET)\n"

windows:
ifneq ($(OS),Windows_NT)
	$(eval NAME := $(NAME_WINDOWS))
	$(eval BUILD_ARCH := $(BUILD_PATH_WINDOWS))
endif
	$(eval CXX := $(WCXX))
	$(eval CC := $(WCC))
	$(eval DEBUG_FLAGS := $(COMMON_DEBUG_FLAGS))
	@ printf "$(DEFAULT)::Architecture - Windows$(RESET)\n"

debug:
	$(eval NAME_VERSION := $(NAME_DEBUG))
	$(eval BUILD_PATH_OBJS_VERSION := $(BUILD_PATH_OBJS_DEBUG))
	$(eval CXXFLAGS = $(COMMON_FLAGS) $(COMMON_CXX_FLAGS) $(DEBUG_FLAGS))
	$(eval CCFLAGS = $(COMMON_FLAGS) $(DEBUG_FLAGS))
	@ printf "$(DEFAULT)::Version - Debug$(RESET)\n"

release:
	@ printf "$(DEFAULT)::Building Release$(RESET)\n"
	$(eval NAME_VERSION := )
	$(eval BUILD_PATH_OBJS_VERSION := $(BUILD_PATH_OBJS_RELEASE))
	$(eval CXXFLAGS := $(COMMON_FLAGS) $(COMMON_CXX_FLAGS))
	$(eval CCFLAGS := $(COMMON_FLAGS))
	@ printf "$(DEFAULT)::Version - Release$(RESET)\n"

build_dir:
	@ -mkdir -p $(OBJS_PATH)

$(BUILD_PATH)/$(NAME): $(CC_OBJS) $(CXX_OBJS)
	@ printf "$(DEFAULT)Linking: $(CYAN)$@$(RESET)\n"
	$(CXX) $(CXXFLAGS) $(INCLUDE) $^ -o $@

$(OBJS_PATH)/%.o: src/%.c | build_dir
	@ printf "$(DEFAULT)Compiling: $(DEFAULT)$<$(RESET) -> $(CYAN)$@$(RESET)\n"
	@ -mkdir -p $(dir $@)
	$(CC) $(CCFLAGS) $(INCLUDE) -c $< -o $@

$(OBJS_PATH)/%.obj: src/%.cpp | build_dir
	@ printf "$(DEFAULT)Compiling: $(DEFAULT)$<$(RESET) -> $(CYAN)$@$(RESET)\n"
	@ -mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

clean:
	@ -rm -rf $(BUILD_ROOT)