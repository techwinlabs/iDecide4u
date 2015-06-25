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
      IDFYLoggingUtilities.fatal("Error loading option list from data base: " + error.description)
      abort()
    }
    for managedOptionList : AnyObject in fetchResult! {
      managedObjectContext.deleteObject(managedOptionList as! IDFYManagedOptionList)
    }
  }
  
  func createMockDatabaseEntries() {
    
    let entityDescriptionForList1 = NSEntityDescription.entityForName("IDFYManagedOptionList", inManagedObjectContext: managedObjectContext!)
    var list1 = IDFYManagedOptionList(entity: entityDescriptionForList1!, insertIntoManagedObjectContext: managedObjectContext)
    list1.name = "Meals"
    list1.options = ["Burger", "Pizza", "Lasagne"]
    
    let entityDescriptionForList2 = NSEntityDescription.entityForName("IDFYManagedOptionList", inManagedObjectContext: managedObjectContext!)
    var list2 = IDFYManagedOptionList(entity: entityDescriptionForList2!, insertIntoManagedObjectContext: managedObjectContext)
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
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = NSBundle.mainBundle().URLForResource("iDecide4u", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    var error: NSError? = nil
    var failureReason = "There was an error creating or loading the application’s saved data."
    if coordinator!.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: &error) == nil {
      coordinator = nil
      let dict = NSMutableDictionary()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application’s saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      dict[NSUnderlyingErrorKey] = error
//      error = NSError.errorWithDomain("YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//      NSLog("Unresolved error (error), (error!.userInfo)")
      abort()
    }
    
    return coordinator
    }()
  
  lazy var managedObjectContext: NSManagedObjectContext! = {
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
    }()
  
}
