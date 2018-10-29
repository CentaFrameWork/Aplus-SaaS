//
//  CAShapeLayer+Category.m
//  powerlife
//
//  Created by 陈行 on 2017/6/8.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CAShapeLayer+Category.h"

#define SINGLE_LINE_WIDTH (1 / [UIScreen mainScreen].scale)

@implementation CAShapeLayer (Category)

+ (instancetype)shaperLayerAddLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint andColor:(UIColor *)color{
    
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:fromPoint];
    
    [bezierPath addLineToPoint:toPoint];
    
    shapeLayer.lineWidth = SINGLE_LINE_WIDTH;
    
    shapeLayer.path = bezierPath.CGPath;
    
    shapeLayer.fillColor = nil;
    
    shapeLayer.strokeColor = color.CGColor;
    
    return shapeLayer;
}

@end
