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
  private var indexOfCurrentlyActiveList : NSInteger?
  
  
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
  
  func updateListOfListsWith(listOfLists: [IDFYOptionList], withCurrentlyActiveList indexOfCurrentlyActiveList: NSInteger) {
    self.listOfLists = listOfLists
    self.indexOfCurrentlyActiveList = indexOfCurrentlyActiveList
  }
  
  func askForListNameWithPredefinedListName(listName: String, shouldShowDiscardDraftOption: Bool) {
    let alertController = UIAlertController(title: NSLocalizedString("main.scene_save.alert.title", comment: "title for save alert"), message: NSLocalizedString("main.scene_save.alert.message", comment: "message for trash alert"), preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
      textField.delegate = self
      textField.text = listName
      self.textFieldNewListName = textField
    }
    
    let alertActionSave = UIAlertAction(title: NSLocalizedString("main.scene_save.alert.button.save", comment: "save button for save alert"), style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
      self.listOperationInteractor.didProvideNewListName(self.textFieldNewListName!.text)
    }
    alertController.addAction(alertActionSave)
    
    let alertActionCancel = UIAlertAction(title: NSLocalizedString("main.scene_save.alert.button.cancel", comment: "cancel button for save alert"), style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
    }
    alertController.addAction(alertActionCancel)
    
    if shouldShowDiscardDraftOption {
      let alertActionDiscardDraft = UIAlertAction(title: NSLocalizedString("list_operation_scene.save_new_list_dialog.discard_draft_button_title", comment: "discard draft option button"), style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
        self.listOperationInteractor.willDiscardDraft()
      })
      alertController.addAction(alertActionDiscardDraft)
    }
    
    self.presentViewController(alertController, animated: true) { () -> Void in }
  }
  
  func showCurrentList() {
    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func didDeleteList(listName: String, atIndexPath indexPath: NSIndexPath) {
    if 0 < listOfLists.count {
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    } else {
      tableView.deleteSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Fade)
    }
  }
  
  
  // MARK: - UITableViewDataSource
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if 0 < listOfLists.count {
      return 2
    } else {
      return 1
    }
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var title = ""
    switch (section) {
    case 0: title = ""
    case 1: title = NSLocalizedString("list_operation_scene.list_of_lists_section.header_title", comment: "section header title for list of lists")
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
      case 0: tableViewCell.textLabel?.text = NSLocalizedString("list_operation_scene.start_new_list_cell.text_label", comment: "label for start a new list cell")
      case 1: tableViewCell.textLabel?.text = NSLocalizedString("list_operation_scene.save_current_list_cell.text_label", comment: "label for save or rename the current list cell")
      default: break
      }
    } else if 1 == indexPath.section {
      tableViewCell.textLabel?.text = listOfLists[indexPath.row].name
      if let indexOfCurrentlyActiveList = self.indexOfCurrentlyActiveList {
        if indexPath.row == indexOfCurrentlyActiveList {
          tableViewCell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
      }
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
        listOperationInteractor.willStartNewList()
      case 1:
        listOperationInteractor.willSetNameForCurrentList()
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
