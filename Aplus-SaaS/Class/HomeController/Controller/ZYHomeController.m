//
//  ZYHomeController.m
//  Aplus-SaaS
//
//  Created by Admin on 2018/8/22.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYHomeController.h"
#import "ZYHomeMainView.h"
#import "ZYHomeControllerPresent.h"

@interface ZYHomeController ()<UITableViewDelegate>

@property (nonatomic, strong) ZYHomeMainView * mainView;

@end

@implementation ZYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    
    _mainView = [[ZYHomeMainView alloc] init];
//    _mainView.delegate = self;
    [self.view addSubview:_mainView];
    
    [ZYHomeControllerPresent request_loginWithArgument:@{@"KeyId":@"",@"IsMobileRequest": @(YES)} withSucess:^(ZYHomeControllerPresent *shareVM) {
        
        
        
    }];
    

    
}

@end
