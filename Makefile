TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

THEOS_DEVICE_IP = 192.168.0.56

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TouchSimulator

TouchSimulator_FILES =  TouchSimulator.xm Example.xm
TouchSimulator_CFLAGS = -fobjc-arc -Wno-error -Wno-module-import-in-extern-c

TouchSimulator_FRAMEWORKS = UIKit IOSurface
TouchSimulator_PRIVATE_FRAMEWORKS = IOKit
TouchSimulator_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk

rm:
	rm -rf .theos
	rm -rf packages