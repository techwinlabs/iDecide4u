//
//  IDFYAddAndDecideViewInterface.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

protocol IDFYAddAndDecideViewInterface {
  func updateListName(listName: String)
  func updateList(list: [String])
  func showDecisionWithTitle(title: String, andMessage message: String)
  func askForNewListNameWithPredefinedListName(listName: String)
  func reloadView()
}
