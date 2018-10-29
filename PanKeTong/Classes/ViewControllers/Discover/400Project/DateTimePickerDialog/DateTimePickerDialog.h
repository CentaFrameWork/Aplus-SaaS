//
//  DateTimePickerDialog.h
//  DatePicker
//
//  Created by 燕文强 on 16/1/21.
//  Copyright (c) 2016年 mspsys087. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol DateTimeSelected <NSObject>
- (void)selectedResultWithSender:(NSObject *)sender andDate:(NSDate *)dateTime;//点击某个单元格
- (void)clickDone;//点击确定
- (void)clickCancle;//点击取消
@end

@interface DateTimePickerDialog : NSObject<UIGestureRecognizerDelegate>

@property (nonatomic,strong)NSString *tag;

@property (nonatomic,strong) UIView *parentView;
@property (nonatomic,strong) UIDatePicker *datePickerView;
@property (nonatomic,strong) UIView *viewBack;
@property (strong, nonatomic) UIView *pickerView;

@property (nonatomic,assign)id <DateTimeSelected>delegate;


+ (DateTimePickerDialog *)initWithParentView:(UIView *)parentView
                                 andDelegate:(id<DateTimeSelected>)delegate
                                      andTag:(NSString *)tag;

- (void)showWithDate:(NSDate *)date andTipTitle:(NSString *)tipTitle;


+ (NSDate *)ConversionTimeZone:(NSDate *)date;

@property (nonatomic,assign) UIDatePickerMode datePickerMode;


@end
