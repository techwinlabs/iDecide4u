//
//  IDFYUserDefaultsUtility.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

class IDFYUserDefaultsUtility {

  static let appWasLaunchedBeforeKey : String = "appWasLaunchedBefore"
  
  static let lastUsedListNameKey = "iDecide4u.lastUsedListName"
  
  class func wasAppLaunchedBefore() -> Bool {
    let oldValue = NSUserDefaults.standardUserDefaults().boolForKey(appWasLaunchedBeforeKey)
    NSUserDefaults.standardUserDefaults().setBool(true, forKey:appWasLaunchedBeforeKey)
    NSUserDefaults.standardUserDefaults().synchronize()
    return oldValue
  }
  
  // Just for MOCK usage.
  class func deleteAppWasLaunchedBeforeFlag() {
    NSUserDefaults.standardUserDefaults().removeObjectForKey(lastUsedListNameKey)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  class func setLastUsedListName(lastUsedListName : String) {
    NSUserDefaults.standardUserDefaults().setObject(lastUsedListName, forKey: lastUsedListNameKey)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  class func getLastUsedListName() -> String? {
    IDFYLoggingUtilities.log("lastUsedListName: " + NSUserDefaults.standardUserDefaults().stringForKey(lastUsedListNameKey)!)
    return NSUserDefaults.standardUserDefaults().stringForKey(lastUsedListNameKey)
  }

}
