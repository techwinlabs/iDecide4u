//
//  IDFYListOperationDataManager.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import CoreData

class IDFYListOperationDataManager {
  
  private let managedObjectContext = IDFYCoreDataStack.sharedCoreDataStack().managedObjectContext!
  
  func getListOfLists() -> [IDFYOptionList] {
    let managedOptionListEntityName = NSStringFromClass(IDFYManagedOptionList).componentsSeparatedByString(".").last! as String
    let listOfManagedOptionLists = IDFYCommonDataManager.fetchEntity(managedOptionListEntityName, fromManagedObjectContext: managedObjectContext, withPredicate: nil) as! [IDFYManagedOptionList]
    var listOfOptionLists = [IDFYOptionList]()
    for managedOptionList : IDFYManagedOptionList in listOfManagedOptionLists {
      listOfOptionLists.append(IDFYOptionList(name: managedOptionList.name, options: managedOptionList.options))
    }
    return listOfOptionLists
  }
  
}
