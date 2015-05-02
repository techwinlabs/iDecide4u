//
//  IDFYAddAndDecideInteractorIO.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

protocol IDFYAddAndDecideInteractorInterface {
  func addNewEntry(entry: String)
  func deleteEntry(entry: String)
  func decide()
  func deleteAllEntries()
  func viewWillAppear()
}

protocol IDFYAddAndDecidePresenterInterface {
  func updateNameWithGivenName(listName: String)
  func updateListWithGivenList(list: [String])
  func presentDecision(option: String)
  func decisionWithEmptyListInvoked()
}
