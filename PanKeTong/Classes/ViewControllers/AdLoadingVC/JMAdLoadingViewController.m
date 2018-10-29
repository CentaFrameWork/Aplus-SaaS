//
//  JMAdLoadingViewController.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/24.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMAdLoadingViewController.h"

#import "JMAlertExitAppView.h"

#import "ManageAccountLockStatusApi.h"

#import "LockStatusEntity.h"

#import "LogOffUtil.h"

#import "UIViewController+Category.h"

@interface JMAdLoadingViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadingImageViewBottomCon;


@end

@implementation JMAdLoadingViewController

- (instancetype)init{
    
    return [JMAdLoadingViewController viewControllerFromStoryboard];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMainView];
    [self loadNavigationBar];
    
}

- (void)loadMainView{
    
    self.loadingImageViewBottomCon.constant = 50 + BOTTOM_SAFE_HEIGHT;
    
}

- (void)loadNavigationBar{
    
    
    
}

- (void)closeAdLoadingView{
    
    __block typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        NSString * appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        SettingSystem * setting = [SettingSystem settingSystemForDatabase];
        
        setting.advertisingVersion = appVersion;
        
        [setting saveSettingSystemToDatabase];
        
        weakSelf.canCloseBlock ? weakSelf.canCloseBlock() : nil;
        
    });
    
}

#pragma mark - 系统协议
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self closeAdLoadingView];
}

@end
