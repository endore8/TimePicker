# TimePicker

Better TimePicker for iOS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Requirements

- Swift 3.0
- iOS 10.0+
- Xcode 8+

## Installation

The easiest way is through [CocoaPods](https://cocoapods.org). Simply add the dependency to your Podfile and then pod install:

```
pod 'TimePicker'
```

Or [Carthage](https://github.com/Carthage/Carthage). Add the dependency to your Cartfile and then carthage update:

```
github "Endore8/TimePicker"
```

## Usage

### 

```
let timePicker = TimePicker()
view.addSubview(timePicker)
```

### Config

```
timePicker.config = TimePickerConfig(
    text: TimePickerConfig.Text.text,
    time: TimePickerConfig.time
)
```

## ToDo

- [ ] Tests
- [ ] Optional haptic feedback
- [ ] Code documentation

## License

The library is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
