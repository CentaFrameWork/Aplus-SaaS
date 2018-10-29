//
//  JMAlertResetGesturesViewController.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/2.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMAlertResetGesturesViewController.h"

#import "UIViewController+Category.h"
#import "UIView+Extension.h"

@interface JMAlertResetGesturesViewController ()

@property (weak, nonatomic) IBOutlet UIView *alertConView;

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@end

@implementation JMAlertResetGesturesViewController

- (instancetype)init{
    
    return [JMAlertResetGesturesViewController viewControllerFromStoryboard];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMainView];
    [self loadNavigationBar];
    
}

- (void)loadMainView{
    
    self.ensureBtn.backgroundColor = YCThemeColorGreen;
    self.cancleBtn.backgroundColor = YCTextColorRentOrange;
    
    [self.alertConView setLayerCornerRadius:5*NewRatio];
    [self.ensureBtn setLayerCornerRadius:5*NewRatio];
    [self.cancleBtn setLayerCornerRadius:5*NewRatio];
    
}

- (void)loadNavigationBar{
    
}

- (IBAction)ensureBtnClick:(UIButton *)sender {
    
    self.ensureBtnClickBlock ? self.ensureBtnClickBlock() : nil;
    
}

- (IBAction)cancleBtnClick:(UIButton *)sender {
    
    self.cancleBtnClickBlock ? self.cancleBtnClickBlock() : nil;
    
}

@end
