//
//  IDFYListOperationsPresenter.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import UIKit

class IDFYListOperationPresenter : UITableViewController, UITableViewDataSource, UITableViewDelegate, IDFYListOperationPresenterInterface {
  
  var listOperationWireframe : IDFYListOperationWireframe!
  var listOperationInteractor : IDFYListOperationInteractorInterface!
  var listOfLists: [IDFYOptionList]!
  
  
  // MARK: - Initialisation
  
  // Just to satisfy the compiler ..
  required init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
  }
  
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    listOperationWireframe = IDFYListOperationWireframe()
    listOperationWireframe.setupWiresForPresenter(self)
    listOperationInteractor.updateListOfLists()
  }
  
  
  // MARK: - IDFYListOperationPresenterInterface
  
  func updateListOfListsWith(listOfLists: [IDFYOptionList]) {
    self.listOfLists = listOfLists
  }
  
  
  // MARK: - UITableViewDataSource
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var title = ""
    switch (section) {
    case 0: title = ""
    case 1: title = "Load a saved list"
    default: break
    }
    return title
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfSections = 0
    switch (section) {
    case 0: numberOfSections = 2
    case 1: numberOfSections = listOfLists.count
    default: break
    }
    return numberOfSections
  }
  
  let tableViewCellIdentifier = "IDFYListOperationTabelViewCell"
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let tableViewCell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
    
    if 0 == indexPath.section {
      switch (indexPath.row) {
      case 0: tableViewCell.textLabel?.text = "Save the current list"
      case 1: tableViewCell.textLabel?.text = "Start a new list"
      default: break
      }
    }
    
    return tableViewCell
  }
  
}
