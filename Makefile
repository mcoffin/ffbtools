#
# Makefile for ffbtools
# 
#
# Copyright 2019 Bernat Arlandis <bernat@hotmail.com>
#
# This file is part of ffbtools.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

BUILD_DIR ?= ./build
SRC_DIR ?= ./src

OBJS := $(shell find $(BUILD_DIR) -name *.o 2> /dev/null)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIR) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CFLAGS += $(INC_FLAGS) -MMD -MP -Wall
LDLIBS ?= -lm
LDFLAGS += -fPIC

all: $(BUILD_DIR) \
	$(BUILD_DIR)/libffbwrapper-i386.so \
	$(BUILD_DIR)/libffbwrapper-x86_64.so \
	$(BUILD_DIR)/ffbplay

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/libffbwrapper-i386.so: $(SRC_DIR)/ffbwrapper.c
	$(CC) $(CFLAGS) $(CFLAGS) $(LDFLAGS) -m32 -shared $< -o $@ -lrt -ldl

$(BUILD_DIR)/libffbwrapper-x86_64.so: $(SRC_DIR)/ffbwrapper.c
	$(CC) $(CFLAGS) $(CFLAGS) $(LDFLAGS) -shared $< -o $@ -lrt -ldl

$(BUILD_DIR)/ffbplay: $(BUILD_DIR)/ffbplay.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: directories clean

clean:
	[ ! -d $(BUILD_DIR) ] || $(RM) -r $(BUILD_DIR)

-include $(DEPS)
