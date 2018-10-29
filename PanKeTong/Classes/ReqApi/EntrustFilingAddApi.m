//
//  EntrustFilingAddApi.m
//  PanKeTong
//
//  Created by 张旺 on 2017/7/21.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "EntrustFilingAddApi.h"

@implementation EntrustFilingAddApi

- (NSDictionary *)getBody
{
    NSDictionary *dic = @{
                          
                          @"KeyId":_keyId,
                          @"PropertyKeyId":_propertyKeyId,
                          @"PropertyEntrustType":_propertyEntrustType,
                          @"SignDate":_signDate,
                          @"SignUserKeyId":_signUserKeyId,
                          @"SignUserName":_signUserName,
                          @"SignDeptKeyId":_signDeptKeyId,
                          @"CreateUserKeyId":_createUserKeyId,
                          @"CreateDeptKeyId":_createDeptKeyId,
                          @"CreateTime":_createTime,
                          @"CorporationKeyId":_corporationKeyId,
                          @"CityKeyId":_cityKeyId,
                          @"Vsersion":_vsersion,
//                          @"TrustAuditState":_trustAuditState,
                          @"TrustAuditDate":_trustAuditDate,
                          @"TrustAuditPersonKeyId":_trustAuditPersonKeyId,
                          @"Attachments":_attachments,
                          @"IsMobileRequest":@"true",
                          };
    return dic;
}

- (NSString *)getPath {
    if (self.commitEntrustfilingType == AddEntrustFiling) {
       
        return @"property/property-trust-record-add";
  
    }else{
       return @"property/property-trust-record-modify";
        
    }
    
    
}

- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}

- (int)getRequestMethod {
    
    if (self.commitEntrustfilingType == AddEntrustFiling) {
   
        return RequestMethodPOST;
   
    }else{
        
         return RequestMethodPUT;
    }
    
   
}

@end

@implementation Attachments

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId ? _keyId:@"",
             @"AttachmentName":_attachmentName ? _attachmentName:@"",
             @"AttachmentPath":_attachmentPath ? _attachmentPath:@"",
             @"AttachmenSysTypeKeyId":_attachmenSysTypeKeyId ? _attachmenSysTypeKeyId:@"",
             @"AttachmenSysType":_attachmenSysType ? _attachmenSysType:@"",
             @"AttachmenSysTypeName":_attachmenSysTypeName ? _attachmenSysTypeName:@"",
             };
}

@end
