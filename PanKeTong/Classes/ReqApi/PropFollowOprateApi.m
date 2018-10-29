//
//  PropFollowOprateApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PropFollowOprateApi.h"

@implementation PropFollowOprateApi

- (NSDictionary *)getBody
{
    NSString *keyid = @"keyids";
    
    if ([CommonMethod isRequestFinalApiAddress])
    {
        keyid = @"KeyIds";
    }
    
    return @{
             keyid:_keyids,
             @"PropertyKeyId":_PropertyKeyId
             };
}


- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        if (self.PropFollowOprateType == ConfirmPropFollow) {
            //确认跟进
            return @"property/follow-batch-confirm";
        }
        //删除跟进
        return @"property/follow-batch-remove";
    }


    if (self.PropFollowOprateType == ConfirmPropFollow) {
        //确认跟进
        return @"WebApiProperty/property-follow-batch-confirm";
    }
    //删除跟进
    return @"WebApiProperty/property-follow-batch-remove";

}


- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}



@end
