//
//  IDFYListOperationsPresenter.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import UIKit

class IDFYListOperationPresenter : UITableViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, IDFYListOperationPresenterInterface {
    
  var listOperationWireframe : IDFYListOperationWireframe!
  var listOperationInteractor : IDFYListOperationInteractorInterface!
  
  private var listOfLists: [IDFYOptionList]!
  private var textFieldNewListName : UITextField?
  
  
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
  
  func askForListNameWithPredefinedListName(listName: String) {
    let alertController = UIAlertController(title: NSLocalizedString("main.scene_save.alert.title", comment: "title for save alert"), message: NSLocalizedString("main.scene_save.alert.message", comment: "message for trash alert"), preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
      textField.delegate = self
      textField.text = listName
      self.textFieldNewListName = textField
    }
    let alertActionSave = UIAlertAction(title: NSLocalizedString("main.scene_save.alert.button.save", comment: "save button for save alert"), style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
      self.listOperationInteractor.didProvideNewListName(self.textFieldNewListName!.text)
    }
    let alertActionCancel = UIAlertAction(title: NSLocalizedString("main.scene_save.alert.button.cancel", comment: "cancel button for save alert"), style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
    }
    alertController.addAction(alertActionSave)
    alertController.addAction(alertActionCancel)
    self.presentViewController(alertController, animated: true) { () -> Void in }
  }
  
  func showCurrentList() {
    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func didDeleteList(listName: String, atIndexPath indexPath: NSIndexPath) {
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
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
      case 0: tableViewCell.textLabel?.text = "Save / rename the current list"
      case 1: tableViewCell.textLabel?.text = "Start a new list"
      default: break
      }
    } else if 1 == indexPath.section {
      tableViewCell.textLabel?.text = listOfLists[indexPath.row].name
    }
    
    return tableViewCell
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if UITableViewCellEditingStyle.Delete == editingStyle {
      listOperationInteractor.willDeleteList(listOfLists[indexPath.row].name, atIndexPath:indexPath)
    }
  }
  
  
  // MARK: - UITabelViewDelegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if 0 == indexPath.section {
      switch (indexPath.row) {
      case 0:
        listOperationInteractor.willSetNameForCurrentList()
      case 1:
        listOperationInteractor.willStartNewList()
      default:
        break
      }
    } else if 1 == indexPath.section {
      listOperationInteractor.willLoadSavedList(listOfLists[indexPath.row].name)
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

  
  // MARK: - Segues
  
  @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
}
