//
//  BJTurnPrivateCustomerBasePresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BJTurnPrivateCustomerBasePresenter.h"

@implementation BJTurnPrivateCustomerBasePresenter

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        _selfView = delegate;
    }
    return self;
}

/// 检查座机
- (NSString *)checkTelephoneAreaCode:(NSString *)areaCodeString andTel:(NSString *)telString andExtension:(NSString *)extensionString
{
    if (extensionString.length > 0 || areaCodeString.length > 0) {
        if (telString.length == 0) {
            return @"请输入座机号码!";
        }
    }
    
    if (telString.length > 0 && [telString startWith:@"0"]) {
        return @"座机号不可以\"0\"开头!";
    }
    
    if ((areaCodeString.length > 0 && ![CommonMethod validateNumber:areaCodeString] )||
        (telString.length > 0 && ![CommonMethod validateNumber:telString]) ||
        (extensionString.length > 0 && ![CommonMethod validateNumber:extensionString])) {
        
        return @"请输入正确的手机号码!";
    }
    
    return nil;
}

/// 获得座机号
- (NSString *)getTelephoneNumWithAreaCode:(NSString *)areaCodeString andTel:(NSString *)telString andExtension:(NSString *)extensionString andPhoneNum:(NSString *)phoneNum
{
    NSString *fullTelString = @"";
    
    if ([CommonMethod isMobile:phoneNum])
    {
        if (telString.length > 0) {
            fullTelString = [NSString stringWithFormat:@"%@-%@-%@",
                              areaCodeString?areaCodeString:@"",
                              telString,
                              extensionString?extensionString:@""];
        }
    }
    else
    {
        fullTelString = [NSString stringWithFormat:@"-%@-",phoneNum];
    }
    
    return fullTelString;
}

/// 最大座机电话位数
- (NSInteger)getTelMaxCount
{
    return 13;
}

/// 最小座机电话位数
- (NSInteger)getTelMinCount
{
    return 0;
}

@end
