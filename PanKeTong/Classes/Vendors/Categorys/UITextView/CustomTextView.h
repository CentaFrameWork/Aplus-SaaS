//
//  CustomTextView.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/4/14.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 *在这里可以增加限制条件，同时也是提示字符串
 */
#define ONLY_NUMBER     @"只能输入数字！"
#define ONLY_LETTER     @"只能输入英文字母！"
#define NUMBERANDLETTER @"只能输入英文字母或数字！"
#define ONLY_CHINESE    @"只能输入中文！"

/*
 *代理协议，协议方法的实现是可选的
 */
@protocol CustomTextViewDelegate <NSObject>

@optional
- (void)customViewDidChangeNotification:(NSNotification *)notification;//监控键盘输入通知之后的回调

- (void)customTextViewShouldBeginEditing:(UITextView *)textView;//开始编辑

- (void)customTextViewDidEndEditing:(UITextView *)textView;

- (void)customTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)customTextViewAchieveTextLengthLimit; // 达到限制条件

@end


@interface CustomTextView : UITextView<UITextViewDelegate>

@property (nonatomic,copy)NSString *limitCondition;//限制输入条件
@property (nonatomic,assign)NSInteger limitLength;//:限制输入长度

@property (nonatomic,assign) id <CustomTextViewDelegate>CustomDelegate;



@end
