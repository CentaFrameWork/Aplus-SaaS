//
//  AddPropertyFollowApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/4.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AddPropertyFollowApi.h"

@implementation AddPropertyFollowApi


- (NSDictionary *)getBody
{
    return @{
             @"FollowType":_followType,
             @"ContactsName":_contactsName,
             @"InformDepartsName":_informDepartsName,
             @"FollowContent":_followContent,
             @"TargetPropertyStatusKeyId":_targetPropertyStatusKeyId,
             @"TrustorTypeKeyId":_trustorTypeKeyId,
             @"TrustorName":_trustorName,
             @"TrustorGenderKeyId":_trustorGenderKeyId,
             @"Mobile":_mobile,
             @"KeyId":_keyId,
             @"MsgUserKeyIds":_msgUserKeyIds,
             @"MsgDeptKeyIds":_msgDeptKeyIds,
             @"MsgTime":_msgTime,
             };
}


//添加跟进
- (NSString *)getPath
{
    if ([CommonMethod isRequestFinalApiAddress])
    {
        return @"property/add-follow";
    }
    
    if ([CommonMethod isRequestNewApiAddress])
    {
        return @"property/add-follow";
    }
    
    return @"WebApiProperty/add_propety_follow";
}


- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}


@end
