//
//  CAGradientLayer+Category.m
//  powerlife
//
//  Created by 陈行 on 16/12/7.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "CAGradientLayer+Category.h"

@implementation CAGradientLayer (Category)

+ (instancetype)gradientLayerWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint andColors:(NSArray *)colors{
    
    CAGradientLayer * gdLayer = [[CAGradientLayer alloc] init];
    
    gdLayer.startPoint = startPoint;
    
    gdLayer.endPoint = endPoint;
    
    gdLayer.colors = colors;
    
    return gdLayer;
}

@end
