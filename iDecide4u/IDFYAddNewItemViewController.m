//
//  AddNewItemViewController.m
//  iDecide4u
//
//  Created by Dominic Frei on 14/03/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import "IDFYAddNewItemViewController.h"

@interface IDFYAddNewItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation IDFYAddNewItemViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Interactions

- (IBAction)doneButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender {
    if (0 < self.textField.text.length) {
        [self.delegate saveNewItem:self.textField.text];
        self.textField.text = @"";
    }
}

@end
