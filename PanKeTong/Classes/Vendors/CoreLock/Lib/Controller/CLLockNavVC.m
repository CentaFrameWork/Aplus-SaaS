//
//  CLLockNavVC.m
//  CoreLock
//
//  Created by 成林 on 15/4/28.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockNavVC.h"

@interface CLLockNavVC ()

@end

@implementation CLLockNavVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20*NewRatio]}];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"button_select_Img"] forBarMetrics:UIBarMetricsDefault];
    
    //tintColor
    self.navigationBar.tintColor = [UIColor whiteColor];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


@end
