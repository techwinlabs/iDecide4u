//
//  IDFYAddAndDecideDataManager.swift
//  iDecide4U
//
//  Created by Dominic Frei on 26/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import CoreData

class IDFYAddAndDecideDataManager : IDFYDataManager {
  
  // This function needs to be used when the app starts and the last used list needs to be retrieved.
  func getListWithName(listName: String) -> IDFYOptionList {
    let predicate = NSPredicate(format: "name == '" + listName + "'")
    fetchListWithPredicate(predicate)
    // TODO: Is it necessary to check if that name existed?
    // The name might be empty (list was never saved, but user expects the last used list to be shown).
    transferManagedOptionListDataToCurrentList()
    return super.currentList!
  }
  
}
