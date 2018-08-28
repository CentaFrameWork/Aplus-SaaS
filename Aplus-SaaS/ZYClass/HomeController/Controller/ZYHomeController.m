//
//  ZYHomeController.m
//  Aplus-SaaS
//
//  Created by Admin on 2018/8/22.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYHomeController.h"
#import "ZYHouseListViewController.h"

#import "ZYHomeMainView.h"

@interface ZYHomeController ()

@property (nonatomic, weak) ZYHomeMainView * mainView;

@end

@implementation ZYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)loadMainView{
    
    __block typeof(self) weakSelf = self;
    
    ZYHomeMainView * mainView = [[ZYHomeMainView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAV_AND_STATUSBAR, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - HEIGHT_NAV_AND_STATUSBAR - self.tabBarController.tabBar.height) style:UITableViewStyleGrouped];
    
    [mainView setDidSelectItemBlock:^(NSIndexPath *indexPath) {
        
        ZYHouseListViewController * con = [[ZYHouseListViewController alloc] init];
        
        [weakSelf.navigationController pushViewController:con animated:YES];
        
    }];
    
    [self.view addSubview:mainView];
    
    self.mainView = mainView;
    
}

- (void)loadNavigationBar{
    
    self.navigationItem.title = @"首页";
    
}

@end
