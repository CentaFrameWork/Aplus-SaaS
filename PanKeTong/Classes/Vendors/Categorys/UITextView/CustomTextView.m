//
//  CustomTextView.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/4/14.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CustomTextView.h"
#import "NSString+RemoveEmoji.h"

@implementation CustomTextView{
    NSString *_inputString;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
}

//使用xib创建
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _limitLength = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChangeNotification:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
        self.delegate = self;


    }
    return self;
}

//使用代码创建
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _limitLength = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChangeNotification:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
        self.delegate = self;
    }
    return self;
}

#pragma mark-<Setter>
- (void)setLimitCondition:(NSString *)limitCondition{
    if (_limitCondition != limitCondition) {
        _limitCondition = limitCondition;
    }
}

- (void)setLimitLength:(NSInteger)limitLength{
    if (_limitLength != limitLength) {
        _limitLength = limitLength;
    }
}

#pragma mark-<UITextFieldTextDidChangeNotification>
- (void)textDidChangeNotification:(NSNotification *)notification
{
    //********字符串长度限制
    if (self.limitLength == 0) {
        //默认长度为50
        self.limitLength = 50;
    }
    if (self.text.length >= self.limitLength)
    {
        if (_inputString.length >= self.limitLength)
        {
            self.text = _inputString;
        }
        else
        {
            _inputString = [self.text substringToIndex:self.limitLength];
            self.text = _inputString;
            // 达到字数限制条件
            if ([self.CustomDelegate respondsToSelector:@selector(customTextViewAchieveTextLengthLimit)])
            {
                [self.CustomDelegate customTextViewAchieveTextLengthLimit];
            }
        }
    }
    else
    {
        _inputString = self.text;
    }

    //*********输入字符串限制
    if (self.limitCondition.length > 0){
        NSString *regex;
        if ([self.limitCondition isEqualToString:ONLY_NUMBER]) {
            //只能输入数字
            regex = @"^[0-9]*$";
        }

        else if ([self.limitCondition isEqualToString:ONLY_LETTER]){
            //只能输入英文字母
            regex = @"^[A-Za-z]*$";
        }

        else if ([self.limitCondition isEqualToString:NUMBERANDLETTER]){
            //只能输入数字或字母
            regex = @"^[A-Za-z0-9]*$";

        }

        else if ([self.limitCondition isEqualToString:ONLY_CHINESE]){
            //只能输入中文
            regex = @"^[\u4e00-\u9fa5]*$";
        }

        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:self.text];
        if (!isMatch) {
            NSString *inputText = self.text;
            for(int i =0; i < self.text.length; i++)
            {
                NSString *charString = [self.text substringWithRange:NSMakeRange(i, 1)];
                BOOL isMatch2 = [pred evaluateWithObject:charString];
                if (!isMatch2) {
                    inputText = [inputText stringByReplacingOccurrencesOfString:charString withString:@""];
                }
            }
            self.text = inputText;

            showMsg(self.limitCondition);
            return;
        }
    }


    if ([self.CustomDelegate respondsToSelector:@selector(customViewDidChangeNotification:)]) {
        [self.CustomDelegate customViewDidChangeNotification:notification];
    }

}

#pragma mark-<UITextViewDelegate>

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([self.CustomDelegate respondsToSelector:@selector(customTextViewShouldBeginEditing:)]) {
        [self.CustomDelegate customTextViewShouldBeginEditing:textView];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //不支持系统表情的输入和空格
    if ([[[UITextInputMode currentInputMode ] primaryLanguage] isEqualToString:@"emoji"])
    {
        return NO;
    }

    if (self.limitLength == 0) {
        //默认长度为50
        self.limitLength = 50;
    }

    if (range.length == 0 && range.location > self.limitLength - 1)
    {
        // 达到字数限制条件
        if ([self.CustomDelegate respondsToSelector:@selector(customTextViewAchieveTextLengthLimit)])
        {
            [self.CustomDelegate customTextViewAchieveTextLengthLimit];
        }
        return NO;
    }

    //**输入字符串类型限制
    //**字符串长度限制
    if (self.limitCondition.length > 0) {
        //有限制条件
        NSString *regex;
        if ([self.limitCondition isEqualToString:ONLY_NUMBER]) {
            //只能输入数字
            regex = @"^[0-9]*$";
        }

        else if ([self.limitCondition isEqualToString:ONLY_LETTER]){
            //只能输入英文字母
            regex = @"^[A-Za-z]*$";
        }

        else if ([self.limitCondition isEqualToString:NUMBERANDLETTER]){
            //只能输入数字或字母
            regex = @"^[A-Za-z0-9]*$";
        }

        else if ([self.limitCondition isEqualToString:ONLY_CHINESE]){
            //只能输入中文
            regex = @"^[\u4e00-\u9fa5]*$";
        }

        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:text];
        if (!isMatch) {
            showMsg(self.limitCondition);
            return NO;
        }
    }

    if (self.CustomDelegate &&[self.CustomDelegate respondsToSelector:@selector(customTextView:shouldChangeTextInRange:replacementText:)]) {
        [self.CustomDelegate customTextView:textView shouldChangeTextInRange:range replacementText:text];
    }

    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    if (self.CustomDelegate &&[self.CustomDelegate respondsToSelector:@selector(customTextViewDidEndEditing:)]) {
        [self.CustomDelegate customTextViewDidEndEditing:textView];
    }
}

@end
