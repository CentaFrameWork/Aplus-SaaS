//
//  BJTurnPrivateCustomerHZPresenter.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/6/28.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BJTurnPrivateCustomerZJPresenter.h"

@implementation BJTurnPrivateCustomerZJPresenter

/// 检查座机
- (NSString *)checkTelephoneAreaCode:(NSString *)areaCodeString andTel:(NSString *)telString andExtension:(NSString *)extensionString
{
    if (areaCodeString.length <= 0) {
        return @"请输入区号";
    }

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

/// 获得座机电话
- (NSString *)getTelephoneNumWithAreaCode:(NSString *)areaCodeString andTel:(NSString *)telString andExtension:(NSString *)extensionString andPhoneNum:(NSString *)phoneNum
{
    NSString *fullTelString = @"";

    if (areaCodeString.length <= 0 && telString.length <= 0) {

        fullTelString = @"";

    }else{

        if (telString.length > 0) {
            fullTelString = [NSString stringWithFormat:@"%@-%@-%@",
                             areaCodeString?areaCodeString:@"",
                             telString,
                             extensionString?extensionString:@""];
        }
    }

    return fullTelString;
}


@end
