//
//  ZYTabBarController.m
//  A+
//
//  Created by 陈行 on 2018/8/20.
//  Copyright © 2018年 陈行. All rights reserved.
//

#import "ZYTabBarController.h"
#import "ZYNavigationController.h"
#import "ZYHomeController.h"
#import "ZYMessageController.h"
#import "ZYWorkController.h"
#import "ZYMyController.h"
@interface ZYTabBarController ()

@end

@implementation ZYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addControls];
}
- (void)addControls {
    
    [self control:[ZYHomeController new] ImageName:@"首页icon-默认" andTitle:@"首页"];
    
    [self control:[ZYMessageController new] ImageName:@"首页icon-默认" andTitle:@"消息"];
    
    [self control:[ZYWorkController new] ImageName:@"首页icon-默认" andTitle:@"工作"];
    
    [self control:[ZYMyController new] ImageName:@"首页icon-默认" andTitle:@"我"];
}


- (void)control:(UIViewController*)control ImageName:(NSString*)ImageName andTitle:(NSString*)title {
    
    self.tabBar.tintColor = [UIColor redColor];
    
    ZYNavigationController *nav = [[ZYNavigationController alloc] initWithRootViewController:control];
    
    control.title = title;
    
    control.tabBarItem.image = [UIImage imageNamed:ImageName];
    
    NSString *str = [NSString stringWithFormat:@"%@_highlighted",ImageName];
    
    control.tabBarItem.selectedImage = [UIImage imageNamed:str] ;
    
    
    [control.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    [self addChildViewController:nav];
}


@end
