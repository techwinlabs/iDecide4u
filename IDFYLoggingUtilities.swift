//
//  IDFYLoggingUtilities.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

class IDFYLoggingUtilities {
  
  private enum LogLevel : Int {
    case Debug = 0
    case Info = 1
    case Warning = 2
    case Error = 3
    case Fatal = 4
  }
  
  private static let currentLogLevel = LogLevel.Info

  class func debug<T>(object: T, filename: String = __FILE__, line: Int = __LINE__, funcname: String = __FUNCTION__) {
    if LogLevel.Debug.rawValue >= self.currentLogLevel.rawValue {
      log(object, filename: filename, line: line, funcname: funcname)
    }
  }
  
  class func info<T>(object: T, filename: String = __FILE__, line: Int = __LINE__, funcname: String = __FUNCTION__) {
    if LogLevel.Info.rawValue >= self.currentLogLevel.rawValue {
      log(object, filename: filename, line: line, funcname: funcname)
    }
  }
  
  class func warning<T>(object: T, filename: String = __FILE__, line: Int = __LINE__, funcname: String = __FUNCTION__) {
    if LogLevel.Warning.rawValue >= self.currentLogLevel.rawValue {
      log(object, filename: filename, line: line, funcname: funcname)
    }
  }
  
  class func error<T>(object: T, filename: String = __FILE__, line: Int = __LINE__, funcname: String = __FUNCTION__) {
    if LogLevel.Error.rawValue >= self.currentLogLevel.rawValue {
      log(object, filename: filename, line: line, funcname: funcname)
    }
  }
  
  class func fatal<T>(object: T, filename: String = __FILE__, line: Int = __LINE__, funcname: String = __FUNCTION__) {
    if LogLevel.Fatal.rawValue >= self.currentLogLevel.rawValue {
      log(object, filename: filename, line: line, funcname: funcname)
    }
  }
  
  private class func log<T>(object: T, filename: String, line: Int, funcname: String) {
  println(NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .NoStyle, timeStyle: .MediumStyle) + " *** \(filename.lastPathComponent)(\(line)) \(funcname):\r\(object)\n")
  }

}
