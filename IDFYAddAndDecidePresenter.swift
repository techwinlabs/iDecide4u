//
//  IDFYMainSceneViewController.swift
//  iDecide4U
//
//  Created by Dominic Frei on 25/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import UIKit

class IDFYAddAndDecidePresenter : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, IDFYAddAndDecidePresenterInterface {
  
  var addAndDecideWireframe : IDFYAddAndDecideWireframe!
  var addAndDecideInteractor: IDFYAddAndDecideInteractorInterface!
    var lastHighlightedCellIndex = -1 //variable for selected tableview cell

    @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textFieldAddNewOption: UITextField!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var textFieldTrailingSpaceContraint: NSLayoutConstraint!
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var trashButton: UIBarButtonItem!
  
  private var listName = ""
  private var listItems = [String]()
  private var textFieldListName = UITextField()
  private let tableViewCellIdentifier = "ItemCell"
  
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    addAndDecideWireframe = IDFYAddAndDecideWireframe()
    addAndDecideWireframe.setupWiresForPresenter(self)
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    addAndDecideInteractor.viewWillAppear()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    // Reload needs to be called here, even if nothing changed.
    // Problem: When it is for example called after updateNameWithGivenName, but before updateListWithGivenList, the app might crash, because a tableView:cellForRowAtIndexPath is invoked before the list was updated.
    tableView.reloadData()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  
  // MARK: - IBActions
  
  @IBAction func addButtonPressed(sender: UIButton) {
    addAndDecideInteractor.willAddNewOption(textFieldAddNewOption.text)
    textFieldAddNewOption.text = ""
    addButton.enabled = false
    IDFYLoggingUtilities.debug("Scrolling to row: \(listItems.count-1)")
    tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: listItems.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
  }
  
  @IBAction func decideButtonPressed(sender: UIBarButtonItem) {
    addAndDecideInteractor.willDecide()
  }
  
  @IBAction func trashButtonPressed(sender: UIBarButtonItem) {
    addAndDecideInteractor.willTrashList()
  }
  
  
  // MARK: - IDFYAddAndDecidePresenterInterface
  
  func updateNameWithGivenName(listName: String) {
    self.listName = listName
  }
  
  func updateListWithGivenList(list: [String]) {
    listItems = list
  }
  
    func presentDecision(option: String, selected: Int) {
        lastHighlightedCellIndex = selected
    let title = NSLocalizedString("main.scene_dicision.alert.title", comment: "title for a decision")
    let message = option
    let alertAction = UIAlertAction(title: NSLocalizedString("main.scene_dicision.alert.ok.button", comment: "button title for a dicision"), style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
    showAlertControllerWithTitle(title, andMessage: message, andAlertActions: [alertAction], andPreferredStyle: UIAlertControllerStyle.Alert, popoverSource: nil)
  }
  
  func decisionWithEmptyListInvoked() {
    let title = NSLocalizedString("main.scene_dicision.alert.no.items.title", comment: "title for a dicision without options")
    let message = "\n" + NSLocalizedString("main.scene_dicision.alert.no.items.message", comment: "message for a dicision without options") + "\n"
    let alertAction = UIAlertAction(title: NSLocalizedString("main.scene_dicision.alert.ok.button", comment: "button title for a dicision"), style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
    showAlertControllerWithTitle(title, andMessage: message, andAlertActions: [alertAction], andPreferredStyle: UIAlertControllerStyle.Alert, popoverSource: nil)
  }
  
  func askForTrashConfirmation() {
    let alertActionTrash = UIAlertAction(title: NSLocalizedString("main.scene_trash.alert.button.yes", comment: "yes button for trash alert"), style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
      self.addAndDecideInteractor.didConfirmTrashList()
    }
    let alertActionCancel = UIAlertAction(title: NSLocalizedString("main.scene_trash.alert.button.cancel", comment: "cancel button for trash alert"), style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
      
    }
    showAlertControllerWithTitle(NSLocalizedString("main.scene_trash.alert.title", comment: "title for trash alert"), andMessage: "", andAlertActions: [alertActionTrash, alertActionCancel], andPreferredStyle: UIAlertControllerStyle.ActionSheet, popoverSource: trashButton)
  }
  
  func didDeleteEntry(entry: String, atIndexPath indexPath: NSIndexPath) {
    IDFYLoggingUtilities.debug("entry: \(entry), indexPath: \(indexPath.row), size of list before delete: \(listItems.count)")
    IDFYLoggingUtilities.debug("numberOfRowsInSection: \(tableView.numberOfRowsInSection(0))")
    
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    
    IDFYLoggingUtilities.debug("numberOfRowsInSection: \(tableView.numberOfRowsInSection(0))")
    IDFYLoggingUtilities.debug("size of list after delete: \(listItems.count)")
  }
  
  func updateInterfaceWithNewData() {
    tableView.reloadData()
  }
  
  
  // MARK: - Convenience alert
  
  private func showAlertControllerWithTitle(title: String, andMessage message: String, andAlertActions alertActions: [UIAlertAction], andPreferredStyle preferredStyle: UIAlertControllerStyle, popoverSource: UIBarButtonItem?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    alertController.popoverPresentationController?.barButtonItem = popoverSource
    for alertAction in alertActions {
      alertController.addAction(alertAction)
    }
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1;
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return listName
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    IDFYLoggingUtilities.debug("listItems: \(listItems), listItems.count: \(listItems.count)")
    return listItems.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let tableViewCell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
    tableViewCell.textLabel?.text = listItems[indexPath.row]
    if lastHighlightedCellIndex == indexPath.row {
        tableViewCell.backgroundColor = UIColor(red: 173.0/255.0, green: 216.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        tableViewCell.accessoryType = .Checkmark
    }
    return tableViewCell
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if UITableViewCellEditingStyle.Delete == editingStyle {
      addAndDecideInteractor.willDeleteEntry(listItems[indexPath.row], atIndexPath: indexPath)
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
      addAndDecideInteractor.willAddNewOption(textFieldAddNewOption.text)
      textFieldAddNewOption.resignFirstResponder()
      if !textFieldAddNewOption.text.isEmpty {
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: listItems.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
      }
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
    let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
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
  
}
