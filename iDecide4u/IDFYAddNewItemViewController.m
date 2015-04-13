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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardConstraint;
@end

@implementation IDFYAddNewItemViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
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



#pragma mark - Keyboard Notification

// Essentially this method will be called when the view appears, as the text field will become first responder immediately.
// Hence the method is called when the view appears and the position of the text field and label can be calculated.
- (void)keyboardWillShow:(NSNotification *)notification {

    // Get the keyboard frame for later use.
    NSDictionary *userInfo = [notification userInfo];
    NSValue *kbFrame = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    // We need to substract several parts from the complete view to know how much space is remaining (from top to bottom):
    // - the status bar
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    // - the navigation bar
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    // - the text field, label and the space inbewteen them
    CGFloat textFieldLabelContainerHeight = self.label.frame.origin.y - self.textField.frame.origin.y + self.label.frame.size.height;
    // - the keyboard (which might have the auto suggestions turned on.
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    // Available space (height).
    CGFloat availableSpace = self.view.frame.size.height - statusBarHeight - navigationBarHeight - textFieldLabelContainerHeight - keyboardHeight;
    
    // Now we want to have that space equally devided on the following two areas:
    // - the space between the navigation bar and the text field
    // - the space between the label and the keyboard
    CGFloat heigthPerArea = availableSpace / 2;
    
    // The last part is to adjust the constraint defined via storyboard for the distance between the bottom of the view and the label, the keyboardConstraint.
    // Important is not to just set the constraint to be the heightPerArea, but also add the keyboard's height.
    self.keyboardConstraint.constant = heigthPerArea + keyboardHeight;
    
}

@end
