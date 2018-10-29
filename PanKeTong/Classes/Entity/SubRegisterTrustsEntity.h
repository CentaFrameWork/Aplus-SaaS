//
//  SubRegisterTrustsEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/26.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SubBaseEntity.h"

@interface SubRegisterTrustsEntity : SubBaseEntity

/*
 KeyId - KeyId (Nullable`1)
 PropertyChiefDeptKeyId - 房源归属部门KeyId（部门） (Guid)
 PersonDeptKeyId - 签署人部门KeyId (Nullable`1)
 PersonDeptDepName - 签署人部门名称 (String)
 CreatorKeyId - 签署人KeyId (Nullable`1)
 CreatorDeptKeyId - 签署人部门KeyId (Nullable`1)
 CreatorPersonName - 签署人名称 (String)
 CreateTime - 创建日期 (Nullable`1)
 SignDate - 签署日期 (Nullable`1)
 PhotoCount - 照片数量 (Nullable`1)
 PropertyStatusKeyId - 房源状态KeyId (Guid)
 RegTrustsAuditStatus - 状态 (Nullable`1)
 BuildinName - 栋座Name (String)
 EstateName - 楼盘Name (String)
 HouseName - 房号号Name (String)
 BuildingKeyId - 楼盘KeyId (Guid)
 EstateKeyId - 楼盘Name (Guid)
 HouseKeyId - 房号号Name (Guid)
 PropertyKeyId - 房源KeyId (Guid)
 HouseType - 房型：2-1-1-1 (String)
 HouseDirection - 朝向 (String)
 TrustAuditPersonKeyId - 审核人KeyId (Nullable`1)
 TrustAuditPersonName - 审核人名称 (String)
 TrustAuditDate - 审核日期 (Nullable`1)
 PropertyTrustType-委托类型
 */

@property (nonatomic,copy) NSString *keyId;//
@property (nonatomic,copy) NSString *propertyChiefDeptKeyId;//房源归属部门KeyId
@property (nonatomic,copy) NSString *personDeptKeyId;//签署人部门KeyId
@property (nonatomic,copy) NSString *personDeptDepName;//签署人部门名称
@property (nonatomic,copy) NSString *creatorKeyId;// 签署人KeyId
@property (nonatomic,copy) NSString *creatorDeptKeyId;//签署人部门KeyId
@property (nonatomic,copy) NSString *creatorPersonName;//签署人名称
@property (nonatomic,copy) NSString *createTime;//创建日期
@property (nonatomic,copy) NSString *signDate;//签署日期
@property (nonatomic,strong) NSNumber *photoCount;//照片数量
@property (nonatomic,copy) NSString *propertyStatusKeyId;//房源状态KeyId
@property (nonatomic,strong) NSNumber *regTrustsAuditStatus;//状态
@property (nonatomic,copy) NSString *buildingName;//栋座Name
@property (nonatomic,copy) NSString *estateName;//楼盘Name
@property (nonatomic,copy) NSString *houseName;//房号
@property (nonatomic,copy) NSString *buildingKeyId;//栋座KeyId
@property (nonatomic,copy) NSString *estateKeyId;//楼盘keyid
@property (nonatomic,copy) NSString *houseKeyId;//房号keyid
@property (nonatomic,copy) NSString *propertyKeyId;//房源KeyId
@property (nonatomic,copy) NSString *houseType;//房型：2-1-1-1
@property (nonatomic,copy) NSString *houseDirection;//朝向
@property (nonatomic,copy) NSString *trustAuditPersonKeyId;//审核人KeyId
@property (nonatomic,copy) NSString *trustAuditPersonName;//审核人名称
@property (nonatomic,copy) NSString *trustAuditDate;//审核时间
@property (nonatomic,strong) NSNumber *propertyTrustType;//备案类型(出售－1，出租－2，租售－3)





@end
