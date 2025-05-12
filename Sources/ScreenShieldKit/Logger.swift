//
//  Logger.swift
//  ScreenShieldKit
//
//  Created by Ray on 5/12/25.
//

import os.log

enum Constants {
  /// Property key used for screen shield functionality
  static let propertyKey = "disableUpdateMask"
}

let logger = Logger(subsystem: "com.karrot.screenShieldKit", category: "ScreenShield")
