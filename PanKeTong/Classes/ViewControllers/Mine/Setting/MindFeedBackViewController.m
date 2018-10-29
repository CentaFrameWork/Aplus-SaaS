//
//  MindFeedBackViewController.m
//  SaleHouse
//
//  Created by wanghx17 on 15/5/5.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MindFeedBackViewController.h"
#import "CustomAlertMessage.h"
#import "UserFeedBackApi.h"
#import "ConfirmSuccessEntity.h"

@interface MindFeedBackViewController ()<UITextViewDelegate>
{
    __weak IBOutlet UILabel *_placeholderLabel;
    __weak IBOutlet UITextView *_mainTextView;
    __weak IBOutlet NSLayoutConstraint *_labelSpaceBetween;
    __weak IBOutlet UILabel *_bottomNumberLabel;
    
    NSString *_appendContent;
}
@end

@implementation MindFeedBackViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (MODEL_VERSION < 7.0)
    {
        _labelSpaceBetween.constant = 21;
    }
    _mainTextView.delegate = self;
    [self initNavigation];
    _bottomNumberLabel.text = @"还可输入140字";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewEditChanged:)
                                                 name:@"UITextViewTextDidChangeNotification"
                                               object:_mainTextView];
}

#pragma mark - <TextViewDelegate>

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""])
    {
        return YES;
    }
    
    if (_mainTextView.text.length >= 140)
    {
        return NO;
    }
    
    if (range.length == 0 && range.location >= 140)
    {
        NSString *inputString = [NSString stringWithFormat:@"%@%@",
                                 _mainTextView.text,
                                 text];
        NSString *str = [inputString substringToIndex:140];
        _mainTextView.text=str;
        
        return NO;
    }
    
    return YES;
}

- (void)textViewEditChanged:(NSNotification *)obj
{
    _mainTextView = (UITextView *)obj.object;
    
    if (_mainTextView.text.length > 140)
    {
        _mainTextView.text = _appendContent;
    }
    else
    {
        _appendContent = _mainTextView.text;
    }
    if ([_mainTextView.text isEqualToString:@""])
    {
        _placeholderLabel.hidden = NO;
    }
    else
    {
        _placeholderLabel.hidden = YES;
    }
    _bottomNumberLabel.text = [NSString stringWithFormat:@"还可输入%@字",@(140 - _mainTextView.text.length)];
}

- (void)initNavigation
{

    [self setNavTitle:@"意见反馈"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(commitButtonClick:)]];

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

/// 提交
- (void)commitButtonClick:(UIButton *)button
{
    if ([self isBlankString:_mainTextView.text])
    {
        [CustomAlertMessage showAlertMessage:@"提交内容不可为空\n\n"
                             andButtomHeight:APP_SCREEN_HEIGHT/2];
    }
    else
    {
        [self showLoadingView:@""];
        UserFeedBackApi *userFeedBackApi = [[UserFeedBackApi alloc] init];
        userFeedBackApi.content = _mainTextView.text;
        [_manager sendRequest:userFeedBackApi];
    }

}

- (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[ConfirmSuccessEntity class]])
    {
        [self hiddenLoadingView];
        
        ConfirmSuccessEntity *confirmSuccessEntity = [DataConvert convertDic:data toEntity:modelClass];
        if ([confirmSuccessEntity.result integerValue] == 0)
        {
            [CustomAlertMessage showAlertMessage:@"提交成功\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [CustomAlertMessage showAlertMessage:@"提交失败\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];

        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
