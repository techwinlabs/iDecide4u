//
//  IDFYDataManager.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import CoreData

class IDFYDataManager {
  
  var currentList: IDFYOptionList?
  
  private let managedObjectContext = IDFYCoreDataStack.sharedCoreDataStack().managedObjectContext
  private var managedOptionListForCurrentList: IDFYManagedOptionList?
  
  func fetchEntity(entityName: String, fromManagedObjectContext managedObjectContext: NSManagedObjectContext, withPredicate predicate: NSPredicate?) -> [AnyObject]? {
    
    let fetchRequest = NSFetchRequest(entityName: entityName)
    fetchRequest.predicate = predicate
    var error: NSError?
    let fetchResult = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
    
    if let error = error {
      println("Error loading option list from data base: " + error.description)
      abort()
    }
    return fetchResult
    
  }
  
  func getCurrentList() -> IDFYOptionList {
    if nil == currentList {
      fetchListWithPredicate(nil)
      transferManagedOptionListDataToCurrentList()
    }
    return currentList!
  }
  
  func fetchListWithPredicate(predicate: NSPredicate?) {
    let fetchRequest = NSFetchRequest(entityName: IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName)
    fetchRequest.predicate = predicate
    var error: NSError?
    let fetchResult = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
    
    if let error = error {
      println("Error loading option list from data base: " + error.description)
    } else if let fetchResult = fetchResult where 0 < fetchResult.count {
      managedOptionListForCurrentList = fetchResult[0] as? IDFYManagedOptionList
    } else {
      managedOptionListForCurrentList = NSEntityDescription.insertNewObjectForEntityForName(IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName, inManagedObjectContext: managedObjectContext!) as? IDFYManagedOptionList
      managedOptionListForCurrentList!.name = ""
      managedOptionListForCurrentList!.options = [String]()
    }
  }
  
  func transferManagedOptionListDataToCurrentList() {
    currentList = IDFYOptionList()
    currentList!.name = managedOptionListForCurrentList!.name
    currentList!.options = managedOptionListForCurrentList!.options
  }
  
  func updateCurrentList(optionList: IDFYOptionList) {
    currentList = optionList
    managedOptionListForCurrentList?.name = currentList!.name
    managedOptionListForCurrentList?.options = currentList!.options
    IDFYCoreDataStack.sharedCoreDataStack().saveContext()
  }
  
}
