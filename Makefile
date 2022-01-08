ARCHS = arm64 arm64e
THEOS_DEVICE_IP = 192.168.1.106 #localhost -p 2222
INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:clang:14.4:13
PACKAGE_VERSION = 1.1.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Recents

Recents_PRIVATE_FRAMEWORKS = SpringBoard SpringBoardHome MaterialKit
Recents_FILES = $(shell find Sources/Recents -name '*.swift') $(shell find Sources/RecentsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Recents_SWIFTFLAGS = -ISources/RecentsC/include
Recents_CFLAGS = -fobjc-arc -ISources/RecentsC/include

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += recents
SUBPROJECTS += recentsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
