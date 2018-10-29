//
//  ModifyPwdApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/2.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "ModifyPwdApi.h"

#import "DESUtil.h"

@implementation ModifyPwdApi


- (NSDictionary *)getBody
{
    
    NSString * oldPwd = [DESUtil encrypWithText:_oldPassword andKey:FINAL_KEY_DES];
    NSString * nowPwd = [DESUtil encrypWithText:_nowPassword andKey:FINAL_KEY_DES];
    NSString * nowPwd2 = [DESUtil encrypWithText:_nowPassword2 andKey:FINAL_KEY_DES];
   
    return @{
             @"OldPassword" : oldPwd,
             @"NewPassword" : nowPwd,
             @"NewPassword2" : nowPwd2,
             };
}

//管理密码
- (NSString *)getPath {

        return @"permission/modify-password";
    

}


- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodPUT;
}

@end
