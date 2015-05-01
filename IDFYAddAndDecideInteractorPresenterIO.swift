//
//  IDFYAddAndDecideInteractorIO.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

protocol IDFYAddAndDecideInteractorInput {
  func addNewEntry(entry: String)
  func deleteEntry(entry: String)
  func decide()
  func deleteAllEntries()
  func saveListWithName(name: String)
  func currentListName() -> String // is there a better way instead of a return value?
  func getInitialList()
}

protocol IDFYAddAndDecideInteractorOutput {
  func updateNameWithGivenName(listName: String)
  func updateListWithGivenList(list: [String])
  func presentDecision(option: String)
  func showNoOptionsWarning()
}
