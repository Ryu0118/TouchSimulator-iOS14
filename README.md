# TouchSimulator-iOS14
Simulate touch tool working on iOS14.<br>
Also, it currently does not work on the keyboard.

```Logos
#import "TouchSimulator.h"

%ctor {
  simulateTouch(TOUCH_DOWN, 100, 100);
  simulateTouch(TOUCH_MOVE, 100, 300);
  simulateTouch(TOUCH_UP, 100, 300);
}
```

## Usage 
If you want to simulate touch in any app, execute the `simulateTouch` in the `%ctor` block (only available on Jailbroken device).<br>
If you only simulate touch in certain applications, execute the `simulateTouch` at any time.

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

