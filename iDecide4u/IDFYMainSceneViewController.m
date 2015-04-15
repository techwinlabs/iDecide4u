//
//  IDFYMainSceneViewController.m
//  iDecide4u
//
//  Created by Dominic Frei on 14/03/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import "IDFYMainSceneViewController.h"

@interface IDFYMainSceneViewController () <UITableViewDataSource>
@property IBOutlet UITableView *tableView;
@property (nonatomic)  NSMutableArray *itemList;
@end

@implementation IDFYMainSceneViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.itemList) {
        self.itemList = [NSMutableArray new];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [self.itemList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - IDFYAddNewItemDelegate

- (BOOL)saveNewItem:(NSString *)newItem {
    if (![self.itemList containsObject:newItem]) {
        [self.itemList addObject:newItem];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Before we segue to the IDFYAddNewItemViewController, set the delegate there for the IDFYAddNewItemDelegate protocol.
    if ([[segue destinationViewController] isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = [segue destinationViewController];
        if ([navigationController.topViewController isMemberOfClass:[IDFYAddNewItemViewController class]]) {
            IDFYAddNewItemViewController *addNewItemViewController = (IDFYAddNewItemViewController *)navigationController.topViewController;
            addNewItemViewController.delegate = self;
        }
    }
}

#pragma mark - IBActions

- (IBAction)decideButtonPressed:(id)sender {
    
    NSString *title = @"";
    NSString *message = @"";
    
    if (0 < self.itemList.count) {
        
        // Chose a winner and show it to the user.
        NSUInteger winningChoice = arc4random() % self.itemList.count;
        title = [NSString stringWithFormat:@"The winner is:\n\n%@", self.itemList[winningChoice]];
        
    } else {
        
        // Show the user a warning, which tells him, that he has to add some items first.
        title = @"Oups!";
        message = @"\nPlease add some items first.\n";
        
    }
    
    // Create the UIAlertController with the predefined title and message, add an OK button an presend that alert to the user.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)trashButtonPressed:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete all options?" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertActionTrash = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    self.itemList = [NSMutableArray new];
    [self.tableView reloadData];
    }];
    UIAlertAction *alertActionAbort = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:alertActionTrash];
    [alertController addAction:alertActionAbort];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
