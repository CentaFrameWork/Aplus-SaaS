//
//  ZYHomeController.m
//  Aplus-SaaS
//
//  Created by Admin on 2018/8/22.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYHomeController.h"
#import "ZYHomeMainView.h"
#import "ZYWorkController.h"
#import "ZYHomeControllerPresent.h"

@interface ZYHomeController ()<UITableViewDelegate>

@property (nonatomic, weak) ZYHomeMainView * mainView;

@property (nonatomic, strong) ZYHomeControllerPresent * present;

@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation ZYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    __block typeof(self) weakSelf = self;
    
    ZYHomeMainView * mainView = [[ZYHomeMainView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    [mainView setItemDidSelctedBlock:^(NSIndexPath *indexPath) {
        
        ZYWorkController * con = [[ZYWorkController alloc] init];
        
        [weakSelf.navigationController pushViewController:con animated:YES];
        
    }];
    
    [self.view addSubview:mainView];
    
    
    self.present = [[ZYHomeControllerPresent alloc] init];
    [self.present setPresentView:mainView];
    [self.present sendRequest];
    
}

@end
