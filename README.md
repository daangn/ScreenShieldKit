# ScreenShieldKit

A Swift package that protects sensitive content from screenshots and screen recordings across Apple platforms — for UIKit, AppKit, Core Animation, and **SwiftUI**.

## Overview

ScreenShieldKit hides selected content from screenshots, screen recordings, and other system captures while it stays fully visible on the device. This is useful for screens that display sensitive information such as:

- Financial data (balances, card numbers)
- Personal identification information
- One-time passcodes and authentication screens
- Confidential documents

The protection is scoped: you protect only the views that contain secrets, and the rest of your UI is captured normally.

## Requirements

| Surface | Minimum OS |
| --- | --- |
| UIKit / AppKit / CALayer | iOS 14.0 · macOS 11.0 |
| SwiftUI | iOS 16.0 · macOS 13.0 · tvOS 16.0 · watchOS 11.0 · visionOS 1.0 |

- Swift 5.7+

## Installation

### Swift Package Manager

Add ScreenShieldKit through Xcode's **File → Add Packages…** with the URL:

```
https://github.com/daangn/ScreenShieldKit.git
```

Or add it to your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/daangn/ScreenShieldKit.git", from: "1.0.0")
]
```

## Usage

### SwiftUI

Apply the `.screenShield(_:)` modifier to any view you want to hide from captures:

```swift
import ScreenShieldKit
import SwiftUI

Text(oneTimeCode)
  .font(.system(.title, design: .monospaced))
  .screenShield()
```

To protect several views at once, group them and apply the modifier a single time:

```swift
VStack {
  AccountBalanceView()
  CardNumberView()
}
.screenShield()
```

**Dynamic on/off**

Pass a `Bool` that participates in SwiftUI state to toggle protection at runtime:

```swift
struct CardView: View {
  @State private var isSensitive = true

  var body: some View {
    VStack {
      Toggle("Protect content", isOn: $isSensitive)

      Text("1234 5678 9012 3456")
        .screenShield(isSensitive)
    }
  }
}
```

Toggling protection preserves the wrapped content's identity: it never inserts or removes views based on the flag, so the content's `@State`, scroll position, focus, and in-flight animations are **not** reset when you switch protection on or off.

### UIKit

```swift
import ScreenShieldKit

let view = UIView()
view.setScreenShield(enabled: true)   // Enable protection
view.setScreenShield(enabled: false)  // Disable protection
```

### AppKit

```swift
import ScreenShieldKit

let view = NSView()
view.setScreenShield(enabled: true)   // The view must have a backing layer
```

### Core Animation

```swift
import ScreenShieldKit

layer.setScreenShield(enabled: true)
```

## How it works

ScreenShieldKit selects a mechanism per platform and OS version:

| Path | OS | Mechanism |
| --- | --- | --- |
| SwiftUI (native) | iOS 18 / macOS 15 / tvOS 18 / watchOS 11 / visionOS 2+ | Activates SwiftUI's native capture-redaction reason in the environment. Fully transparent to layout; no hosting boundary. |
| SwiftUI (legacy) | iOS 16–17 / macOS 13–14 / tvOS 16–17 / visionOS 1 | Hosts the content in a hosting controller and applies the Core Animation capture flag to its backing layer. |
| UIKit / AppKit / CALayer | iOS 14+ / macOS 11+ | Applies the Core Animation capture flag directly to the layer. |

The SwiftUI native path is preferred where available because it composes cleanly with SwiftUI layout and state. The legacy path re-hosts the content, but SwiftUI keeps propagating the ancestor environment across the hosting boundary, so `@Environment` values and `@EnvironmentObject` dependencies still reach the shielded content.

## Important notes

- **Private platform behavior.** ScreenShieldKit relies on private platform behavior that can change between OS releases. When the mechanism is unavailable on a device, the call becomes a safe no-op (it never crashes). **Verify capture protection on every OS version you support** — with screenshots, screen recordings, AirPlay mirroring, and any in-app capture flow that matters for your product.
- **App Store.** The library avoids private selectors and private symbol references: the SwiftUI native path constructs the capture-redaction option value directly, and the Core Animation path resolves its property key at runtime. Even so, using private platform behavior carries review risk you should evaluate for your app.
- **`privacySensitive` interaction (SwiftUI native path).** On the native path (iOS 18 / macOS 15 / tvOS 18 / watchOS 11 / visionOS 2+), the shielded subtree is forced non-privacy-sensitive — even when `isProtected` is `false` — so activating the capture-redaction reason never blanks the content on device. Avoid relying on `.privacySensitive()` inside a `.screenShield()` boundary. The legacy path does not apply this, since it hides via the layer flag rather than a redaction reason.
- **macOS is best-effort.** On macOS, layer-level capture hiding may not hide content from every system capture path.

## Sample

The `Sample/` app has two tabs — a UIKit demo and a SwiftUI demo — both driving protection from a toggle. The sample targets iOS 16 so you can exercise the legacy and native SwiftUI paths on the OS versions you support.

## License

ScreenShieldKit is available under the MIT license. See the LICENSE file for more info.
