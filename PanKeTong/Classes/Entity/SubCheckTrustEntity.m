//
//  SubCheckTrustEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/31.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SubCheckTrustEntity.h"

@implementation SubCheckTrustEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"keyId":@"KeyId",
             @"attachmentName":@"AttachmentName",
             @"attachmentPath":@"AttachmentPath",
             @"attachmenSysTypeKeyId":@"AttachmenSysTypeKeyId",
             @"attachmenSysType":@"AttachmenSysType",
             @"attachmenSysTypeName":@"AttachmenSysTypeName"
             };
}


@end
