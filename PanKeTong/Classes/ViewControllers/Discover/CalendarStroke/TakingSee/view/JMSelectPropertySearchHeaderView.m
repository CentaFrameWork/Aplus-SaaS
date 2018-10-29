//
//  JMSelectPropertySearchHeaderView.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/21.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMSelectPropertySearchHeaderView.h"

@implementation JMSelectPropertySearchHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.searchConView.backgroundColor = [UIColor whiteColor];
    
    //圆角
    [self.searchConView setLayerCornerRadius:YCLayerCornerRadius];
    
    // 阴影
    CALayer *subLayer = [CALayer layer];
    
    subLayer.frame = self.searchConView.frame;
    
    subLayer.shadowOffset = CGSizeMake(0, 0);
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowRadius = 10;
    subLayer.shadowOpacity = 0.2;
    subLayer.cornerRadius = YCLayerCornerRadius;
    subLayer.masksToBounds = NO;
    subLayer.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
    
    [self.layer insertSublayer:subLayer below:self.searchConView.layer];
    
//    self.searchConView.layer.shadowOffset = CGSizeMake(0, 0);
//    self.searchConView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.searchConView.layer.shadowRadius = 10;
//    self.searchConView.layer.shadowOpacity = 0.05;
    
    
    
}

@end
