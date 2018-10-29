//
//  CheckHttpErrorUtil.m
//  PanKeTong
//
//  Created by 王雅琦 on 2018/1/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "CheckHttpErrorUtil.h"
#import "Error.h"

 static CheckHttpErrorUtil *checkErrorUtil = nil;

@implementation CheckHttpErrorUtil

+ (NSString *)handleError:(Error *)error
{
//    [self hiddenLoadingView];
    
    NSString *msg = @"";
    
    switch (error.httpCode)
    {
        case 400:
        {
            msg = @"处理失败";
            NSLog(@"Http Network Protocal: 服务端业务逻辑处理失败！");
        }
            break;
            
        case 404:
        {
            msg = @"请求失败";
            NSLog(@"Http Network Protocal: 请检查你的请求地址！");
        }
            break;
            
        case 500:
        {
            msg = @"服务器内部出错";
            NSLog(@"Http Network Protocal: 请联系Api开发人员检查服务器代码！");
        }
            break;
        case 1011:
        {
            msg = @"服务器内部出错";
            NSLog(@"Http Network Protocal: 请联系Api开发人员检查服务器代码！");
        }
            break;
            
        default:
        {
            msg = @"";
        }
            break;
    }
    
    if (![NSString isNilOrEmpty:msg])
    {
        return msg;
    }
    
    if ([@"A connection failure occurred" isEqualToString:error.rDescription])
    {
        return @"无法连接服务器，请稍后再试!";
    }
    else if ([@"The request timed out" isEqualToString:error.rDescription])
    {
        return @"网络不给力，请稍后再试!";
    }
    else if ([error.rDescription rangeOfString:@"SSL"].location != NSNotFound)
    {
        // 连接到需要认证的wifi环境
        return(@"网络不给力，请稍后再试!");
    }
    else if ([error.rDescription rangeOfString:@"500"].location != NSNotFound)
    {
        return @"服务器内部出错";
    }
    else
    {
        NSString *errorMsg = error.rDescription;
        
        if (error.rDescription)
        {
            if ([error.rDescription isEqualToString:@"数据为空"])
            {
                [CustomAlertMessage showAlertMessage:@"没有找到符合条件的信息\n\n"
                                     andButtomHeight:APP_SCREEN_HEIGHT/2];
            }
            else
            {
                return errorMsg;
            }
        }
    }
    
    return @"";
}


@end
