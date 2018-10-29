//
//  MyQuantificationApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/29.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "MyQuantificationApi.h"
#import "MyQuantificationEntity.h"
#import "GetQuantificationEntitiy.h"

@implementation MyQuantificationApi

- (NSDictionary *)getBody
{
    if(![CityCodeVersion isTianJin])
    {
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:OnlyDateFormat];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];

    NSDictionary *jsonDic = @{
                              @"UserKeyId":_userKeyId,
                              @"DepartmentKeyId":_DepartmentKeyId,
                              @"StartDate":dateString,
                              @"EndDate":dateString,
                              };
    return jsonDic;
    }
    
    return nil;

}


//获取我的工作量化
- (NSString *)getPath
{
    if([CityCodeVersion isTianJin]||[CityCodeVersion isNanJing]||[CityCodeVersion isChongQing]
       ||[CityCodeVersion isChangSha]||[CityCodeVersion isHangZhou])
    {
        if ([CommonMethod isRequestNewApiAddress])
        {
            return @"center/my-quantification";
        }
        return @"WebApiCenter/get_my_quantification";
    }
    else
    {
        if ([CommonMethod isRequestNewApiAddress])
        {
            return @"center/opm-quantification-employee";
        }
        return @"WebApiCenter/get_from_opm_quantification";
    }
    
    return nil;
}


- (Class)getRespClass
{
    if([CityCodeVersion isTianJin] || [CityCodeVersion isNanJing]||[CityCodeVersion isChongQing]||[CityCodeVersion isChangSha]){
        //天津&南京&重庆
        return [MyQuantificationEntity class];
    }else{
        //北京&深圳&天津&横琴澳门&广州
        return [GetQuantificationEntitiy class];
    }
    
    return nil;
}


@end
