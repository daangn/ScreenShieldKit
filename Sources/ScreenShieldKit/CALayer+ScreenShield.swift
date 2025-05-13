//
//  CALayer+ScreenShield.swift
//  ScreenShieldKit
//
//  Created by Ray on 5/12/25.
//

import os.log
import QuartzCore

private enum Constants {
  /// "disableUpdateMask" encoded in base64
  static let propertyBase64 = "ZGlzYWJsZVVwZGF0ZU1hc2s"
}

/// Extension for CALayer to provide core screen shield functionality
extension CALayer {
  /// Set screen shield protection on the layer.
  /// - Parameter enabled: Whether screen shielding should be enabled
  /// - Note: This is a private API and may not work in future OS versions.
  public func setScreenShield(enabled: Bool) {
    guard let propertyData = Data(base64Encoded: Constants.propertyBase64),
          let propertyKey = String(data: propertyData, encoding: .utf8)
    else {
      logger.error("Failed to decode property key")
      return
    }

    guard responds(to: NSSelectorFromString(propertyKey)) else {
      logger.error("Failed to \(enabled ? "enable" : "disable") screen shield: API not available on this device")
      return
    }

    let value = enabled ? (1 << 1) | (1 << 4) : 0
    setValue(NSNumber(value: value), forKey: propertyKey)
  }
}
