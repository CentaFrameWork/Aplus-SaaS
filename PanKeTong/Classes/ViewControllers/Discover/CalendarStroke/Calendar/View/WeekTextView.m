//
//  WeekTextView.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/25.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "WeekTextView.h"

@implementation WeekTextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = RGBColor(245, 245, 245);
    }
    return self;
}



- (void)setWeekArr:(NSArray *)weekArr{
    if (_weekArr != weekArr)
    {
        _weekArr = weekArr;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    NSInteger countNum = _weekArr.count;
    CGFloat width = APP_SCREEN_WIDTH / countNum;
    
    for (int i = 0;  i  < countNum; i ++ )
    {
        NSString *textStr = _weekArr[i];
        CGRect rect1 = CGRectMake(width * i, 0, width, self.bounds.size.height);
        
        // 段落格式
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentCenter;// 水平居中
        // 构建属性集合
        NSDictionary *attributes = @{
                                     NSFontAttributeName : [UIFont systemFontOfSize:14.0],
                                     NSParagraphStyleAttributeName : textStyle,
                                     NSForegroundColorAttributeName : YCTextColorAuxiliary
                                     };
        // 获得size
        CGSize strSize = [textStr sizeWithAttributes:attributes];
        CGFloat marginTop = (rect1.size.height - strSize.height)/2;
        
        CGRect r = CGRectMake(rect1.origin.x, rect1.origin.y + marginTop,rect1.size.width, strSize.height);
        [textStr drawInRect:r withAttributes:attributes];
    }
}

@end
