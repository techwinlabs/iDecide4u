//
//  IDFYMainSceneViewController.h
//  iDecide4u
//
//  Created by Dominic Frei on 14/03/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDFYAddNewItemViewController.h"

@interface IDFYMainSceneViewController : UIViewController<IDFYAddNewItemDelegate>

- (void)saveNewItem:(NSString *)newItem;

@end