//
//  IDFYManagedOptionList.swift
//  iDecide4U
//
//  Created by Dominic Frei on 25/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import CoreData

@objc(IDFYManagedOptionList)
class IDFYManagedOptionList: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var options: [String]

}
