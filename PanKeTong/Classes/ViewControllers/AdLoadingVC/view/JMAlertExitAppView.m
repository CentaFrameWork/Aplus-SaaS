//
//  JMAlertExitAppView.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/15.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMAlertExitAppView.h"

#import "UIView+Extension.h"

@implementation JMAlertExitAppView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.exitBtn setLayerCornerRadius:YCLayerCornerRadius];
    
    [self.containerView setLayerCornerRadius:YCLayerCornerRadius];
    
    self.backgroundColor = YCTranslucentBGColor;
    
}

- (IBAction)exitBtnClick:(UIButton *)sender {
    
    exit(-1);
    
}


@end
