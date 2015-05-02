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
  
  func addNewEntry(entry: String) {
    let entryWithoutWhiteSpaces = entry.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
    if !entryWithoutWhiteSpaces.isEmpty {
      let list = dataManager.getCurrentList()
      list.addOption(entry)
      dataManager.updateCurrentList(list)
      addAndDecidePresenter.updateListWithGivenList(list.options)
    }
  }
  
  func deleteEntry(entry: String) {
    dataManager.getCurrentList().removeOption(entry)
  }
  
  func decide() {
    let list = dataManager.getCurrentList()
    if 0 < list.count() {
      let winningChoice = Int(rand()) % (list.count())
      let winner = list.optionAtIndex(winningChoice)
      addAndDecidePresenter.presentDecision(winner)
    } else {
      addAndDecidePresenter.decisionWithEmptyListInvoked()
    }
  }
  
  func deleteAllEntries() {
    dataManager.getCurrentList().clearList()
    addAndDecidePresenter.updateListWithGivenList([String]())
  }
  
  func viewWillAppear() {
    // Check if there is a last used list saved. If so, retrieve that list.
    let list = dataManager.getCurrentList()
    addAndDecidePresenter.updateNameWithGivenName(list.name)
    addAndDecidePresenter.updateListWithGivenList(list.options)
  }
  
}
