//
//  IDFYDataManagerInterface.swift
//  iDecide4U
//
//  Created by Dominic Frei on 02/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

protocol IDFYDataManagerInterface {
  func getCurrentList() -> IDFYOptionList
  func getAllLists() -> [IDFYOptionList]
  func updateCurrentList(IDFYOptionList)
  func startNewList()
}
