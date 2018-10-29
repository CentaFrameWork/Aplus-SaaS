//
//  DatePicker.h
//  PanKeTong
//
//  Created by zhwang on 16/4/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectPickerView.h"
typedef void (^DataTimeSelect)(NSDate *selectDataTime);

@interface DatePicker : UIView

@property (strong, nonatomic)NSDate *maxSelectDate;
///优先级低于isBeforeTime
@property (strong, nonatomic)NSDate *minSelectDate;

@property (strong, nonatomic)NSDate *selectDate;

///是否可选择当前时间之前的时间,默认为NO
@property (nonatomic,assign)BOOL isBeforeTime;

///DatePickerMode,默认是DateAndTime
@property (assign, nonatomic)UIDatePickerMode datePickerMode;

- (void)didFinishSelectedDate:(DataTimeSelect)selectDataTime;
@end
