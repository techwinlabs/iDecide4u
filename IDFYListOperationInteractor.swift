//
//  IDFYListOperationInteractor.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

class IDFYListOperationInteractor : IDFYListOperationInteractorInterface {
  
  var listOperationPresenter : IDFYListOperationPresenterInterface!
  var dataManager : IDFYDataManagerInterface!
  
  private enum ListOperationState {
    case Unspecified
    case NewList
    case SaveList
    case LoadList
  }
  private var previouslyForLoadSelectedListName : String = ""
  private var listOperationState : ListOperationState = ListOperationState.Unspecified
  
  // MARK: - IDFYListOperationInteractorInterface
  
  func updateListOfLists() {
    listOperationPresenter.updateListOfListsWith(dataManager.getAllLists(), withCurrentlyActiveList: indexOfCurrentlyActiveList())
  }
  
  func willSetNameForCurrentList() {
    listOperationState = ListOperationState.SaveList
    listOperationPresenter.askForListNameWithPredefinedListName(dataManager.getCurrentList().name, shouldShowDiscardDraftOption:false)
  }
  
  func willStartNewList() {
    listOperationState = ListOperationState.NewList
    if dataManager.getCurrentList().name.isEmpty && !dataManager.getCurrentList().options.isEmpty {
      listOperationPresenter.askForListNameWithPredefinedListName("", shouldShowDiscardDraftOption:true)
    } else {
      dataManager.startNewList()
      listOperationPresenter.showCurrentList()
    }
  }
  
  func willLoadSavedList(listName: String) {
    listOperationState = ListOperationState.LoadList
    previouslyForLoadSelectedListName = listName
    if dataManager.getCurrentList().name.isEmpty && !dataManager.getCurrentList().options.isEmpty {
      listOperationPresenter.askForListNameWithPredefinedListName("", shouldShowDiscardDraftOption:true)
    } else {
      dataManager.loadListWithName(listName)
      listOperationPresenter.showCurrentList()
    }
  }
  
  func didProvideNewListName(listName: String, shouldOverride: Bool) {
    if listName.isEmpty {
      var shouldShowDiscardDraftOption = false
      switch listOperationState {
      case .NewList: shouldShowDiscardDraftOption = true
      case .SaveList: shouldShowDiscardDraftOption = false
      case .LoadList: shouldShowDiscardDraftOption = true
      case .Unspecified: IDFYLoggingUtilities.error("This state must not be possible!")
      }
      listOperationPresenter.askForListNameWithPredefinedListName(dataManager.getCurrentList().name, shouldShowDiscardDraftOption:shouldShowDiscardDraftOption)
      
    } else {
      if dataManager.doesListWithNameExist(listName) && false == shouldOverride {
        listOperationPresenter.askIfListShouldBeOverridden(listName)
      } else {
        switch listOperationState  {
        case .NewList:
          persistNewListName(listName)
          dataManager.startNewList()
        case .SaveList:
          if shouldOverride {
            let oldList = dataManager.getCurrentList()
            oldList.name = listName
            IDFYLoggingUtilities.debug("previouslyForSaveSelectedList: \(oldList.description())")
            dataManager.deleteListWithName(listName)
            dataManager.updateCurrentList(oldList)
          } else {
            persistNewListName(listName)
          }
        case .LoadList:
          persistNewListName(listName)
          dataManager.loadListWithName(previouslyForLoadSelectedListName)
        case .Unspecified:
          IDFYLoggingUtilities.error("This state must not be possible!")
        }
        listOperationPresenter.showCurrentList()
      }
    }
  }
  
  func willDeleteList(listName: String, atIndexPath indexPath: NSIndexPath) {
    if dataManager.getCurrentList().name == listName {
      dataManager.startNewList()
    }
    dataManager.deleteListWithName(listName)
    listOperationPresenter.updateListOfListsWith(dataManager.getAllLists(), withCurrentlyActiveList: indexOfCurrentlyActiveList())
    listOperationPresenter.didDeleteList(listName, atIndexPath: indexPath)
  }
  
  func willDiscardDraft() {
    dataManager.deleteListWithName(dataManager.getCurrentList().name)
    dataManager.startNewList()
    listOperationPresenter.showCurrentList()
  }
  
  
  // MARK: - Convenience functions
  
  private func indexOfCurrentlyActiveList() -> Int {
    let listArray = dataManager.getAllLists()
    var indexOfCurrentlyActiveList = -1
    let currentListName = dataManager.getCurrentList().name
    for (var i=0; i<listArray.count; i++) {
      if currentListName == listArray[i].name {
        indexOfCurrentlyActiveList = i
      }
    }
    return indexOfCurrentlyActiveList
  }
  
  private func persistNewListName(listName: String) {
    let list = dataManager.getCurrentList()
    IDFYLoggingUtilities.debug("current list:\n\(list.description())")
    list.name = listName
    dataManager.updateCurrentList(list)
  }
  
}
