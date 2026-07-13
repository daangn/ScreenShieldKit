//
//  RedactionReasons+ScreenShield.swift
//  ScreenShieldKit
//
//  Created by Kanghoon Oh on 7/12/26.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension RedactionReasons {
  /// SwiftUI's private "prohibit screen capture" redaction reason.
  ///
  /// Starting with iOS 18 (and the matching releases on other platforms), SwiftUI can hide a view
  /// from screenshots, screen recordings, and other system captures by activating this redaction
  /// reason in the environment while leaving the on-device rendering untouched.
  ///
  /// The value is constructed directly from its raw option bit (`1 << 3`) instead of binding to the
  /// underlying SwiftUI SPI symbol. This produces the exact option value SwiftUI checks when it
  /// redacts captured content, while keeping ScreenShieldKit free of any private symbol reference —
  /// there is no selector string and no `@_silgen_name` binding to flag during static analysis.
  ///
  /// - Note: This relies on private platform behavior and may change in a future OS version. Callers
  ///   never touch this value directly; it is applied through ``View/screenShield(_:)``.
  static let screenCaptureProhibited: RedactionReasons = .init(rawValue: 1 << 3)
}
#endif
