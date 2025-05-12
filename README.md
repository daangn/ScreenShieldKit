# ScreenShieldKit

A Swift package to protect sensitive content from screenshots and screen recording on iOS and macOS platforms.

## Overview

ScreenShieldKit provides an easy-to-use API to prevent content from being captured in screenshots or screen recordings. This is especially useful for applications that display sensitive information such as:

- Financial data
- Personal identification information
- Confidential documents
- Authentication screens

## Requirements

- iOS 14.0+ / macOS 11.0+
- Swift 5.7+

## Installation

### Swift Package Manager

Add ScreenShieldKit to your project through Xcode's Package Dependencies:

1. In Xcode, select "File" → "Add Packages..."
2. Enter the repository URL: `https://github.com/daangn/ScreenShieldKit.git`
3. Choose the version you want to use

Or add it to your `Package.swift` file:

```swift
dependencies: [
  .package(url: "https://github.com/daangn/ScreenShieldKit.git", from: "1.0.0")
]
```

## Usage

### Basic Usage

```swift
import ScreenShieldKit

// iOS
let view = UIView()
view.setScreenShield(enabled: true) // Enable protection

// When protection is no longer needed
view.setScreenShield(enabled: false) // Disable protection

// macOS
let view = NSView()
view.setScreenShield(enabled: true) // Enable protection

// When protection is no longer needed
view.setScreenShield(enabled: false) // Disable protection
```

## Important Notes

- This library uses private APIs which may not be approved for App Store submission
- The protection mechanism may change in future OS versions
- For macOS, the view must have a backing layer for the protection to work

## License

ScreenShieldKit is available under the MIT license. See the LICENSE file for more info.
