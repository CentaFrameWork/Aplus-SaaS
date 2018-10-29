//
//  SubCheckTrustEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/31.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SubBaseEntity.h"

@interface SubCheckTrustEntity : SubBaseEntity

/*
 KeyId - 对象keyid (Nullable`1)
 AttachmentName - 附件名称 (String)
 AttachmentPath - 附件路径 (String)
 AttachmenSysTypeKeyId - 附件类型keyid (Nullable`1)
 AttachmenSysType - 附件类型 (String)
 AttachmenSysTypeName - 附件类型名称 (String)
 */

///北京的返回(前三个)
@property (nonatomic,copy) NSString *keyId;//对象keyid
@property (nonatomic,copy) NSString *attachmentName;//附件名称
@property (nonatomic,copy) NSString *attachmentPath;//附件路径


@property (nonatomic,copy) NSString *attachmenSysTypeKeyId;//附件类型keyid
@property (nonatomic,copy) NSString *attachmenSysType;//附件类型
@property (nonatomic,copy) NSString *attachmenSysTypeName;//附件类型名称

@end
