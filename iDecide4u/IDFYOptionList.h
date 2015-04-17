//
//  IDFYOptionList.h
//  iDecide4u
//
//  Created by Dominic Frei on 16/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IDFYOptionList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSMutableArray *options;

@end
