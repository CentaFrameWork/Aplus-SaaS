//
//  EntrustFilingEditDetailEntity.h
//  PanKeTong
//
//  Created by 张旺 on 2017/7/28.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SubBaseEntity.h"

@interface EntrustFilingEditDetailEntity : SubBaseEntity

/**
 Value - 备案信息 (PropertyTrustRecordsDetail)
 KeyId - 备案记录ID (String)
 PropertyKeyId - 房源ID (String)
 PropertyEntrustType - 备案类型 (String)
 SignDate - 签署日期 (String)
 SignUserKeyId - 签署人Id (String)
 SignUserName - 签署人姓名 (String)
 SignDeptKeyId - 签署人部门ID (String)
 CreateUserKeyId - 创建人ID (String)
 CreateDeptKeyId - 创建人部门ID (String)
 CreateTime - 创建日期 (String)
 CorporationKeyId - 所属公司 (String)
 CityKeyId - 所属城市 (String)
 Vsersion - 版本 (String)
 TrustAuditState - 审批状态 (String)
 TrustAuditDate - 审批时间 (String)
 TrustAuditPersonKeyId - 审批人 (String)
 Attachments - 备案所属附件集合 (String)
 ContactPersons - 联系人及部门集合 (String)
 */

@property (nonatomic,copy)NSString *keyId;
@property (nonatomic,copy)NSString *propertyKeyId;
@property (nonatomic,copy)NSString *propertyEntrustType;
@property (nonatomic,copy)NSString *signDate;
@property (nonatomic,copy)NSString *signUserKeyId;
@property (nonatomic,copy)NSString *signUserName;
@property (nonatomic,copy)NSString *signDeptKeyId;
@property (nonatomic,copy)NSString *createUserKeyId;
@property (nonatomic,copy)NSString *createDeptKeyId;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *corporationKeyId;
@property (nonatomic,copy)NSString *cityKeyId;
@property (nonatomic,copy)NSString *vsersion;
@property (nonatomic,copy)NSString *trustAuditState;
@property (nonatomic,copy)NSString *trustAuditDate;
@property (nonatomic,copy)NSString *trustAuditPersonKeyId;
@property (nonatomic,copy)NSArray *attachmentArray;

@end

@interface AttachmentArray : SubBaseEntity

/**
 AttachmentName - 附件名称 (String)
 AttachmentPath - 附件路径 (String)
 AttachmenSysTypeKeyId - 附件类型keyid (String)
 AttachmenSysType - 附件类型 (String)
 AttachmenSysTypeName - 附件类型名称 (String)
 */
@property (nonatomic,copy)NSString *keyId;
@property (nonatomic,copy)NSString *attachmentName;
@property (nonatomic,copy)NSString *attachmentPath;
@property (nonatomic,copy)NSString *attachmenSysTypeKeyId;
@property (nonatomic,copy)NSString *attachmenSysType;
@property (nonatomic,copy)NSString *attachmenSysTypeName;

@end
