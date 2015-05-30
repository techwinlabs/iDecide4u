//
//  IDFYInitialAppSetupGenerator.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import CoreData

private let managedObjectContext = IDFYCoreDataStack.sharedCoreDataStack().managedObjectContext!
private let optionListEntityName = IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName

class IDFYInitialAppSetupGenerator {
  
  class func generateInitialAppData() {
    
    let nameOfExampleOptionList = NSLocalizedString("app_setup.example_list_name", comment: "name for the localized example list")
    
    let pathToPlistWithExampleLists = NSBundle.mainBundle().pathForResource(nameOfExampleOptionList, ofType: "plist")
    let arrayWithExampleLists = NSArray(contentsOfFile: pathToPlistWithExampleLists!) as! [[String]]
    
    for (var listNumber=0; listNumber<arrayWithExampleLists.count; listNumber++) {
      let currentList = arrayWithExampleLists[listNumber] as [String]
      let list = NSEntityDescription.insertNewObjectForEntityForName(IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName, inManagedObjectContext: managedObjectContext) as? IDFYManagedOptionList
      list!.name = currentList[0]
      var options = [String]()
      for (var listItem=1; listItem<currentList.count; listItem++) {
        options.append(currentList[listItem])
      }
      list!.options = options
    }
    
    var error: NSError?
    IDFYCoreDataStack.sharedCoreDataStack().saveContext()
    if let error = error {
      IDFYLoggingUtilities.error("Error while saving database after mock data generation: " + error.description)
    }
    
    IDFYUserDefaultsUtility.setLastUsedListName("")
  }
  
}
