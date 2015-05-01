//
//  IDFYAddAndDecideDataManager.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import CoreData

class IDFYAddAndDecideDataManager {
  
  private let managedObjectContext = IDFYCoreDataStack.sharedCoreDataStack().managedObjectContext
  private var currentList: IDFYOptionList?
  private var managedOptionListForCurrentList: IDFYManagedOptionList?
  
  // This function needs to be used when the app starts and the last used list needs to be retrieved.
  func getListWithName(listName: String) -> IDFYOptionList {
    let predicate = NSPredicate(format: "name == " + listName)
    fetchListWithPredicate(predicate)
    // TODO: Is it necessary to check if that name existed?
    // The name might be empty (list was never saved, but user expects the last used list to be shown).
    transferManagedOptionListDataToCurrentList()
    return currentList!
  }

  func getCurrentList() -> IDFYOptionList {
    if nil == currentList {
      fetchListWithPredicate(nil)
      transferManagedOptionListDataToCurrentList()
    }
    return currentList!
  }
  
  func updateCurrentList(optionList: IDFYOptionList) {
    currentList = optionList
    managedOptionListForCurrentList?.name = currentList!.name
    managedOptionListForCurrentList?.options = currentList!.options
    IDFYCoreDataStack.sharedCoreDataStack().saveContext()
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
  
}
