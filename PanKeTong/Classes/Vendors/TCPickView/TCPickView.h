//
//  TCPickView.h
//  TCPickView
//
//  Created by TailC on 15/11/7.
//  Copyright © 2015年 TailC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCPickView;

typedef void(^PickViewResultBlock)(id result);


@protocol TCPickViewDelegate <NSObject>

@optional
- (void)pickViewRemove;

@end

///自定义工具类
@interface TCPickView : UIView

/** DatePick 对象  */
@property (strong,nonatomic) UIDatePicker *datePick;

/** PickerView 对象  */
@property (strong,nonatomic) UIPickerView *pickView;

@property (assign,nonatomic) id<TCPickViewDelegate>myDelegate;

/**
 *  初始化日期选择器
 *
 *  @param date 初始化开始日期
 *  @param mode DatePick Mode
 *
 *  @return DatePickView
 */
-(UIView *)initDatePickViewWithDate:(NSDate *)date mode:(UIDatePickerMode)mode;

/**
 *  初始化数组选择PickView
 *
 *  @param arr 数组
 *
 *  @return PickView
 */
-(UIView *)initPickViewWithArray:(NSArray *)arr;

/**
 *  block回调结果
	若初始化PickerView，则返回的对象为NSArray
	若初始化DatePicker，则返回的对象为NSDate
 *
 *  @param block block
 */
-(void)showPickViewWithResultBlock:(PickViewResultBlock) block;

/*
 * 判断是否超过当前日期
 */
//+ (BOOL)isValidDate:(NSString *)dateString;


@end
