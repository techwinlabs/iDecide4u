//
//  IDFYOptionList.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

class IDFYOptionList {
  
  var name: String
  var options: [String]
  
  init() {
    name = ""
    options = [String]()
  }
  
  init(name: String, options: [String]) {
    self.name = name
    self.options = options
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
  
  func description() -> String {
    return "name: '\(self.name)'\noptions: \(self.options)"
  }
  
}
