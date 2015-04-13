//
//  AddNewItemViewController.m
//  iDecide4u
//
//  Created by Dominic Frei on 14/03/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import "IDFYAddNewItemViewController.h"

@interface IDFYAddNewItemViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation IDFYAddNewItemViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - User Interactions

- (IBAction)doneButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (0 < self.textField.text.length) {
        BOOL itemWasSavedSuccessfully = [self.delegate saveNewItem:self.textField.text];
        if (itemWasSavedSuccessfully) {
            self.label.text = @"New option successfully saved.";
        } else {
            self.label.text = @"This option was already in the list.";
        }
        
        self.label.alpha = 1;
        [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{ self.label.alpha = 0;}
                         completion:nil];
        
        self.textField.text = @"";
    }
    return YES;
}



}

@end
