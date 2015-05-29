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
    listOperationPresenter.updateListOfListsWith(dataManager.getAllLists())
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
      listOperationPresenter.askForListNameWithPredefinedListName("", shouldShowDiscardDraftOption:false)
    } else {
      dataManager.loadListWithName(listName)
      listOperationPresenter.showCurrentList()
    }
  }
  
  func didProvideNewListName(listName: String) {
    if listName.isEmpty {
      listOperationPresenter.askForListNameWithPredefinedListName(dataManager.getCurrentList().name, shouldShowDiscardDraftOption:false)
    } else {
      let list = dataManager.getCurrentList()
      list.name = listName
      dataManager.updateCurrentList(list)
      
      switch listOperationState {
      case .NewList: dataManager.startNewList()
      case .SaveList: break
      case .LoadList: dataManager.loadListWithName(previouslyForLoadSelectedListName)
      case .Unspecified: IDFYLoggingUtilities.log("This state must not be possible!")
      }
      listOperationPresenter.showCurrentList()
    }
  }
  
  func willDeleteList(listName: String, atIndexPath indexPath: NSIndexPath) {
    if dataManager.getCurrentList().name == listName {
      dataManager.startNewList()
    }
    dataManager.deleteListWithName(listName)
    listOperationPresenter.updateListOfListsWith(dataManager.getAllLists())
    listOperationPresenter.didDeleteList(listName, atIndexPath: indexPath)
  }
  
  func willDiscardDraft() {
    dataManager.deleteListWithName(dataManager.getCurrentList().name)
    dataManager.startNewList()
    listOperationPresenter.showCurrentList()
  }
  
}
