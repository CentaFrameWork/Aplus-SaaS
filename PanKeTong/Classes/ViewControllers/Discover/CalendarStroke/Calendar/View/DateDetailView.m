//
//  DateDetailView.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/22.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "DateDetailView.h"
#import "NSDate+Format.h"

@implementation DateDetailView{
    UILabel *_nowDate;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIButton *todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        todayBtn.tag = 1993;
        todayBtn.frame = CGRectMake(20, 12.5, 25, 25);
        [todayBtn setBackgroundImage:[UIImage imageNamed:@"icon_jm_calendar_today"] forState:UIControlStateNormal];
        [self addSubview:todayBtn];

        _nowDate = [[UILabel alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH - 100) / 2, 10, 100, 30)];
        _nowDate.font = [UIFont systemFontOfSize:20];
        _nowDate.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nowDate];
    }
    return self;
}

- (void)setCurrentDate:(NSDate *)currentDate{
    if (_currentDate != currentDate)
    {
        _currentDate = currentDate;
        [self updateDate];
    }
}

- (void)updateDate{
    NSString *nowDate = [NSDate stringWithSimpleDate:_currentDate];
    nowDate = [nowDate substringToIndex:7];
    _nowDate.text = nowDate;

}

@end
