TARGET := iphone:clang:latest:13.0

INSTALL_TARGET_PROCESSES = SpringBoard

ARCHS = arm64 arm64e

DEBUG = 0

FINALPACKAGE = 1

PREFIX=$(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

SYSROOT=$(THEOS)/sdks/iphoneos14.0.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = StepUp

StepUp_FILES = Tweak.xm
StepUp_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences && killall -9 SpringBoard"