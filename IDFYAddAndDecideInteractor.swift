//
//  IDFYAddAndDecideInteractor.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

class IDFYAddAndDecideInteractor: NSObject, IDFYAddAndDecideInteractorInput {
  
  var addAndDecidePresenter: IDFYAddAndDecideInteractorOutput!
  var dataManager = IDFYAddAndDecideDataManager()
  var optionList: IDFYOptionList!
  var lastUsedListNameKey = "iDecide4u.lastUserListName"
  
  init(presenter: IDFYAddAndDecidePresenter) {
    addAndDecidePresenter = presenter
  }
  
  func addNewEntry(entry: String) {
    let entryWithoutWhiteSpaces = entry.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
    println(entryWithoutWhiteSpaces)
    if !entryWithoutWhiteSpaces.isEmpty {
      optionList.addOption(entry)
      dataManager.updateCurrentList(optionList)
    }
    addAndDecidePresenter.updateListWithGivenList(optionList.options)
  }
  
  func deleteEntry(entry: String) {
    optionList.removeOption(entry)
    dataManager.updateCurrentList(optionList)
    addAndDecidePresenter.updateListWithGivenList(optionList.options)
  }
  
  func decide() {
    if 0 < optionList.count() {
      let winningChoice = Int(rand()) % (optionList.count())
      let winner = optionList.optionAtIndex(winningChoice)
      addAndDecidePresenter.presentDecision(winner)
    } else {
      addAndDecidePresenter.showNoOptionsWarning()
    }
  }
  
  func deleteAllEntries() {
    optionList.clearList()
    dataManager.updateCurrentList(optionList)
    addAndDecidePresenter.updateListWithGivenList([String]())
  }
  
  func saveListWithName(name: String) {
    optionList.name = name
    dataManager.updateCurrentList(optionList)
    addAndDecidePresenter.updateNameWithGivenName(name)
  }
  
  func currentListName() -> String { // is there a better way instead of a return value?
    return optionList.name
  }
  
  func currentList() -> [String] {
    return optionList.options
  }
  
  func getInitialList() {
    let lastUsedListName = getLastUsedListName()
    // Check if there is a last used list saved. If so, retrieve that list.
    if let lastUsedListName = lastUsedListName {
      optionList = dataManager.getListWithName(lastUsedListName)
    } else {
      // If not, generate a new list.
      optionList = dataManager.getCurrentList() // Which will generate a new list => might not be the perfect process.
    }
    addAndDecidePresenter.updateNameWithGivenName(optionList.name)
    addAndDecidePresenter.updateListWithGivenList(optionList.options)
  }
  
  func getLastUsedListName() -> String? {
    return NSUserDefaults.standardUserDefaults().stringForKey(lastUsedListNameKey)
  }
  
  func setLastUsedListName(listName: String) {
    NSUserDefaults.standardUserDefaults().setObject(optionList.name, forKey: lastUsedListNameKey)
  }
  
}
