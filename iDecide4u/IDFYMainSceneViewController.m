//
//  IDFYMainSceneViewController.m
//  iDecide4u
//
//  Created by Dominic Frei on 14/03/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

#import "IDFYMainSceneViewController.h"

@interface IDFYMainSceneViewController () <UITableViewDataSource, UITableViewDelegate>
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    tableViewCell.textLabel.text = self.itemList[indexPath.row];
    
    return tableViewCell;
}

#pragma mark - UITableViewDelegate

#pragma mark - IDFYAddNewItemDelegate

- (void)saveNewItem:(NSString *)newItem {
    [self.itemList addObject:newItem];
    [self.tableView reloadData];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = [segue destinationViewController];
        if ([navigationController.topViewController isMemberOfClass:[IDFYAddNewItemViewController class]]) {
            IDFYAddNewItemViewController *addNewItemViewController = (IDFYAddNewItemViewController *)navigationController.topViewController;
            addNewItemViewController.delegate = self;
        }
    }
}

@end
