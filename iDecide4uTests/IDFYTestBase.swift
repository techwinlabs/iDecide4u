//
//  IDFYTestBase.swift
//  iDecide4U
//
//  Created by Dominic Frei on 02/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import UIKit
import XCTest
import CoreData
import iDecide4u

class IDFYTestBase: XCTestCase {
  
  let managedObjectContext = IDFYCoreDataStack.sharedCoreDataStack().managedObjectContext!
  let optionListEntityName = IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName
  
  override func setUp() {
    super.setUp()
    wipeOutDatabase()
    createMockDatabaseEntries()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func wipeOutDatabase() {
    let fetchRequest = NSFetchRequest(entityName: optionListEntityName)
    var error: NSError?
    let fetchResult : NSArray? = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [IDFYManagedOptionList]
    if let error = error {
      println("Error loading option list from data base: " + error.description)
      abort()
    }
    for managedOptionList : AnyObject in fetchResult! {
      managedObjectContext.deleteObject(managedOptionList as! IDFYManagedOptionList)
    }
  }
  
  func createMockDatabaseEntries() {
    NSEntityDescription.insertNewObjectForEntityForName(IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName, inManagedObjectContext: managedObjectContext) as! IDFYManagedOptionList
    let list1 = NSEntityDescription.insertNewObjectForEntityForName(IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName, inManagedObjectContext: managedObjectContext) as! IDFYManagedOptionList
    list1.name = "Meals"
    list1.options = ["Burger", "Pizza", "Lasagne"]
    let list2 = NSEntityDescription.insertNewObjectForEntityForName(IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName, inManagedObjectContext: managedObjectContext) as! IDFYManagedOptionList
    list2.name = "Evening events"
    list2.options = ["cinema", "billard", "going out"]
    NSUserDefaults.standardUserDefaults().setObject(list1.name, forKey: "iDecide4u.lastUsedListName")
  }
  
  func testExample() {
    // This is an example of a functional test case.
    XCTAssert(true, "Pass")
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock() {
      // Put the code you want to measure the time of here.
    }
  }
  
}
