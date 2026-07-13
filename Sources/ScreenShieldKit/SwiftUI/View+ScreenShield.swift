//
//  View+ScreenShield.swift
//  ScreenShieldKit
//
//  Created by Kanghoon Oh on 7/12/26.
//

#if canImport(SwiftUI)
import SwiftUI

extension View {
  /// Hides this view from screenshots, screen recordings, and other system captures while it stays
  /// visible on device.
  ///
  /// This is the primitive that powers ScreenShieldKit's SwiftUI support.
  ///
  /// ```swift
  /// Text(oneTimeCode)
  ///     .screenShield()          // always protected
  ///
  /// CardView()
  ///     .screenShield(isSensitive)   // protection driven by state
  /// ```
  ///
  /// ## Dynamic protection
  ///
  /// Pass a `Bool` that participates in SwiftUI state to toggle protection at runtime. The modifier
  /// keeps a stable view identity across toggles: it never inserts or removes views based on
  /// `isProtected`, it only flips the underlying capture flag. As a result, toggling protection does
  /// **not** reset the `@State`, scroll position, focus, or in-flight animations of the wrapped
  /// content.
  ///
  /// ## Implementation
  ///
  /// The mechanism is selected at runtime by OS version:
  ///
  /// - On iOS 18 / macOS 15 / tvOS 18 / watchOS 11 / visionOS 2 and later, it activates SwiftUI's
  ///   native capture-redaction reason in the environment. This path is fully transparent to layout
  ///   and does not introduce a hosting boundary.
  /// - On earlier releases (down to iOS 16 / macOS 13 / tvOS 16 / visionOS 1) it bridges the content
  ///   through a hosting controller and applies the Core Animation capture flag to its backing layer.
  ///   Because this path re-hosts the content, some ancestor `@Environment` values are not propagated
  ///   automatically; the most common ones (color scheme, layout direction, Dynamic Type size) are
  ///   forwarded for you.
  ///
  /// - Parameter isProtected: A Boolean value that determines whether the content is hidden from
  ///   captures. Defaults to `true`.
  /// - Returns: A view whose capture visibility is configured.
  ///
  /// - Important: ScreenShieldKit relies on private platform behavior. If the API is unavailable on a
  ///   given device the call becomes a safe no-op. Verify capture protection on every OS version you
  ///   support.
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 11.0, visionOS 1.0, *)
  @ViewBuilder
  public func screenShield(_ isProtected: Bool = true) -> some View {
    if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
      modifier(ScreenCaptureRedactionModifier(isProtected: isProtected))
    } else {
      #if os(watchOS)
      // watchOS ships the capture-redaction reason only from watchOS 11, which is this API's floor,
      // so this legacy branch is never reached there; render unchanged to stay exhaustive.
      self
      #else
      ScreenShieldBridge(isProtected: isProtected, content: self)
      #endif
    }
  }
}

/// Applies SwiftUI's native capture-redaction reason to the wrapped content.
///
/// Implemented as a single `ViewModifier` — rather than an `if hidden { … } else { … }` branch — so
/// that flipping `isProtected` only changes a stored value and never changes the view's identity.
///
/// `privacySensitive(false)` is applied so the content keeps rendering normally on device: activating
/// a redaction reason would otherwise redact any privacy-sensitive descendant in the on-device output
/// too. The capture pipeline still honors ``RedactionReasons/screenCaptureProhibited`` independently,
/// so the content remains hidden from screenshots and recordings.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
private struct ScreenCaptureRedactionModifier: ViewModifier {
  var isProtected: Bool

  func body(content: Content) -> some View {
    content
      .privacySensitive(false)
      .transformEnvironment(\.redactionReasons) { reasons in
        if isProtected {
          reasons.insert(.screenCaptureProhibited)
        } else {
          reasons.remove(.screenCaptureProhibited)
        }
      }
  }
}
#endif
