//
//  IDFYMockGenerator.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import CoreData

private let managedObjectContext = IDFYCoreDataStack.sharedCoreDataStack().managedObjectContext!
private let optionListEntityName = IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName
private let lastUsedListName = "iDecide4u.lastUsedListName"

class IDFYMockGenerator {
  
  class func wipeOutDatabase() {
    let fetchRequest = NSFetchRequest(entityName: optionListEntityName)
    var error: NSError?
    let fetchResult = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [IDFYManagedOptionList]
    if let error = error {
      println("Error loading option list from data base: " + error.description)
      abort()
    }
    for managedOptionList : IDFYManagedOptionList in fetchResult {
      managedObjectContext.deleteObject(managedOptionList)
    }
    NSUserDefaults.standardUserDefaults().removeObjectForKey(lastUsedListName)
  }
  
  class func createMockDatabaseEntries() {
    
    let list1 = NSEntityDescription.insertNewObjectForEntityForName(IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName, inManagedObjectContext: managedObjectContext) as? IDFYManagedOptionList
    list1!.name = "meals"
    list1!.options = ["pizza", "lasagne", "vegetable gratin", "bread", "spinach and potatoes"]
    
    let list2 = NSEntityDescription.insertNewObjectForEntityForName(IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName, inManagedObjectContext: managedObjectContext) as? IDFYManagedOptionList
    list2!.name = "evening activities"
    list2!.options = ["cinema", "billard", "go for a meal"]
    
    let list3 = NSEntityDescription.insertNewObjectForEntityForName(IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName, inManagedObjectContext: managedObjectContext) as? IDFYManagedOptionList
    list3!.name = "vacation"
    list3!.options = ["Hawaii", "Bali", "Australia"]
    
//    NSUserDefaults.standardUserDefaults().setObject("", forKey: lastUsedListName)
  }
  
}