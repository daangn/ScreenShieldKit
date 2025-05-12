//
//  UIView+ScreenShield.swift
//  ScreenShieldKit
//
//  Created by Ray on 5/12/25.
//

#if os(iOS)
import UIKit

/// UIView extension for screen protection
/// Provides functionality to prevent screenshots and screen recording
extension UIView {
  /// Set screen shield protection.
  /// - Parameter enabled: Whether screen shielding should be enabled
  /// - Note: This is a private API and may not work in future iOS versions.
  public func setScreenShield(enabled: Bool) {
    layer.setScreenShield(enabled: enabled)
  }
}
#endif
