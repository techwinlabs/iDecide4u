//
//  IDFYMainSceneViewController.m
//  iDecide4u
//
//  Created by Dominic Frei on 14/03/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import "IDFYMainSceneViewController.h"

@interface IDFYMainSceneViewController () <UITableViewDataSource, UITextFieldDelegate>
@property IBOutlet UITableView *tableView;
@property (nonatomic)  NSMutableArray *itemList;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddNewOption;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldTrailingSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@end

@implementation IDFYMainSceneViewController

int selectedIndex = 100000; //integer used to save the value of selected cell

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - get / set

- (NSMutableArray *)itemList {
    if (!_itemList) {
        _itemList = [NSMutableArray new];
    }
    return _itemList;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Just a standard UITableViewCell.
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    tableViewCell.textLabel.text = self.itemList[indexPath.row];
    
    //Change colour of highlighted cell
    if (indexPath.row == selectedIndex) {
        [tableViewCell setBackgroundColor:[UIColor colorWithRed: 173.0/255.0 green: 216.0/255.0 blue:230.0/255.0 alpha: 1.0]];
        tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else { //White for all the other cells
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    }
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [self.itemList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITextFieldDelegate

// When the user clicks into the text field, the add button needs to appear.
// This is done here with an animated constraint change.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    // The Apple documentation recommends to call layoutIfNeeded at the beginning, just to make sure, the layout is up to date.
    [self.view layoutIfNeeded];
    
    self.textFieldTrailingSpaceConstraint.constant = 42;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.addButton.hidden = NO;
    }];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newTextFieldContent = [self.textFieldAddNewOption.text stringByReplacingCharactersInRange:range withString:string];
    if ([newTextFieldContent isEqualToString:@""]) {
        self.addButton.enabled = NO;
    } else {
        self.addButton.enabled = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.textFieldAddNewOption]) {
        if (0 < self.textFieldAddNewOption.text.length) {
            [self.itemList addObject:self.textFieldAddNewOption.text];
            [self.tableView reloadData];
        }
        [self.textFieldAddNewOption resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    // The Apple documentation recommends to call layoutIfNeeded at the beginning, just to make sure, the layout is up to date.
    [self.view layoutIfNeeded];
    
    self.textFieldAddNewOption.text = @"";
    self.textFieldTrailingSpaceConstraint.constant = 12;
    self.addButton.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.textFieldAddNewOption layoutIfNeeded];
    }];
    
    return YES;
}

#pragma mark - IBActions

- (IBAction)decideButtonPressed:(id)sender {
    
    NSString *title = @"";
    NSString *message = @"";
    
    if (0 < self.itemList.count) {
        
        // Chose a winner and show it to the user.
        NSUInteger winningChoice = arc4random() % self.itemList.count;
        selectedIndex = (int)winningChoice; //assigning random variable to selectedindex
        
//        title = NSLocalizedString(@"main.scene_dicision.alert.title", @"title for a decision");
        title = [NSString stringWithFormat:@"%@:\n%@", NSLocalizedString(@"main.scene_dicision.alert.message", @"message for a decision"), self.itemList[winningChoice]];
        
    } else {
        
        // Show the user a warning, which tells him, that he has to add some items first.
        title = NSLocalizedString(@"main.scene_dicision.alert.no.items.title", @"title for a dicision without options");
        message = [NSString stringWithFormat:@"%@", NSLocalizedString(@"main.scene_dicision.alert.no.items.message", @"message for a dicision without options")];
        
    }
    
    // Create the UIAlertController with the predefined title and message, add an OK button an presend that alert to the user.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"main.scene_dicision.alert.ok.button", @"button title for a dicision") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
    [self.tableView reloadData];
}

- (IBAction)trashButtonPressed:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete all options?" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIBarButtonItem *trashButton = (UIBarButtonItem *)sender;
    alertController.popoverPresentationController.barButtonItem = trashButton;
    
    UIAlertAction *alertActionTrash = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        self.itemList = [NSMutableArray new];
        self.addButton.enabled = NO;
        [self.tableView reloadData];
    }];
    UIAlertAction *alertActionAbort = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:alertActionTrash];
    [alertController addAction:alertActionAbort];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)addButtonPressed:(id)sender {
    if (![self.itemList containsObject:self.textFieldAddNewOption.text]) {
        [self.itemList addObject:self.textFieldAddNewOption.text];
    }
    [self.tableView reloadData];
    self.textFieldAddNewOption.text = @"";
    self.addButton.enabled = NO;
    
    // We need to scroll to the new item so the user can see it.
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.itemList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Keyboard notification selectors

// When the keyboard is shown we need to shrink the table view so it does not get hidden by the keyboard.
- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *keyboardFrame = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardRect = [keyboardFrame CGRectValue];
    
    CGFloat keyboardHeight = keyboardRect.size.height;
    CGFloat toolBarHeight = self.toolbar.frame.size.height;

    self.tableViewBottomConstraint.constant = keyboardHeight - toolBarHeight;
}

// When the keyboard will be hidden we need to exapand the table view to it's original size.
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval timeIntervalKeyboardAnimationDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:timeIntervalKeyboardAnimationDuration animations:^{
        self.tableViewBottomConstraint.constant = -self.toolbar.frame.size.height;
    } completion:^(BOOL finished) {
        self.tableViewBottomConstraint.constant = 0;
    }];
}

@end
