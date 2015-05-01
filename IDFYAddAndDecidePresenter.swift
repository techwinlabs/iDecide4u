//
//  IDFYAddAndDecidePresenter.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

class IDFYAddAndDecidePresenter: NSObject, IDFYAddAndDecideModuleInterface, IDFYAddAndDecideInteractorOutput {
  
  var addAndDecideViewInterface: IDFYAddAndDecideViewInterface!
  var addAndDecideInteractor: IDFYAddAndDecideInteractorInput!
  
  
  // MARK: - Initialisation
  
  init(viewInterface: IDFYAddAndDecideViewInterface) {
    addAndDecideViewInterface = viewInterface
    super.init()
    addAndDecideInteractor = IDFYAddAndDecideInteractor(presenter: self)
  }
  
  
  // MARK: - IDFYAddAndDecideModuleInterface
  
  func updateView() {
    
  }
  
  func didAddNewEntryWithName(entryName: String) {
    addAndDecideInteractor.addNewEntry(entryName)
  }
  
  func didDeleteEntryWithName(entryName: String) {
    addAndDecideInteractor.deleteEntry(entryName)
  }
  
  func didRequestDecision() {
    addAndDecideInteractor.decide()
  }
  
  func didDeleteAllEntries() {
    addAndDecideInteractor.deleteAllEntries()
  }
  
  func didRequestSaveList() {
    addAndDecideViewInterface.askForNewListNameWithPredefinedListName(addAndDecideInteractor.currentListName())
  }
  
  func didProvideNewListName(listName: String) {
    addAndDecideInteractor.saveListWithName(listName)
  }
  
  func loadInitialUI() {
    addAndDecideInteractor.getInitialList()
  }
  
  
  // MARK: - IDFYAddAndDecideInteractorOutput
  
  func updateNameWithGivenName(listName: String) {
    addAndDecideViewInterface.updateListName(listName)
  }
  
  func updateListWithGivenList(list: [String]) {
    addAndDecideViewInterface.updateList(list)
    addAndDecideViewInterface.reloadView()
  }
  
  func presentDecision(option: String) {
    var title = NSLocalizedString("main.scene_dicision.alert.title", comment: "title for a decision")
    var message = option
    addAndDecideViewInterface.showDecisionWithTitle(title, andMessage: message)
  }
  
  func showNoOptionsWarning() {
    var title = NSLocalizedString("main.scene_dicision.alert.no.items.title", comment: "title for a dicision without options")
    var message = "\n" + NSLocalizedString("main.scene_dicision.alert.no.items.message", comment: "message for a dicision without options") + "\n"
    addAndDecideViewInterface.showDecisionWithTitle(title, andMessage: message)
  }
  
}
