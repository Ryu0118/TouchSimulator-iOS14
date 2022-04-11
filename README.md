# TouchSimulator-iOS14
Tweak to simulate touch.<br>
Currently only works on native apps written in UIKit.<br>
Also, it currently does not work on the keyboard.

⚠️**This library is only available on Jailbroken devices!**

```Logos
#import "TouchSimulator.h"

%ctor {
  simulateTouch(TOUCH_DOWN, 100, 100);
  simulateTouch(TOUCH_MOVE, 100, 300);
  simulateTouch(TOUCH_UP, 100, 300);
}
```

## Usage 
If you want to simulate touch in SystemWide, execute the `simulateTouch` in the `%ctor` block.
If you do not require execution on SystemWide, execute the `simulateTouch` at any time.

Copy `TouchSimulator.xm`, `TouchSimulator.h` and `headers/` to your project directory

### Tap
```Logos
simulateTouch(TOUCH_DOWN, 100, 100);
simulateTouch(TOUCH_UP, 100, 100);
```

### Drag
```Logos
simulateTouch(TOUCH_DOWN, 100, 100);
simulateTouch(TOUCH_MOVE, 100, 300);
simulateTouch(TOUCH_UP, 100, 300);
```

### LongPress
coming soon...
