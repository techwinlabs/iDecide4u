//
//  IDFYMainSceneViewController.swift
//  iDecide4U
//
//  Created by Dominic Frei on 25/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import UIKit

class IDFYAddAndDecideViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, IDFYAddAndDecideViewInterface {
  
  var addAndDecidePresenter: IDFYAddAndDecideModuleInterface!
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textFieldAddNewOption: UITextField!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var textFieldTrailingSpaceContraint: NSLayoutConstraint!
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  private var listName = ""
  private var listItems = [String]()
  
  private var textFieldListName = UITextField()
  
  private let optionListEntityName = "IDFYManagedOptionList"
  private let tableViewCellIdentifier = "ItemCell"
  
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    addAndDecidePresenter = IDFYAddAndDecidePresenter(viewInterface: self)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    addAndDecidePresenter.loadInitialUI()
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1;
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return listName
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listItems.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let tableViewCell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
    tableViewCell.textLabel?.text = listItems[indexPath.row]
    return tableViewCell
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if UITableViewCellEditingStyle.Delete == editingStyle {
      addAndDecidePresenter.didDeleteEntryWithName(listItems[indexPath.row])
    }
  }
  
  
  // MARK: - UITextFieldDelegate
  
  // When the user clicks into the text field, the add button needs to appear.
  // This is done here with an animated constraint change.
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    if textField == textFieldAddNewOption {
      // The Apple documentation recommends to call layoutIfNeeded at the beginning, just to make sure, the layout is up to date.
      view.layoutIfNeeded()
      textFieldTrailingSpaceContraint.constant = 42;
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.view.layoutIfNeeded()
      }, completion: { (Bool) -> Void in
        self.addButton.hidden = false
      })
    }
    return true
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if textField == textFieldAddNewOption {
      let newTextFieldContent = (textFieldAddNewOption.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
      if "" == newTextFieldContent {
        self.addButton.enabled = false
      } else {
        self.addButton.enabled = true
      }
    }
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == textFieldAddNewOption {
      addAndDecidePresenter.didAddNewEntryWithName(textFieldAddNewOption.text)
      textFieldAddNewOption.resignFirstResponder()
    }
    return true
  }
  
  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    if textField == textFieldAddNewOption {
      // The Apple documentation recommends to call layoutIfNeeded at the beginning, just to make sure, the layout is up to date.
      view.layoutIfNeeded()
      textFieldAddNewOption.text = ""
      textFieldTrailingSpaceContraint.constant = 12
      addButton.hidden = true
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.textFieldAddNewOption.layoutIfNeeded()
      })
    }
    return true
  }
  
  
  // MARK: - Keyboard notification selectors
  
  // When the keyboard is shown we need to shrink the table view so it does not get hidden by the keyboard.
  func keyboardDidShow(notification: NSNotification) {
    let userInfo = notification.userInfo!
    let keyboardFrame = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
    let keyboardRect = keyboardFrame.CGRectValue()
    
    let keyboardHeight = keyboardRect.size.height;
    let toolBarHeight = toolbar.frame.size.height;
    
    tableViewBottomConstraint.constant = keyboardHeight - toolBarHeight;
  }
  
  
  // When the keyboard will be hidden we need to exapand the table view to it's original size.
  func keyboardWillHide(notification: NSNotification) {
    let userInfo = notification.userInfo!
    let keyboardAnimationDurationAsValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSValue
    let timeIntervalKeyboardAnimationDuration = keyboardAnimationDurationAsValue as! NSTimeInterval
    
    UIView.animateWithDuration(timeIntervalKeyboardAnimationDuration, animations: { () -> Void in
      self.tableViewBottomConstraint.constant = -self.toolbar.frame.size.height
      }, completion: { (Bool) -> Void in
        self.tableViewBottomConstraint.constant = 0;
    })
  }
  
  
  // MARK: - IBActions
  
  @IBAction func addButtonPressed(sender: UIButton) {
    addAndDecidePresenter.didAddNewEntryWithName(textFieldAddNewOption.text)
    textFieldAddNewOption.text = ""
    addButton.enabled = false

    // We need to scroll to the new item so the user can see it.
//    tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: listItems.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
  }
  
  @IBAction func decideButtonPressed(sender: UIBarButtonItem) {
    addAndDecidePresenter.didRequestDecision()
  }
  
  @IBAction func trashButtonPressed(sender: UIBarButtonItem) {
    let alertActionTrash = UIAlertAction(title: NSLocalizedString("main.scene_trash.alert.button.yes", comment: "yes button for trash alert"), style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
      self.addAndDecidePresenter.didDeleteAllEntries()
    }
    let alertActionCancel = UIAlertAction(title: NSLocalizedString("main.scene_trash.alert.button.cancel", comment: "cancel button for trash alert"), style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
      
    }
    showAlertControllerWithTitle(NSLocalizedString("main.scene_trash.alert.title", comment: "title for trash alert"), andMessage: "", andAlertActions: [alertActionTrash, alertActionCancel], andPreferredStyle: UIAlertControllerStyle.ActionSheet, popoverSource: sender)
  }
  
  @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: NSLocalizedString("main.scene_save.alert.title", comment: "title for save alert"), message: NSLocalizedString("main.scene_save.alert.message", comment: "message for trash alert"), preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
      self.textFieldListName = textField
      textField.delegate = self
      textField.text = self.listName
    }
    let alertActionSave = UIAlertAction(title: NSLocalizedString("main.scene_save.alert.button.save", comment: "save button for save alert"), style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
      self.addAndDecidePresenter.didProvideNewListName(self.textFieldListName.text)
    }
    let alertActionCancel = UIAlertAction(title: NSLocalizedString("main.scene_save.alert.button.cancel", comment: "cancel button for save alert"), style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
      
    }
    alertController.addAction(alertActionSave)
    alertController.addAction(alertActionCancel)
    self.presentViewController(alertController, animated: true) { () -> Void in }
  }
  
  
  // MARK: - Convenience alert
  
  func showAlertControllerWithTitle(title: String, andMessage message: String, andAlertActions alertActions: [UIAlertAction], andPreferredStyle preferredStyle: UIAlertControllerStyle, popoverSource: UIBarButtonItem?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    alertController.popoverPresentationController?.barButtonItem = popoverSource
    for alertAction in alertActions {
      alertController.addAction(alertAction)
    }
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  
  // MARK: - IDFYAddAndDecideViewInterface
  
  func updateListName(listName: String) {
    self.listName = listName
    tableView.reloadData()
  }
  
  func updateList(list: [String]) {
    listItems = list
  }
  
  func showDecisionWithTitle(title: String, andMessage message: String) {
    let alertAction = UIAlertAction(title: NSLocalizedString("main.scene_dicision.alert.ok.button", comment: "button title for a dicision"), style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
    showAlertControllerWithTitle(title, andMessage: message, andAlertActions: [alertAction], andPreferredStyle: UIAlertControllerStyle.Alert, popoverSource: nil)
  }
  
  func askForNewListNameWithPredefinedListName(listName: String) {
    
  }
  
  func reloadView() {
    tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
  }
  
  func setSaveEnabled(enabled: Bool) {
    saveButton.enabled = enabled
  }
  
}
