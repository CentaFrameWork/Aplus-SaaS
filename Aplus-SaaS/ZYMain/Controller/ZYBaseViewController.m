//
//  ZYBaseViewController.m
//  A+
//
//  Created by 陈行 on 2018/8/20.
//  Copyright © 2018年 陈行. All rights reserved.
//

#import "ZYBaseViewController.h"

@interface ZYBaseViewController ()

@end

@implementation ZYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadInitialData];
    [self loadMainView];
    [self loadNavigationBar];
    
}

- (void)loadMainView{
    
    
}

- (void)loadNavigationBar{
    
}

- (void)loadInitialData{
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        
        self.tabBarController.tabBar.hidden = YES;
        
    }else{
        
        self.tabBarController.tabBar.hidden = NO;
        
    }
    
}


@end
