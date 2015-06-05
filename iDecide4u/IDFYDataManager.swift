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
  
  func updateCurrentList(optionList: IDFYOptionList) {
    IDFYLoggingUtilities.debug("Updating current list with name: '\(IDFYUserDefaultsUtility.getLastUsedListName()!)'")
    let fetchResult : [IDFYManagedOptionList] = fetchManagedOptionListWithName(IDFYUserDefaultsUtility.getLastUsedListName()!)
    if 0 < fetchResult.count {
      let managedOptionList = fetchResult[0]
      transferDataOfOptionList(optionList, toManagedOptionList: managedOptionList)
    } else if "" == IDFYUserDefaultsUtility.getLastUsedListName()! {
      let managedOptionList = NSEntityDescription.insertNewObjectForEntityForName(managedOptionListEntityName, inManagedObjectContext:managedObjectContext!) as! IDFYManagedOptionList
      transferDataOfOptionList(optionList, toManagedOptionList: managedOptionList)
    } else {
      IDFYLoggingUtilities.error("Error while updating the list! Must not happen!\nValues for the given list:\n\(optionList.description())")
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
  
  func deleteListWithName(listName: String) {
    let managedOptionLists = fetchManagedOptionListWithName(listName)
    if 0 < managedOptionLists.count {
      managedObjectContext?.deleteObject(managedOptionLists[0])
    } else {
      println("Error while loading the list, which should be deleted.")
    }
  }
  
  func doesListWithNameExist(listName: String) -> Bool {
    let lists = fetchManagedOptionListWithName(listName)
    return 0 != lists.count
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
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    var error: NSError?
    let fetchResult = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
    
    if let error = error {
      IDFYLoggingUtilities.error("Error loading option list from data base: " + error.description)
    }
    
    return fetchResult!
  }
  
  func transferDataOfOptionList(optionList: IDFYOptionList, toManagedOptionList managedOptionList: IDFYManagedOptionList) {
    IDFYLoggingUtilities.debug("optionList.name: '\(optionList.name)', optionList.options: \(optionList.options)")
    managedOptionList.name = optionList.name
    managedOptionList.options = optionList.options
    IDFYLoggingUtilities.debug("managedOptionList.name: '\(managedOptionList.name)', managedOptionList.options: \(managedOptionList.options)")
    IDFYCoreDataStack.sharedCoreDataStack().saveContext()
    IDFYLoggingUtilities.debug("set last used list: '\(optionList.name)'")
    IDFYUserDefaultsUtility.setLastUsedListName(optionList.name)
  }
  
}
