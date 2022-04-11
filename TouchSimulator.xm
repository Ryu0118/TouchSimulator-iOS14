#import "TouchSimulator.h"
#import <UIKit/UIApplication.h>
#import <dlfcn.h>

static void postEvent(IOHIDEventRef event);
static void execute();
static IOHIDEventRef parent = NULL;

void simulateTouch(int type, float x, float y) {
    if (parent == NULL) {
        parent = IOHIDEventCreateDigitizerEvent(kCFAllocatorDefault, //allocator
                                                mach_absolute_time(), // timeStamp
                                                kIOHIDDigitizerTransducerTypeHand, //IOHIDDigitizerTransducerType
                                                0, // uint32_t index
                                                0, // uint32_t identity
                                                kIOHIDDigitizerEventTouch, // uint32_t eventMask
                                                0, // uint32_t buttonMask
                                                0.0, // IOHIDFloat x
                                                0.0, // IOHIDFloat y
                                                0.0, // IOHIDFloat z
                                                0.0, // IOHIDFloat tipPressure
                                                0.0, //IOHIDFloat barrelPressure
                                                0, // boolean range
                                                true, // boolean touch
                                                0// IOOptionBits options
                                                );
        IOHIDEventSetIntegerValue(parent, kIOHIDEventFieldDigitizerIsDisplayIntegrated, 1);
    }

    uint32_t isTouch = type == TOUCH_UP ? 0 : 1;
    IOHIDDigitizerEventMask eventMask = 0;
    if (type != TOUCH_UP && type != TOUCH_DOWN) 
        eventMask |= kIOHIDDigitizerEventPosition;
    if (type == TOUCH_UP || type == TOUCH_DOWN)
        eventMask |= (kIOHIDDigitizerEventTouch | kIOHIDDigitizerEventRange);

    IOHIDEventRef child = IOHIDEventCreateDigitizerFingerEvent(kCFAllocatorDefault, mach_absolute_time(), 1, 3, eventMask, x, y, 0.0f, 0.0f, 0.0f, isTouch, isTouch, 0);
    IOHIDEventSetFloatValue(child, kIOHIDEventFieldDigitizerMajorRadius, 0.04f);
    IOHIDEventSetFloatValue(child, kIOHIDEventFieldDigitizerMinorRadius, 0.04f);
    IOHIDEventAppendEvent(parent, child);

    execute();
}

static UIWindow* getKeyWindow() {
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            return window;
        }
    }
    return NULL;
}

static void postEvent(IOHIDEventRef event) {
    static IOHIDEventSystemClientRef ioSystemClient = nil;
    UIWindow* keyWindow = getKeyWindow();

    if (ioSystemClient == NULL) {
        ioSystemClient = IOHIDEventSystemClientCreate(kCFAllocatorDefault);
    }
    if (event != NULL && keyWindow != NULL) {
        uint32_t contextID = keyWindow._contextId;
        void *handle = dlopen("/System/Library/PrivateFrameworks/BackBoardServices.framework/BackBoardServices", RTLD_NOW);
        if (handle) {
            typedef void (* BKSHIDEventSetDigitizerInfoType)(IOHIDEventRef,uint32_t,uint8_t,uint8_t,CFStringRef,CFTimeInterval,float);
            //Pointer to private function BKSHIDEventSetDigitizerInfo in BackBoardServices
            BKSHIDEventSetDigitizerInfoType digitizer = (BKSHIDEventSetDigitizerInfoType)dlsym(handle, "BKSHIDEventSetDigitizerInfo");
            digitizer(event, contextID, false, false, NULL, 0, 0);
            [[UIApplication sharedApplication] _enqueueHIDEvent:event];
        }
    }
    IOHIDEventSetSenderID(event, kIOHIDEventDigitizerSenderID);
    IOHIDEventSystemClientDispatchEvent(ioSystemClient, event);
}

static void execute() {
    IOHIDEventSetIntegerValue(parent, kIOHIDEventFieldDigitizerTiltX, kIOHIDDigitizerTransducerTypeHand);
    IOHIDEventSetIntegerValue(parent, kIOHIDEventFieldDigitizerTiltY, 1);
    IOHIDEventSetIntegerValue(parent, kIOHIDEventFieldDigitizerAltitude, 1);
    postEvent(parent);
    CFRelease(parent);
    parent = NULL;
}
