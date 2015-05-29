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
  func askForListNameWithPredefinedListName(listName: String)
  func showCurrentList()
  func didDeleteList(listName: String, atIndexPath indexPath: NSIndexPath)
}

protocol IDFYListOperationInteractorInterface {
  func updateListOfLists()
  func willSetNameForCurrentList()
  func willStartNewList()
  func willLoadSavedList(listName: String)
  func didProvideNewListName(listName: String)
  func willDeleteList(listName: String, atIndexPath indexPath: NSIndexPath)
}
