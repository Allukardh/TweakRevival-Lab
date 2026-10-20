ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk
TWEAK_NAME = SnapVela
SnapVela_FILES = Tweak.xm
SnapVela_CFLAGS = -fobjc-arc
SnapVela_FRAMEWORKS = UIKit Foundation
include $(THEOS_MAKE_PATH)/tweak.mk
