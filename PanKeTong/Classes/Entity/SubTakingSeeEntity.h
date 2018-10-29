//
//  SubTakingSeeEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/6.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "SubBaseEntity.h"

///约看记录二级实体
@interface SubTakingSeeEntity : SubBaseEntity<NSCopying>
/*
 ReserveTime - 约看时间 (Nullable`1)
 TakeSeeTime - 带看时间 (Nullable`1)
 ReserveKeyId - 约看KeyId (Nullable`1)
 TakeSeeKeyId - 带看KeyId (Nullable`1)
 CustomerNo - 客户编号 (String)
 CustomerName - 客户 (String)
 Mobile-客户手机号
 InquiryKeyId - 客源KeyId (Nullable`1)
 CustomerKeyId - 客户KeyId (Nullable`1)
 InquiryTradeTypeKeyId - 客源交易类型KeyId (Nullable`1)
 PropertyKeyId - 房源KeyId (Nullable`1)
 EstateKeyId - 关联的楼盘字典，楼盘对象KeyId (Nullable`1)
 BuildingKeyId - 关联的楼盘字典，栋座对象KeyId (Nullable`1)
 HouseKeyId - 关联的楼盘字典，房对象KeyId (Nullable`1)
 SeePropertyType - 看房类型（全部=null、看租=10、看售=20、看租售=30） (String)
 EstateName - 楼盘名称 (String)
 BuildingName - 栋座单元 (String)
 HouseNo - 房号 (String)
 PropertyInfo - 楼盘信息，格式为楼盘名称+栋座单元+房号的拼接字符串 (String)
 Floor - 楼层 (Nullable`1)
 FloorAll - 栋座总层数 (Nullable`1)
 CountF - 几室 (Nullable`1)
 CountT - 几厅 (Nullable`1)
 CountW - 几卫 (Nullable`1)
 CountY - 几阳台 (Nullable`1)
 Square - 面积 (Nullable`1)
 SalePrice - 售价 (Nullable`1)
 RentPrice - 租价 (Nullable`1)
 Content - 反馈 (String)
 ContentNext - 下一步计划 (String)
 PropertyNo - 房源编号 (String)
 CreateUserKeyId - 带看人KeyId (Nullable`1)
 UserName - 业务员名称（带看人） (String)
 DepartmentKeyId - 部门KeyId (Nullable`1)
 DepartmentName - 部门名称 (String)
 AgreementNo - 看房协议编号 (String)
 TrustType - 委托类型 (String)
 LookWithUserKeyId - 陪看人ID (Nullable`1)
 LookWithUserName - 陪看人 (String)
 AttachmentName - 附件名称 (String)
 AttachmentPath - 附件路径 (String)
 */

@property (nonatomic,copy)NSString *reserveTime;//约看时间
@property (nonatomic,copy)NSString *takeSeeTime;//带看时间
@property (nonatomic,copy)NSString *reserveKeyId;//约看KeyId
@property (nonatomic,copy)NSString *takeSeeKeyId;//带看KeyId
@property (nonatomic,copy)NSString *customerNo;//客户编号
@property (nonatomic,copy)NSString *customerName;//客户
@property (nonatomic,copy)NSString *mobile;//客户手机号
@property (nonatomic,copy)NSString *inquiryKeyId;//客源KeyId
@property (nonatomic,copy)NSString *customerKeyId;//客户KeyId
@property (nonatomic,copy)NSString *inquiryTradeTypeKeyId;//客源交易类型KeyId
@property (nonatomic,copy)NSString *propertyKeyId;//房源KeyId
@property (nonatomic,copy)NSString *estateKeyId;//关联的楼盘字典，楼盘对象KeyId
@property (nonatomic,copy)NSString *buildingKeyId;//关联的楼盘字典，栋座对象KeyId
@property (nonatomic,copy)NSString *houseKeyId;//关联的楼盘字典，房对象KeyId
@property (nonatomic,copy)NSString *seePropertyType;//看房类型
@property (nonatomic,copy)NSString *estateName;//楼盘名称
@property (nonatomic,copy)NSString *buildingName;//栋座单元
@property (nonatomic,copy)NSString *houseNo;//房号
@property (nonatomic,copy)NSString *propertyInfo;//楼盘信息，格式为楼盘名称+栋座单元+房号的拼接字符串
@property (nonatomic,copy)NSString *floor;//楼层
@property (nonatomic,copy)NSString *floorAll;//栋座总层数
@property (nonatomic,strong)NSNumber *countF;//几室
@property (nonatomic,strong)NSNumber *countT;//几厅
@property (nonatomic,strong)NSNumber *countW;//几卫
@property (nonatomic,strong)NSNumber *countY;//几阳台
@property (nonatomic,strong)NSNumber *square;//面积
@property (nonatomic,strong)NSNumber *salePrice;//售价
@property (nonatomic,strong)NSNumber *rentPrice;//租价
@property (nonatomic,copy)NSString *content;//反馈
@property (nonatomic,copy)NSString *contentNext;//下一步计划
@property (nonatomic,copy)NSString *propertyNo;//房源编号
@property (nonatomic,copy)NSString *createUserKeyId;//带看人KeyId
@property (nonatomic,copy)NSString *takingUserName;//业务员名称（带看人）
@property (nonatomic,copy)NSString *departmentKeyId;// 部门KeyId
@property (nonatomic,copy)NSString *departmentName;//部门名称
@property (nonatomic,copy)NSString *agreementNo;//看房协议编号
@property (nonatomic,copy)NSString *trustType;//委托类型
@property (nonatomic,copy)NSString *lookWithUserKeyId;//陪看人ID
@property (nonatomic,copy)NSString *lookWithUserName;//陪看人
@property (nonatomic,copy)NSString *attachmentName;// 附件名称
@property (nonatomic,copy)NSString *attachmentPath;//附件路径

@property (nonatomic, strong) NSArray * propertyList;

@end
