//
//  CustomTextField.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/3/10.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CustomTextField.h"
#import "NSString+RemoveEmoji.h"


@implementation CustomTextField

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _limitLength = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChangeNotification:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
        self.delegate = self;

        // 设置不自动更正
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        // 首字母不自动大写
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _limitLength = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChangeNotification:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
        self.delegate = self;
        // 设置不自动更正
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        // 首字母不自动大写
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return self;
}

#pragma mark - Setter

- (void)setLimitCondition:(NSString *)limitCondition
{
    if (_limitCondition != limitCondition)
    {
        _limitCondition = limitCondition;
    }
}

- (void)setLimitLength:(NSInteger)limitLength
{
    if (_limitLength != limitLength)
    {
        _limitLength = limitLength;
    }
}

#pragma mark - <UITextFieldTextDidChangeNotification>

- (void)textDidChangeNotification:(NSNotification *)notification
{
    NSString *inputStr = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    // ********字符串长度限制
    if (self.limitLength == 0)
    {
        // 默认长度为50
        self.limitLength = 50;
    }

    // 去除特殊字符或表情
    self.text = [self.text removedEmojiString];

    if ([self stringContainsEmoji:self.text])
    {
        showMsg(@"不能输入表情符号");
    }


    if (self.text.length > self.limitLength)
    {
        NSString *textStr = [self.text substringToIndex:self.limitLength];
        self.text = textStr;
    }

    // *********输入字符串限制
    if (self.limitCondition.length > 0)
    {
        NSString *regex;
        if ([self.limitCondition isEqualToString:ONLY_NUMBER])
        {
            // 只能输入数字
            regex = @"^[0-9]*$";
        }

        else if ([self.limitCondition isEqualToString:ONLY_LETTER])
        {
            // 只能输入英文字母
            regex = @"^[A-Za-z]*$";
        }

        else if ([self.limitCondition isEqualToString:NUMBERANDLETTER])
        {
            // 只能输入数字或字母
            if ([inputStr isEqualToString:@"zh-Hans"])
            {
                regex = @"^[a-zA-Z0-9 ]*$";
            }else
            {
                regex = @"^[a-zA-Z0-9]*$";
            }
        }

        else if ([self.limitCondition isEqualToString:ONLY_CHINESE])
        {
            // 只能输入中文
            regex = @"^[\u4e00-\u9fa5]*$";
        }

        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:self.text];
        if (!isMatch)
        {
            NSString *inputText = self.text;
            for(int i = 0; i < self.text.length; i++)
            {
                NSString *charString = [self.text substringWithRange:NSMakeRange(i, 1)];
                NSString *str = @"^[a-zA-Z0-9]*$";
                BOOL isMatch2 = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",str] evaluateWithObject:charString];
                if (!isMatch2)
                {
                    inputText = [inputText stringByReplacingOccurrencesOfString:charString withString:@""];
                    NSLog(@"%@",inputText);
                }
            }

            self.text = inputText;
            showMsg(self.limitCondition);
            return;
        }
    }
    
//    @try{
    
    if (self.CustomDelegate) {
      
        if ([self.CustomDelegate respondsToSelector:@selector(customTextFieldDidChangeNotification)])
        {
            [self.CustomDelegate customTextFieldDidChangeNotification];
        }
    }
    
    
//
//    }@catch(NSException * e){
//
//
//
//    }
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.CustomDelegate respondsToSelector:@selector(customTextFieldShouldBeginEditing:)])
    {
        return [self.CustomDelegate customTextFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 不支持系统表情的输入和空格
    NSString *inputStr = [[UIApplication sharedApplication]textInputMode].primaryLanguage;

//    if ([[[UITextInputMode currentInputMode ] primaryLanguage] isEqualToString:@"emoji"])
//    {
//        return NO;
//    }

    if ([self stringContainsEmoji:string])
    {
        return NO;
    }

    if ([string isEqualToString:@" "] || [string isEqualToString:@"'"])
    {
        return NO;
    }

    if (self.limitLength == 0)
    {
        // 默认长度为50
        self.limitLength = 50;
    }

    if (range.length == 0 && range.location > self.limitLength - 1)
    {
        NSString *inputString = [NSString stringWithFormat:@"%@%@", textField.text, string];
        NSString *resultString = [inputString substringToIndex:self.limitLength];

        textField.text = resultString;

        return NO;
    }

    // **输入字符串类型限制
    // **字符串长度限制
    if (self.limitCondition.length > 0)
    {
        // 有限制条件
        NSString *regex;
        if ([self.limitCondition isEqualToString:ONLY_NUMBER])
        {
            // 只能输入数字
            regex = @"^[0-9]*$";
        }

        else if ([self.limitCondition isEqualToString:ONLY_LETTER])
        {
            // 只能输入英文字母
            regex = @"^[A-Za-z]*$";
        }

        else if ([self.limitCondition isEqualToString:NUMBERANDLETTER])
        {
            // 只能输入数字或字母
            if ([inputStr isEqualToString:@"zh-Hans"])
            {
                regex = @"^[a-zA-Z0-9 ]*$";
            }
            else
            {
                regex = @"^[a-zA-Z0-9]*$";
            }
        }

        else if ([self.limitCondition isEqualToString:ONLY_CHINESE])
        {
            // 只能输入中文
            regex = @"^[\u4e00-\u9fa5]*$";
        }

        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:string];
        if (!isMatch)
        {
            showMsg(self.limitCondition);
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self.CustomDelegate respondsToSelector:@selector(customTextFieldDidEndEditing:)])
    {
        [self.CustomDelegate customTextFieldDidEndEditing:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.CustomDelegate respondsToSelector:@selector(customTextFieldShouldReturn:)])
    {
        [self.CustomDelegate customTextFieldShouldReturn:textField];
    }
    return YES;
}


// 是否包含表情
- (BOOL)stringContainsEmoji:(NSString *)string
{

    __block BOOL returnValue = NO;

    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff)
                                {
                                    if (substring.length > 1)
                                    {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f)
                                        {
                                            returnValue = YES;
                                        }
                                    }
                                }
                                else if (substring.length > 1)
                                {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3)
                                    {
                                        returnValue = YES;
                                    }
                                }
                                else
                                {
                                    if (0x2100 <= hs && hs <= 0x27ff)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x2B05 <= hs && hs <= 0x2b07)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x2934 <= hs && hs <= 0x2935)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x3297 <= hs && hs <= 0x3299)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
                                    {
                                        returnValue = YES;
                                    }
                                }
                            }];

    return returnValue;
}



@end
