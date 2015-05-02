//
//  IDFYListOperationInteractorPresenterIO.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

protocol IDFYListOperationPresenterInterface {
  func updateListOfListsWith(listOfLists: [IDFYOptionList])
}

protocol IDFYListOperationInteractorInterface {
  func getNameForCurrentList() -> String
  func setNewNameForCurrentList(listName: String)
  func updateListOfLists()
  func startNewList()
}
