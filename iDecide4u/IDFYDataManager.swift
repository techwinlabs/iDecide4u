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
  
  let lastUsedListNameKey = "iDecide4u.lastUsedListName"
  
  private let managedObjectContext = IDFYCoreDataStack.sharedCoreDataStack().managedObjectContext
  private let managedOptionListEntityName : String = NSStringFromClass(IDFYManagedOptionList).componentsSeparatedByString(".").last!
  
  
  // MARK: - IDFYDataManagerInterface
  
  func getCurrentList() -> IDFYOptionList {
    
    if let lastUsedListName = getLastUsedListName() {
      let listOfLastUsedManagedOptionLists = fetchManagedOptionListWithName(lastUsedListName)
      if 0 < listOfLastUsedManagedOptionLists.count {
        let managedOptionList : IDFYManagedOptionList = listOfLastUsedManagedOptionLists[0]
        return IDFYOptionList(name: managedOptionList.name, options: managedOptionList.options)
      } else {
        // This case must not be possible. If it is, further investigation is needed.
        abort()
      }
    } else {
      let entityDescriptionForNewList = NSEntityDescription.entityForName(managedOptionListEntityName, inManagedObjectContext: managedObjectContext!)
      var managedOptionList = IDFYManagedOptionList(entity: entityDescriptionForNewList!, insertIntoManagedObjectContext: managedObjectContext)
      managedOptionList.name = ""
      managedOptionList.options = [String]()
      setLastUsedListName("")
      return IDFYOptionList()
    }
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
    let fetchResult : [IDFYManagedOptionList] = fetchManagedOptionListWithName(getLastUsedListName()!)
    if 0 < fetchResult.count {
      let managedOptionList = fetchResult[0]
      managedOptionList.name = list.name
      managedOptionList.options = list.options
      managedObjectContext?.save(nil)
      setLastUsedListName(list.name)
    } else {
      abort() // Shouldn't happen (by design)!
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
    setLastUsedListName("")
  }
  
  func loadListWithName(listName: String) {
    NSUserDefaults.standardUserDefaults().setValue(listName, forKey: lastUsedListNameKey)
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
      println("Error loading option list from data base: " + error.description)
      abort()
    }
    
    println()
    println(fetchResult)
    println()
    
    return fetchResult!
    
  }
  
  private func getLastUsedListName() -> String? {
    return NSUserDefaults.standardUserDefaults().stringForKey(lastUsedListNameKey)
  }
  
  private func setLastUsedListName(listName: String) {
    NSUserDefaults.standardUserDefaults().setObject(listName, forKey: lastUsedListNameKey)
  }
  
}
