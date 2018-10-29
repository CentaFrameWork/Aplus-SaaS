//
//  NewUtils.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/30.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"           // 加载菊花
#import "SelectorView.h"            // 弹窗选择器
@class AppDelegate;

@interface NewUtils : NSObject

// 弹窗选择器
+ (SelectorView *)popoverSelectorTitle:(NSString *)title listArray:(NSArray *)array theOption:(void (^)(NSInteger optionValue))theOption;

@end

// 添加加载动画
void showLoading(NSString *message);
// 删除加载动画
void hiddenLoading(void);


//判断是否为整形：
BOOL isPureInt(NSString *string);

//判断是否为浮点形：
BOOL isPureFloat(NSString *string);

//判断是否是纯数字
BOOL isItANumber(NSString *string);


// 小数
BOOL isItDecimal(NSString *string, NSString *text, int length);

// 整数
BOOL isItInteger(NSString *string, NSString *text, int length);
