//
//  IDFYOptionList+Extensions.h
//  iDecide4u
//
//  Created by Dominic Frei on 16/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import "IDFYOptionList.h"

@interface IDFYOptionList (Extensions)

#pragma mark - Initialization
- (void)initalize;

#pragma mark - Inspecting the OptionsList
- (NSUInteger)size;
- (BOOL)isEmpty;
- (NSString *)optionAtIndex:(NSUInteger)index;

#pragma mark - Editing the OptionList
- (void)addOption:(NSString *)option;
- (void)removeOption:(NSString *)option;
- (void)clearList;

@end
