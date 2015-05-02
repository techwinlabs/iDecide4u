//
//  IDFYDataManagerTest.swift
//  iDecide4U
//
//  Created by Dominic Frei on 02/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import UIKit
import XCTest
import CoreData

class IDFYDataManagerTest: IDFYTestBase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test() {
    let fetchRequest = NSFetchRequest(entityName: optionListEntityName)
    var error: NSError?
    let fetchResult = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [IDFYManagedOptionList]
    if let error = error {
      println("Error loading option list from data base: " + error.description)
      abort()
    }
    XCTAssert(!fetchResult.isEmpty, "fetchResult should not be empty!")
    XCTAssertEqual(fetchResult.count, 2, "There should be two entries in fetchResult!")
    XCTAssertFalse(fetchResult.count > 2, "The fetchResult should not have more than two entries.")
  }
  
}
