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
  
  
  // MARK: - IDFYListOperationInteractorInterface
  
  func getNameForCurrentList() -> String {
    return dataManager.getCurrentList().name
  }
  
  func setNewNameForCurrentList(listName: String) {
    let list = dataManager.getCurrentList()
    list.name = listName
    dataManager.updateCurrentList(list)
  }
  
  func updateListOfLists() {
    listOperationPresenter.updateListOfListsWith(dataManager.getAllLists())
  }
  
  func startNewList() {
    dataManager.startNewList()
  }
  
}
