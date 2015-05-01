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
    let optionListEntityName = NSStringFromClass(IDFYManagedOptionList).componentsSeparatedByString(".").last! as String
    let managedOptionLists = IDFYCommonDataManager.fetchEntity(optionListEntityName, fromManagedObjectContext: managedObjectContext, withPredicate: nil) as! [IDFYManagedOptionList]
    var listOfTransformedLists = [IDFYOptionList]()
    for managedOptionList : IDFYManagedOptionList in managedOptionLists {
      listOfTransformedLists.append(IDFYOptionList(name: managedOptionList.name, options: managedOptionList.options))
    }
    return listOfTransformedLists
  }
  
}
