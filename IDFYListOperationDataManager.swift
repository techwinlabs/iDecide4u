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
  private let optionListEntityName = IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName
  
  func getListOfLists() -> [IDFYOptionList] {
    return IDFYCommonDataManager.fetchEntity(optionListEntityName, fromManagedObjectContext: managedObjectContext, withPredicate: nil) as! [IDFYOptionList]
  }
  
}
