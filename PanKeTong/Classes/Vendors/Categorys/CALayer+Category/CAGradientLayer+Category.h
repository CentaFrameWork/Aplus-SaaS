//
//  CAGradientLayer+Category.h
//  powerlife
//
//  Created by 陈行 on 16/12/7.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAGradientLayer (Category)

+ (instancetype)gradientLayerWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint andColors:(NSArray *)colors;

@end
