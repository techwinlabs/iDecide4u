//
//  IDFYOptionList+Extensions.h
//  iDecide4u
//
//  Created by Dominic Frei on 16/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import "IDFYOptionList.h"

@interface IDFYOptionList (Extensions)

- (void)initalize;
- (NSUInteger)size;
- (NSString *)optionAtIndex:(NSUInteger)index;
- (void)addOption:(NSString *)option;
- (void)removeOption:(NSString *)option;
- (void)clearList;

@end
