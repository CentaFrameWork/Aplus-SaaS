//
//  EntrustFilingEditDetailEntity.m
//  PanKeTong
//
//  Created by 张旺 on 2017/7/28.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "EntrustFilingEditDetailEntity.h"

@implementation EntrustFilingEditDetailEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
              @"keyId":@"KeyId",
              @"propertyKeyId":@"PropertyKeyId",
              @"propertyEntrustType":@"PropertyEntrustType",
              @"signDate":@"SignDate",
              @"signUserKeyId":@"SignUserKeyId",
              @"signUserName":@"SignUserName",
              @"signDeptKeyId":@"SignDeptKeyId",
              @"createUserKeyId":@"CreateUserKeyId",
              @"createDeptKeyId":@"CreateDeptKeyId",
              @"createTime":@"CreateTime",
              @"corporationKeyId":@"CorporationKeyId",
              @"cityKeyId":@"CityKeyId",
              @"vsersion":@"Vsersion",
              @"trustAuditState":@"TrustAuditState",
              @"trustAuditDate":@"TrustAuditDate",
              @"trustAuditPersonKeyId":@"TrustAuditPersonKeyId",
              @"attachmentArray":@"Attachments",
             };
    
}

+(NSValueTransformer *)attachmentArrayJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[AttachmentArray class]];
}

@end



@implementation AttachmentArray

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{

             @"keyId":@"KeyId",
             @"attachmentName":@"AttachmentName",
             @"attachmentPath":@"AttachmentPath",
             @"attachmenSysTypeKeyId":@"AttachmenSysTypeKeyId",
             @"attachmenSysType":@"AttachmenSysType",
             @"attachmenSysTypeName":@"AttachmenSysTypeName",
             };

}

@end