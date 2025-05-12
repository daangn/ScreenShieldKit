//
//  NSView+ScreenShield.swift
//  ScreenShieldKit
//
//  Created by Ray on 5/12/25.
//

#if os(macOS)
import AppKit
import os.log

/// NSView extension for screen protection
/// Provides functionality to prevent screenshots and screen recording on macOS
extension NSView {
  /// Set screen shield protection.
  /// - Parameter enabled: Whether screen shielding should be enabled
  /// - Note: This is experimental functionality for macOS and may not work as expected.
  public func setScreenShield(enabled: Bool) {
    guard let layer else {
      logger.error("Failed to \(enabled ? "enable" : "disable") screen shield: NSView has no layer")
      return
    }
    layer.setScreenShield(enabled: enabled)
  }
}
#endif
