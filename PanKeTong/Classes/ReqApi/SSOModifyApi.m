//
//  SSOModifyApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "SSOModifyApi.h"

@implementation SSOModifyApi

- (NSDictionary *)getBody
{
    
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",_empNo,_passWord,@"!2#$%A+*"];
    

    return @{
             @"StaffNo":_empNo,
             @"Password":_passWord,
             @"AppNo":@"A+",
             @"Sign":[sign md5],
             };
}


- (NSString *)getPath
{
    return @"";
}


- (Class)getRespClass
{
    return [NSDictionary class];
}


@end
