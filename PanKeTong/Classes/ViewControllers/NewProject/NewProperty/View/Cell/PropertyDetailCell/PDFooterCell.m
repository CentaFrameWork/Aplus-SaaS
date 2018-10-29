//
//  PDFooterCell.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/22.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "PDFooterCell.h"

@implementation PDFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setContent:(NSString *)content
{
    if (_content != content)
    {
        _content = content;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    // 绘制直线
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ref, 15, 0);                        // 起点
    CGContextAddLineToPoint(ref, APP_SCREEN_WIDTH - 15, 0);  // 终点
    CGContextSetStrokeColorWithColor(ref, SeparateLineColor.CGColor);
    CGContextSetLineWidth(ref, 1);
    CGContextDrawPath(ref, kCGPathFillStroke);

    if ([self.content contains:@"成交记录"]) {
       
        self.accessoryType = 0;
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        [self.content drawInRect:CGRectMake(0, 12, APP_SCREEN_WIDTH, 15)
                  withAttributes:@{
                                   NSFontAttributeName:[UIFont systemFontOfSize:14.0],
                                   NSForegroundColorAttributeName:YCTextColorAuxiliary,
                                   NSParagraphStyleAttributeName:paragraphStyle
                                   }];
        
        
    }else{
        
        if (self.content.length > 0)
        {
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentLeft;
            
            [self.content drawInRect:CGRectMake(12, 12, APP_SCREEN_WIDTH, 15)
                      withAttributes:@{
                                       NSFontAttributeName:[UIFont systemFontOfSize:14.0],
                                       NSForegroundColorAttributeName:YCTextColorAuxiliary,
                                       NSParagraphStyleAttributeName:paragraphStyle
                                       }];
        }
    }
    
    
 

    
}

@end
