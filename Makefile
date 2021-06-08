TARGET := iphone:clang:latest:13.0

INSTALL_TARGET_PROCESSES = SpringBoard

ARCHS = arm64 arm64e

DEBUG = 0

FINALPACKAGE = 1

PREFIX=$(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

SYSROOT=$(THEOS)/sdks/iphoneos14.0.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = StepUp

$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += stepupprefs

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 Preferences && killall -9 SpringBoard"