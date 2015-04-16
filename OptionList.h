//
//  OptionList.h
//  iDecide4u
//
//  Created by Dominic Frei on 16/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OptionList : NSManagedObject

@property (nonatomic, retain) NSString * listName;
@property (nonatomic, retain) NSMutableArray *options;

@end
