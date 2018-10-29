//
//  JMDateDetailView.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/18.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMDateDetailView.h"

@implementation JMDateDetailView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
}

- (void)setCurrentDate:(NSDate *)currentDate{
    
    _currentDate = currentDate;
    
    NSArray * monthArr = @[@"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月"];
    
    NSString *nowDate = [NSDate stringWithSimpleDate:_currentDate];
    
    self.yearLabel.text = [nowDate substringToIndex:4];
    
    NSInteger index = [[nowDate substringWithRange:NSMakeRange(5, 2)] integerValue] - 1;
    
    self.monthLabel.text = monthArr[index];
}


@end
