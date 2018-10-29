//
//  JMMessageOfficialHeaderView.m
//  PanKeTong
//
//  Created by 陈行 on 2018/4/25.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMMessageOfficialHeaderView.h"

#import "CAShapeLayer+Category.h"

@implementation JMMessageOfficialHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer shaperLayerAddLineFromPoint:CGPointMake(12, 48) toPoint:CGPointMake(APP_SCREEN_WIDTH, 48) andColor:RGBColor(236, 236, 236)];
    
    [self.layer addSublayer:shapeLayer];
    
}

@end
