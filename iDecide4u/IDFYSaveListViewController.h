//
//  SaveListViewController.h
//  iDecide4u
//
//  Created by Dominic Frei on 16/03/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IDFYSaveListDelegate
- (void)saveList:(NSString *)listName;
@end

@interface IDFYSaveListViewController : UIViewController

@property id<IDFYSaveListDelegate> delegate;

@end
