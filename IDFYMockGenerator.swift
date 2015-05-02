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
  
  class func generateMockIntoDatabase() {
    wipeOutDatabase()
    createMockDatabaseEntries()
  }
  
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
    list1!.name = "Meals"
    list1!.options = ["Burger", "Pizza", "Lasagne"]
    let list2 = NSEntityDescription.insertNewObjectForEntityForName(IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName, inManagedObjectContext: managedObjectContext) as? IDFYManagedOptionList
    list2!.name = "Evening events"
    list2!.options = ["cinema", "billard", "going out"]
    NSUserDefaults.standardUserDefaults().setObject(list1?.name, forKey: lastUsedListName)
  }
  
}
