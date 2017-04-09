//
//  ViewController.m
//  SCTrailingPullControl
//
//  Created by ShannonChen on 2017/4/9.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import "ViewController.h"
#import "SCTrailingPullTableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup appearance
    self.navigationItem.title = [NSString stringWithFormat:@"SCTrailingPullControlDemo-page%li", self.navigationController.viewControllers.count - 1];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Setup UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SCTrailingPullTableViewCell";
    SCTrailingPullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SCTrailingPullTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    __weak typeof(self) weakSelf = self;
    cell.trailingPullBlock = ^void(void) {
        [weakSelf.navigationController pushViewController:[self.class new] animated:YES];
    };
    
    [cell reloadData];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}



@end
