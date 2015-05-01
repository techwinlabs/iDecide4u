//
//  IDFYCommonDataManager.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import CoreData

class IDFYCommonDataManager {
  
  class func fetchEntity(entityName: String, fromManagedObjectContext managedObjectContext: NSManagedObjectContext, withPredicate predicate: NSPredicate?) -> [AnyObject]? {
    let fetchRequest = NSFetchRequest(entityName: IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName)
    fetchRequest.predicate = predicate
    var error: NSError?
    let fetchResult = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
    
    if let error = error {
      println("Error loading option list from data base: " + error.description)
      abort()
    }
    return fetchResult
  }
  
}
