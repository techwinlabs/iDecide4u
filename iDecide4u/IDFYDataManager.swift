//
//  IDFYDataManager.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import CoreData

class IDFYDataManager : IDFYDataManagerInterface {
  
  private let managedObjectContext = IDFYCoreDataStack.sharedCoreDataStack().managedObjectContext
  private let managedOptionListEntityName : String = NSStringFromClass(IDFYManagedOptionList).componentsSeparatedByString(".").last!
  
  
  // MARK: - IDFYDataManagerInterface
  
  func getCurrentList() -> IDFYOptionList {
    
    var optionList : IDFYOptionList = IDFYOptionList()
    
    if let lastUsedListName = IDFYUserDefaultsUtility.getLastUsedListName() {
      let listOfLastUsedManagedOptionLists = fetchManagedOptionListWithName(lastUsedListName)
      if 0 < listOfLastUsedManagedOptionLists.count {
        let managedOptionList : IDFYManagedOptionList = listOfLastUsedManagedOptionLists[0]
        optionList = IDFYOptionList(name: managedOptionList.name, options: managedOptionList.options)
      }
    } else {
      let entityDescriptionForNewList = NSEntityDescription.entityForName(managedOptionListEntityName, inManagedObjectContext: managedObjectContext!)
      var managedOptionList = IDFYManagedOptionList(entity: entityDescriptionForNewList!, insertIntoManagedObjectContext: managedObjectContext)
      managedOptionList.name = ""
      managedOptionList.options = [String]()
      // A new list need to be returned, which was already set at the beginnig of this function. But it's name needs to be saved still.
      IDFYUserDefaultsUtility.setLastUsedListName("")
    }
    
    return optionList
  }
  
  func getAllLists() -> [IDFYOptionList] {
    let listOfManagedOptionLists = fetchManagedOptionListWithPredicate(NSPredicate(format: "name != ''"))
    var listOfOptionLists = [IDFYOptionList]()
    for managedOptionList : IDFYManagedOptionList in listOfManagedOptionLists {
      listOfOptionLists.append(IDFYOptionList(name: managedOptionList.name, options: managedOptionList.options))
    }
    return listOfOptionLists
  }
  
  func updateCurrentList(list: IDFYOptionList) {
    let fetchResult : [IDFYManagedOptionList] = fetchManagedOptionListWithName(IDFYUserDefaultsUtility.getLastUsedListName()!)
    if 0 < fetchResult.count {
      let managedOptionList = fetchResult[0]
      managedOptionList.name = list.name
      managedOptionList.options = list.options
      IDFYCoreDataStack.sharedCoreDataStack().saveContext()
      IDFYUserDefaultsUtility.setLastUsedListName(list.name)
    } else {
      IDFYLoggingUtilities.log("Error while updating the list! Must not happen!")
    }
  }
  
  func startNewList() {
    var fetchResult : [IDFYManagedOptionList] = fetchManagedOptionListWithName("")
    var managedOptionList : IDFYManagedOptionList
    if 0 < fetchResult.count {
      managedOptionList = fetchResult[0]
    } else {
      managedOptionList = NSEntityDescription.insertNewObjectForEntityForName(managedOptionListEntityName, inManagedObjectContext:managedObjectContext!) as! IDFYManagedOptionList
      managedOptionList.name = ""
    }
    managedOptionList.options = [String]()
    IDFYUserDefaultsUtility.setLastUsedListName("")
  }
  
  func loadListWithName(listName: String) {
    IDFYUserDefaultsUtility.setLastUsedListName(listName)
  }
  
  
  // MARK: - Private methods
  
  private func fetchManagedOptionListWithName(listName: String) -> [IDFYManagedOptionList] {
    return fetchManagedOptionListWithPredicate(NSPredicate(format: "name == '" + listName + "'"))
  }
  
  private func fetchManagedOptionListWithPredicate(predicate: NSPredicate?) -> [IDFYManagedOptionList] {
    return fetchEntity(IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName, fromManagedObjectContext: managedObjectContext!, withPredicate: predicate) as! [IDFYManagedOptionList]
  }
  
  private func fetchEntity(entityName: String, fromManagedObjectContext managedObjectContext: NSManagedObjectContext, withPredicate predicate: NSPredicate?) -> [AnyObject] {
    
    let fetchRequest = NSFetchRequest(entityName: entityName)
    fetchRequest.predicate = predicate
    var error: NSError?
    let fetchResult = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
    
    if let error = error {
      IDFYLoggingUtilities.log("Error loading option list from data base: " + error.description)
    }
    
    return fetchResult!
  }
  
}
