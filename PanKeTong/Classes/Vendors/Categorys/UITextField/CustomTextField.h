//
//  CustomTextField.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/3/10.
//  Copyright © 2017年 中原集团. All rights reserved.
//

/*
 *UI在外部实现，代理在内部实现
 */

#import <UIKit/UIKit.h>

/*
 *在这里可以增加限制条件，同时也是提示字符串
 */
#define ONLY_NUMBER         @"只能输入数字！"
#define ONLY_LETTER         @"只能输入英文字母！"
#define NUMBERANDLETTER     @"只能输入英文字母或数字！"
#define ONLY_CHINESE        @"只能输入中文！"
//#define ONLY_PHONENUMBER    @"只能输入手机号！"

/*
 *代理协议，协议方法的实现是可选的
 */
@protocol CustomTextFieldDelegate <NSObject>

@optional
/// 监控键盘输入通知之后的回调
- (void)customTextFieldDidChangeNotification;

/// 开始编辑
- (BOOL)customTextFieldShouldBeginEditing:(UITextField *)textField;

/// 结束编辑
- (void)customTextFieldDidEndEditing:(UITextField *)textField;

/// 点击return按钮
- (void)customTextFieldShouldReturn:(UITextField *)textField;

@end

@interface CustomTextField : UITextField<UITextFieldDelegate>

@property (nonatomic,copy)NSString *limitCondition; // 限制输入条件
@property (nonatomic,assign)NSInteger limitLength;  // 限制输入长度

@property (nonatomic,weak) id <CustomTextFieldDelegate>CustomDelegate;



@end
