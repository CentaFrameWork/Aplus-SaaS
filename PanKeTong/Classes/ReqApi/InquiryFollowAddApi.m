//
//  InquiryFollowAddApi.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/19.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "InquiryFollowAddApi.h"

@implementation InquiryFollowAddApi

- (NSDictionary *)getBody
{
    _content = _content ? _content : @"";
    _custumerKeyId = _custumerKeyId ? _custumerKeyId : @"";
    _inquiryKeyId = _inquiryKeyId ? _inquiryKeyId :@"";
    _followTypeKeyId = _followTypeKeyId ? _followTypeKeyId :@"";
    _followTypeCode = _followTypeCode ? _followTypeCode :@"";
    _msgUserKeyIds = _msgUserKeyIds ? _msgUserKeyIds : @[];
    _msgDeptKeyIds = _msgDeptKeyIds ? _msgDeptKeyIds : @[];
    _msgTime = _msgTime ? _msgTime : @"";


    return @{
             @"Content":_content,
             @"CustumerKeyId":_custumerKeyId,
             @"InquiryKeyId":_inquiryKeyId,
             @"FollowTypeKeyId":_followTypeKeyId,
             @"FollowTypeCode":_followTypeCode,
             @"MsgUserKeyIds":_msgUserKeyIds,
             @"MsgDeptKeyIds":_msgDeptKeyIds,
             @"ContactsName":(_contactsName == nil) ? @[]:_contactsName,
             @"informDepartsName":(_informDepartsName == nil)?@[]:_informDepartsName,
             @"MsgTime":_msgTime,
             };

}

- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress])
    {
        return @"inquiry/add-follow";
    }
    return @"WebApiCustomer/inquiry-other-follow-add";
}

- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}

@end
