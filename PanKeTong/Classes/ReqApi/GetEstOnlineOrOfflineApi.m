//
//  GetEstOnlineOrOfflineApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetEstOnlineOrOfflineApi.h"
#import "EstReleaseOnLineOrOffLineEntity.h"

@implementation GetEstOnlineOrOfflineApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyIds":_keyIds?_keyIds:@""
             };
}


- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        if (self.getEstSetType == OnLine) {
            //上架
            return @"advert/batch-online";
        }
        //下架
        return @"advert/batch-offline";
    }


    if (self.getEstSetType == OnLine) {
        //上架
        return @"WebApiAdvert/batch-online";
    }
    //下架
    return @"WebApiAdvert/batch-offline";

}


- (Class)getRespClass
{
    return [EstReleaseOnLineOrOffLineEntity class];
}


@end
