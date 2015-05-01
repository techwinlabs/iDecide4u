//
//  IDFYMockGenerator.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import CoreData

private let managedObjectContext = IDFYCoreDataStack.sharedCoreDataStack().managedObjectContext!
private let optionListEntityName = IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName

class IDFYMockGenerator {
  
  class func generateMockIntoDatabase() {
    
    let fetchResult = IDFYDataManager().fetchEntity(optionListEntityName, fromManagedObjectContext: managedObjectContext, withPredicate: NSPredicate(format: "name == 'Meals'")) as! [IDFYOptionList]
    if 0 == fetchResult.count {
      let newList = NSEntityDescription.insertNewObjectForEntityForName(IDFYCoreDataStack.sharedCoreDataStack().optionListEntityName, inManagedObjectContext: managedObjectContext) as? IDFYManagedOptionList
      newList!.name = "Meals"
      newList!.options = ["", "", ""]
    }
    
  }
  
}
