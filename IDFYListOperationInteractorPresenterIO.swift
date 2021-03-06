//
//  IDFYListOperationInteractorPresenterIO.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

protocol IDFYListOperationPresenterInterface {
  func updateListOfListsWith(listOfLists: [IDFYOptionList], withCurrentlyActiveList indexOfCurrentlyActiveList: NSInteger)
  func askForListNameWithPredefinedListName(listName: String, shouldShowDiscardDraftOption: Bool)
  func askIfListShouldBeOverridden(listName: String)
  func showCurrentList()
  func didDeleteList(listName: String, atIndexPath indexPath: NSIndexPath)
}

protocol IDFYListOperationInteractorInterface {
  func updateListOfLists()
  func willSetNameForCurrentList()
  func willStartNewList()
  func willLoadSavedList(listName: String)
  func didProvideNewListName(listName: String, shouldOverride: Bool)
  func willDeleteList(listName: String, atIndexPath indexPath: NSIndexPath)
  func willDiscardDraft()
}
