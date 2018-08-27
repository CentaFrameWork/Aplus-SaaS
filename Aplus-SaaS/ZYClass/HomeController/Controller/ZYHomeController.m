//
//  ZYHomeController.m
//  Aplus-SaaS
//
//  Created by Admin on 2018/8/22.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYHomeController.h"

#import "ZYHomeControllerPresent.h"

@interface ZYHomeController ()<ZYHomeControllerPresentDelegate>

@property (nonatomic, strong) ZYHomeControllerPresent * present;

@end

@implementation ZYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)loadMainView{
    
    
    
}

- (void)loadNavigationBar{
    
    
}

- (void)loadInitialData{
    
    self.present = [[ZYHomeControllerPresent alloc] init];
    
    self.present.delegate = self;
    
    [self.present sendRequest];
}

#pragma mark - ZYHomeControllerPresentDelegate
- (void)getServerData:(id)data{
    
    NSLog(@"-------->%@", [data otherDescription]);
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.present sendRequest];
    
}

@end
