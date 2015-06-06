//
//  IDFYDataManagerTest.swift
//  iDecide4U
//
//  Created by Dominic Frei on 02/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import XCTest
import UIKit
import CoreData

class IDFYDataManagerTest : IDFYTestBase {
  
//  class MockInitialAppSetupGenerator : IDFYInitialAppSetupGenerator {
//    @objc override class func generateInitialAppData() {
//      
//    }
//  }
  
  class MockAppDelegate : IDFYAppDelegate {
    @objc override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      IDFYInitialAppSetupGenerator.generateInitialAppData()
      return true
    }
  }
  
  let dataManager = IDFYDataManager()
  
  override func setUp() {
    super.setUp()
    IDFYCoreDataStack.sharedCoreDataStack().urlToDatabase = "MockiDecide4u.sqlite"
    UIApplication.sharedApplication().delegate = MockAppDelegate()
  }
  
  override func tearDown() {
    
    super.tearDown()
  }
  
  func test() {
    let fetchRequest = NSFetchRequest(entityName: IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName)
    var error: NSError?
    let fetchResult = IDFYCoreDataStack.sharedCoreDataStack().managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as! [IDFYManagedOptionList]
    if let error = error {
      IDFYLoggingUtilities.fatal("Error loading option list from data base: " + error.description)
      abort()
    }
    
    XCTAssert(!fetchResult.isEmpty, "fetchResult should not be empty!")
    XCTAssertEqual(fetchResult.count, 3, "The fetch result should contain five entries.")
    
//    let list1 = fetchResult[0]
    
  }
  
}
