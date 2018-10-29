//
//  CAShapeLayer+Category.h
//  powerlife
//
//  Created by 陈行 on 2017/6/8.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAShapeLayer (Category)

+ (instancetype)shaperLayerAddLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint andColor:(UIColor *)color;

@end
