//
//  AddNewItemViewController.h
//  iDecide4u
//
//  Created by Dominic Frei on 14/03/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IDFYAddNewItemDelegate
- (void)saveNewItem:(NSString *)newItem;
@end

@interface IDFYAddNewItemViewController : UIViewController

@property id<IDFYAddNewItemDelegate> delegate;

@end
