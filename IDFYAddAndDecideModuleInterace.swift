//
//  IDFYAddAndDecideModuleInterace.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

protocol IDFYAddAndDecideModuleInterface {
  func updateView()
  func didAddNewEntryWithName(entryName: String)
  func didDeleteEntryWithName(entryName: String)
  func didRequestDecision()
  func didDeleteAllEntries()
  func didRequestSaveList()
  func didProvideNewListName(listName: String)
  func loadInitialUI()
}
