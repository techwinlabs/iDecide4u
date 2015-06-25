//
//  IDFYAddAndDecideInteractor.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

class IDFYAddAndDecideInteractor: NSObject, IDFYAddAndDecideInteractorInterface {
  
  var addAndDecidePresenter : IDFYAddAndDecidePresenterInterface!
  var dataManager : IDFYDataManagerInterface!
  
  
  // MARK: - IDFYAddAndDecideInteractorInterface

  func viewWillAppear() {
    // Check if there is a last used list saved. If so, retrieve that list.
    let list = dataManager.getCurrentList()
    addAndDecidePresenter.updateNameWithGivenName(list.name)
    addAndDecidePresenter.updateListWithGivenList(list.options)
  }
  
  func willAddNewOption(option: String) {
    let entryWithoutWhiteSpaces = option.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
    if !entryWithoutWhiteSpaces.isEmpty {
      let list = dataManager.getCurrentList()
      list.addOption(option)
      dataManager.updateCurrentList(list)
      addAndDecidePresenter.updateListWithGivenList(list.options)
      addAndDecidePresenter.updateInterfaceWithNewData()
    }
  }
  
  func willDecide() {
    let list = dataManager.getCurrentList()
    if 0 < list.count() {
      let winningChoice = Int(rand()) % (list.count())
      let winner = list.optionAtIndex(winningChoice)
      addAndDecidePresenter.presentDecision(winner,selected: winningChoice)
    } else {
      addAndDecidePresenter.decisionWithEmptyListInvoked()
    }
  }
  
  func willDeleteEntry(entry: String, atIndexPath indexPath: NSIndexPath) {
    let list = dataManager.getCurrentList()
    list.removeOption(entry)
    dataManager.updateCurrentList(list)
    addAndDecidePresenter.updateListWithGivenList(list.options)
    addAndDecidePresenter.didDeleteEntry(entry, atIndexPath: indexPath)
  }
  
  func willTrashList() {
    addAndDecidePresenter.askForTrashConfirmation()
  }
  
  func didConfirmTrashList() {
    let list = dataManager.getCurrentList()
    list.clearList()
    dataManager.updateCurrentList(list)
    addAndDecidePresenter.updateListWithGivenList([String]())
    addAndDecidePresenter.updateInterfaceWithNewData()
  }
  
}
