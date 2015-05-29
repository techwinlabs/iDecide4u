//
//  IDFYLoggingUtilities.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

class IDFYLoggingUtilities {

  class func log<T>(object: T, filename: String = __FILE__, line: Int = __LINE__, funcname: String = __FUNCTION__) {
  println(NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .NoStyle, timeStyle: .MediumStyle) + " *** \(filename.lastPathComponent)(\(line)) \(funcname):\r\(object)\n")
  }

}
