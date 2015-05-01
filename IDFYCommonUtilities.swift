//
//  IDFYCommonUtilities.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

class IDFYCommonUtilities {
  
  var lastUsedListNameKey = "iDecide4u.lastUserListName"
  
  func getLastUsedListName() -> String? {
    return NSUserDefaults.standardUserDefaults().stringForKey(lastUsedListNameKey)
  }
  
  func setLastUsedListName(listName: String) {
    NSUserDefaults.standardUserDefaults().setObject(listName, forKey: lastUsedListNameKey)
  }
  
}
