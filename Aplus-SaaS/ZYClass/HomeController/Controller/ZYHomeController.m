//
//  ZYHomeController.m
//  Aplus-SaaS
//
//  Created by Admin on 2018/8/22.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYHomeController.h"

#import "ZYHomeMainView.h"

@interface ZYHomeController ()

@property (nonatomic, weak) ZYHomeMainView * mainView;

@end

@implementation ZYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)loadMainView{
    
    ZYHomeMainView * mainView = [[ZYHomeMainView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:mainView];
    
    self.mainView = mainView;
    
}

- (void)loadNavigationBar{
    
    self.navigationItem.title = @"首页";
    
}

@end
