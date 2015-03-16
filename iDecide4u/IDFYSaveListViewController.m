//
//  SaveListViewController.m
//  iDecide4u
//
//  Created by Dominic Frei on 16/03/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import "IDFYSaveListViewController.h"

@interface IDFYSaveListViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation IDFYSaveListViewController

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

- (IBAction)saveButtonPressed:(id)sender {
    if (0 < self.textField.text.length) {
        [self.delegate saveList:self.textField.text];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
