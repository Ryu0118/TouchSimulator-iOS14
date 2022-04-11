#import "TouchSimulator.h"

//To simulate System Wide Touch
%ctor {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    simulateTouch(TOUCH_DOWN, 100, 100);
    simulateTouch(TOUCH_MOVE, 100, 300);
    simulateTouch(TOUCH_UP, 100, 300);
  });
}