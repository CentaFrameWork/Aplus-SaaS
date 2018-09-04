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

#import "ZYHomeControllerPresent.h"

@interface ZYHomeController ()<UITableViewDelegate>

@property (nonatomic, weak) ZYHomeMainView * mainView;

@property (nonatomic, strong) ZYHomeControllerPresent * present;

@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation ZYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)loadMainView{
    
    __block typeof(self) weakSelf = self;
    
    //frame正常点，不适用自带的偏移
    ZYHomeMainView * mainView = [[ZYHomeMainView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAV_AND_STATUSBAR, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - HEIGHT_NAV_AND_STATUSBAR - HEIGHT_TABBAR) style:UITableViewStylePlain];
    
    [mainView setItemDidSelctedBlock:^(NSIndexPath *indexPath) {
        
        ZYHouseListViewController * con = [[ZYHouseListViewController alloc] init];
        
        [weakSelf.navigationController pushViewController:con animated:YES];
        
    }];
    
    [self.view addSubview:mainView];
    
    
    self.present = [[ZYHomeControllerPresent alloc] init];
    [self.present setPresentView:mainView];
    [self.present sendRequest];
    
}

- (void)loadNavigationBar{
    
    self.navigationItem.title = @"首页";
    
}


@end
