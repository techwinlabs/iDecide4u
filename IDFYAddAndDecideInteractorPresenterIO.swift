//
//  IDFYAddAndDecideInteractorIO.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

protocol IDFYAddAndDecidePresenterInterface {
  func updateNameWithGivenName(listName: String)
  func updateListWithGivenList(list: [String])
  func presentDecision(option: String)
  func decisionWithEmptyListInvoked()
  func askForTrashConfirmation()
  func didDeleteEntry(entry: String, atIndexPath: NSIndexPath)
  func updateInterfaceWithNewData()
}

protocol IDFYAddAndDecideInteractorInterface {
  func viewWillAppear()
  func willAddNewOption(option: String)
  func willDecide()
  func willDeleteEntry(entry: String, atIndexPath indexPath: NSIndexPath)
  func willTrashList()
  func didConfirmTrashList()
}
