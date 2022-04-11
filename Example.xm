#import "TouchSimulator.h"

//To simulate System Wide Touch
%ctor {
  simulateTouch(TOUCH_DOWN, 100, 100);
  simulateTouch(TOUCH_MOVE, 100, 300);
  simulateTouch(TOUCH_UP, 100, 300);
}