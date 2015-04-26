//
//  IDFYMainSceneViewController.swift
//  iDecide4U
//
//  Created by Dominic Frei on 25/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class IDFYAddAndDecideViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textFieldAddNewOption: UITextField!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var textFieldTrailingSpaceContraint: NSLayoutConstraint!
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  private var optionList: IDFYManagedOptionList!
  private var textFieldListName = UITextField()
  private var managedObjectContext = NSManagedObjectContext()
  
  private let optionListEntityName = "IDFYManagedOptionList"
  private let tableViewCellIdentifier = "ItemCell"
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
    managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    optionList = NSEntityDescription.insertNewObjectForEntityForName(optionListEntityName, inManagedObjectContext: managedObjectContext) as! IDFYManagedOptionList
    optionList.initialize()
    
    let fetchRequest = NSFetchRequest(entityName: optionListEntityName)
    var error: NSError?
    let fetchResult = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
    
    if let error = error {
      println("Error loading option list from data base: " + error.description)
    } else if let fetchResult = fetchResult where 0 < fetchResult.count {
      optionList = fetchResult[0] as! IDFYManagedOptionList
      tableView.reloadData()
      if 0 < optionList.count() {
        saveButton.enabled = true
      }
    }
    
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1;
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return optionList.name
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return optionList.count()
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let tableViewCell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
    tableViewCell.textLabel?.text = optionList.optionAtIndex(indexPath.row)
    return tableViewCell
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if UITableViewCellEditingStyle.Delete == editingStyle {
      optionList.removeOption(optionList.optionAtIndex(indexPath.row))
      if optionList.isEmpty() {
        saveButton.enabled = false
      }
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
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
      if 0 < textFieldAddNewOption.text.lengthOfBytesUsingEncoding(NSUTF16StringEncoding) {
        optionList.addOption(textFieldAddNewOption.text)
        saveButton.enabled = true
        tableView.reloadData()
      }
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
    let toolBarHeight = self.toolbar.frame.size.height;
    
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
    optionList.addOption(textFieldAddNewOption.text)
    saveButton.enabled = true
    tableView.reloadData()
    textFieldAddNewOption.text = ""
    addButton.enabled = false
    
    // We need to scroll to the new item so the user can see it.
    tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: optionList.count()-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
  }
  
  @IBAction func decideButtonPressed(sender: UIBarButtonItem) {
    var title = ""
    var message = ""
    
    if 0 < optionList.count() {
      
      let winningChoice = Int(rand()) % (optionList.count())
      title = NSLocalizedString("main.scene_dicision.alert.title", comment: "title for a decision")
      message = optionList.optionAtIndex(winningChoice)
      
    } else {
      
      title = NSLocalizedString("main.scene_dicision.alert.no.items.title", comment: "title for a dicision without options")
      message = "\n" + NSLocalizedString("main.scene_dicision.alert.no.items.message", comment: "message for a dicision without options") + "\n"
      
    }
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let alertAction = UIAlertAction(title: NSLocalizedString("main.scene_dicision.alert.ok.button", comment: "button title for a dicision"), style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
    alertController.addAction(alertAction)
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  @IBAction func trashButtonPressed(sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: NSLocalizedString("main.scene_trash.alert.title", comment: "title for trash alert"), message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
    alertController.popoverPresentationController?.barButtonItem = sender
    let alertActionTrash = UIAlertAction(title: NSLocalizedString("main.scene_trash.alert.button.yes", comment: "yes button for trash alert"), style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
      self.optionList.clearList()
      self.saveButton.enabled = false
      self.tableView.reloadData()
    }
    let alertActionCancel = UIAlertAction(title: NSLocalizedString("main.scene_trash.alert.button.cancel", comment: "cancel button for trash alert"), style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
      
    }
    alertController.addAction(alertActionTrash)
    alertController.addAction(alertActionCancel)
    self.presentViewController(alertController, animated: true) { () -> Void in }
  }
  
  @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: NSLocalizedString("main.scene_save.alert.title", comment: "title for save alert"), message: NSLocalizedString("main.scene_save.alert.message", comment: "message for trash alert"), preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
      self.textFieldListName = textField
      textField.delegate = self
      textField.text = self.optionList.name
    }
    let alertActionSave = UIAlertAction(title: NSLocalizedString("main.scene_save.alert.button.save", comment: "save button for save alert"), style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
      self.optionList.name = self.textFieldListName.text
      self.tableView.reloadData()
    }
    let alertActionCancel = UIAlertAction(title: NSLocalizedString("main.scene_save.alert.button.cancel", comment: "cancel button for save alert"), style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
      
    }
    alertController.addAction(alertActionSave)
    alertController.addAction(alertActionCancel)
    self.presentViewController(alertController, animated: true) { () -> Void in }
  }
  
}
