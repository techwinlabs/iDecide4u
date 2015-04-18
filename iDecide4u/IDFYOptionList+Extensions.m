//
//  IDFYOptionList+Extensions.m
//  iDecide4u
//
//  Created by Dominic Frei on 16/04/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import "IDFYOptionList+Extensions.h"

@implementation IDFYOptionList (Extensions)

- (void)initalize {
    self.options = [NSMutableArray new];
}

- (NSUInteger)size {
    return self.options.count;
}

- (BOOL)isEmpty {
    return 0 == self.options.count;
}

- (NSString *)optionAtIndex:(NSUInteger)index {
    return self.options[index];
}

- (void)addOption:(NSString *)option {
    if (![self.options containsObject:option]) {
        [self.options addObject:option];
    }
}

- (void)removeOption:(NSString *)option {
    [self.options removeObject:option];
}

- (void)clearList {
    self.options = [NSMutableArray new];
}

@end
