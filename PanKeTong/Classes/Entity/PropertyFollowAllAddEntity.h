//
//  PropertyFollowAllAddEntity.h
//  PanKeTong
//
//  Created by TailC on 16/4/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//
/*
 PropertyKeyId - 房源KeyId (Guid)
 FollowType - 跟进类型 (FollowTypeEnum)
 ContactsName - 联系人名称集合 (List`1)
 FollowContent - 跟进内容 (String)
 Mobile - 委托人手机 (String)
 TrustorName - 委托人姓名 (String)
 TrustorTypeKeyId - 委托人类型KeyId (String)
 TrustorGenderKeyId - 委托人性别 (String)
 TrustorRemark - 委托人备注 (String)
 telphone1 - 委托人座机号1 (String)
 telphone2 - 委托人座机号2 (String)
 telphone3 - 委托人座机号3 (String)
 TrustType - 交易类型 (String)
 OpeningType - 开盘类型 (String)
 OpeningPersonName - 开盘人姓名集合 (String)
 OpeningDepName - 开盘人部门名称集合 (String)
 RentPrice - 租价 (Nullable`1)
 RentPer - 租价变动百分比 (Nullable`1)
 SalePrice - 售价 (Nullable`1)
 SalePer - 售价变动百分比 (Nullable`1)
 OpeningPersonKeyId - 开盘人KeyId集合 (String)
 OpeningDepKeyId - 开盘人所属部门KeyId集合 (String)
 TargetDepartmentKeyId - 目标部门KeyId (Guid)
 TargetUserKeyId - 目标用户KeyId (Guid)
 MsgUserKeyIds - 跟进站内信对应人 (List`1)
 MsgDeptKeyIds - 跟进站内信对应部门 (List`1)
 MsgTime - 消息发送时间 (Nullable`1)
 KeyId - KeyId (Nullable`1)
 IsMobileRequest - 是否是手机端请求 (Boolean)
*/

#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@interface PropertyFollowAllAddEntity :  MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger FollowType;

@property (nonatomic, strong) NSString *SalePer;

@property (nonatomic, copy) NSString *TrustorGenderKeyId;

@property (nonatomic, copy) NSString *FollowContent;

@property (nonatomic, strong) NSArray<NSString *> *MsgDeptKeyIds;

@property (nonatomic, strong) NSArray<NSString *> *MsgUserKeyIds;

@property (nonatomic, copy) NSString *TrustorRemark;

@property (nonatomic, copy) NSString *OpeningType;

@property (nonatomic, copy) NSString *OpeningPersonName;

@property (nonatomic, copy) NSString *KeyId;

@property (nonatomic, copy) NSString *TrustorName;

@property (nonatomic, copy) NSString *telphone1;

@property (nonatomic, copy) NSString *telphone3;

@property (nonatomic, copy) NSString *TrustorTypeKeyId;

@property (nonatomic, strong) NSString *RentPrice;

@property (nonatomic, copy) NSString *Mobile;

@property (nonatomic, copy) NSString *OpeningPersonKeyId;

@property (nonatomic, copy) NSString *OpeningDepKeyId;

@property (nonatomic, strong) NSString *SalePrice;

@property (nonatomic, copy) NSString *PropertyKeyId;

@property (nonatomic, copy) NSString *TargetDepartmentKeyId;

@property (nonatomic, copy) NSString *MsgTime;

@property (nonatomic, copy) NSString *IsMobileRequest;

@property (nonatomic, strong) NSArray<NSString *> *ContactsName;

@property (nonatomic, strong) NSArray<NSString *> *InformDepartsName;

@property (nonatomic, strong) NSString *RentPer;

@property (nonatomic, copy) NSString *TrustType;

@property (nonatomic, copy) NSString *telphone2;

@property (nonatomic, copy) NSString *OpeningDepName;

@property (nonatomic, copy) NSString *TargetUserKeyId;

@property (nonatomic, copy) NSString *MobileAttribution;
@end
