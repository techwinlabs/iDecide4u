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
    listOperationPresenter.askForListNameWithPredefinedListName(dataManager.getCurrentList().name)
  }
  
  func willStartNewList() {
    listOperationState = ListOperationState.NewList
    if dataManager.getCurrentList().name.isEmpty && !dataManager.getCurrentList().options.isEmpty {
      listOperationPresenter.askForListNameWithPredefinedListName("")
    } else {
      dataManager.startNewList()
      listOperationPresenter.showCurrentList()
    }
  }
  
  func willLoadSavedList(listName: String) {
    listOperationState = ListOperationState.LoadList
    previouslyForLoadSelectedListName = listName
    if dataManager.getCurrentList().name.isEmpty && !dataManager.getCurrentList().options.isEmpty {
      listOperationPresenter.askForListNameWithPredefinedListName("")
    } else {
      dataManager.loadListWithName(listName)
      listOperationPresenter.showCurrentList()
    }
  }
  
  func didProvideNewListName(listName: String) {
    if listName.isEmpty {
      listOperationPresenter.askForListNameWithPredefinedListName(dataManager.getCurrentList().name)
    } else {
      let list = dataManager.getCurrentList()
      list.name = listName
      dataManager.updateCurrentList(list)
      
      switch listOperationState {
      case .NewList: dataManager.startNewList()
      case .SaveList: break
      case .LoadList: dataManager.loadListWithName(previouslyForLoadSelectedListName)
      case .Unspecified: abort()
      }
      listOperationPresenter.showCurrentList()
    }
  }
  
  func willDeleteList(listName: String) {
    dataManager.deleteListWithName(listName)
    listOperationPresenter.updateListOfListsWith(dataManager.getAllLists())
  }
  
}
