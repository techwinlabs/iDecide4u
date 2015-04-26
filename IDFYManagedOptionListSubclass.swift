//
//  IDFYManagedOptionListSubclass.swift
//  iDecide4U
//
//  Created by Dominic Frei on 25/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import CoreData

extension IDFYManagedOptionList  {
  
  func initialize() {
    name = ""
    options = [String]()
  }
  
  func count() -> Int {
    return options.count
  }
  
  func isEmpty() -> Bool {
    return 0 == count()
  }
  
  func optionAtIndex(index: Int) -> String {
    return options[index]
  }
  
  func addOption(option: String) {
    if !contains(options, option) {
      options.append(option)
    }
  }
  
  func removeOption(option: String) {
    if var indexToRemove = find(options, option) {
      options.removeAtIndex(indexToRemove)
    }
  }
  
  func clearList() {
    options = []
  }

  
}

