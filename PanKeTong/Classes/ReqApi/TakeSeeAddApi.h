//
//  TakeSeeAddApi.h
//  PanKeTong
//
//  Created by 张旺 on 16/12/15.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

///新增带看
@interface TakeSeeAddApi : APlusBaseApi

/**
 AgreementNo - 看房协议编号 (String)
 ContentNext - 下一步计划 (String)
 RentPrice - 租价 (String)
 ReserveKeyId - 约看KeyId (Nullable`1)
 SalePrice - 售价 (Nullable`1)
 SeePropertyType - 看房类型（全部=null、看租=10、看售=20、看租售=30） (String)
 TakeSeeTime - 带看时间 (String)
 LookWithKeyId - 陪看人KeyId (String)
 AttachmentName - 附件名称 (String)
 AttachmentPath - 附件路径 (Boolean)
 IsMobileRequest - 是否是手机端请求 (Boolean)
 Content - 反馈 (String)
 CustumerKeyId - 客户 (String)
 InquiryKeyId - 客源 (String)
 PropertyKeyId - 房源 (String)
 MsgUserKeyIds  - 跟进站内信对应人 (String)
 MsgDeptKeyIds  - 跟进站内信对应部门 (String)
 */

@property (nonatomic,copy)NSString *agreementNo;
@property (nonatomic,copy)NSString *contentNext;//广州没有
@property (nonatomic,copy)NSString *rentPrice;
@property (nonatomic,copy)NSString *reserveKeyId;
@property (nonatomic,copy)NSString *salePrice;
@property (nonatomic,copy)NSString *seePropertyType;
@property (nonatomic,copy)NSString *takeSeeTime;
@property (nonatomic,copy)NSString *lookWithKeyId;
@property (nonatomic,copy)NSString *attachmentName;
@property (nonatomic,copy)NSString *attachmentPath;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *custumerKeyId;
@property (nonatomic,copy)NSString *inquiryKeyId;
@property (nonatomic,copy)NSString *propertyKeyId;
@property (nonatomic,strong)NSArray *msgUserKeyIds;
@property (nonatomic,strong)NSArray *msgDeptKeyIds;
@property (nonatomic,copy)NSString *msgTime;

//选择的房源
@property (nonatomic,strong) NSArray *selectPropertyArr;

//陈行修改320bug
@property (nonatomic, copy) NSString * lookWithUserName;





























@end
