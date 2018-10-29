//
//  PropertysModelEntty.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"
#import "PropertyTagEntity.h"

#define DATABASE_ALREAY_ESTATE_TABLE_NAME @"estate_for_read"

@interface PropertysModelEntty : SubBaseEntity

@property (nonatomic, copy) NSString *completeYear;
@property (nonatomic, strong) NSNumber *trustType;//委托类型（出售=1、出租=2、租售=3）
@property (nonatomic, copy) NSString *estateName;
@property (nonatomic, copy) NSString *buildingName;
@property (nonatomic, copy) NSString *houseNo;
@property (nonatomic, copy) NSString *selectEditEstateName;//外出编辑时候的房源名称
@property (nonatomic, copy) NSString *floor;
@property (nonatomic, copy) NSString *houseType;//房型
@property (nonatomic, copy) NSString *roomType;//户型
@property (nonatomic, copy) NSString *propertyType;
@property (nonatomic, copy) NSString *square;
@property (nonatomic, copy) NSString *houseDirection;
@property (nonatomic, copy) NSString *salePrice;
@property (nonatomic, copy) NSString *salePriceUnit;
@property (nonatomic, strong) NSNumber *realSurveyCount;
@property (nonatomic, copy) NSString *propertyStatus;
@property (nonatomic, strong)NSNumber *propertyStatusCategory;
@property (nonatomic, copy) NSString *rentPrice;
@property (nonatomic, assign) BOOL favoriteFlag; //
@property (nonatomic, assign) BOOL isOnlyTrust;
@property (nonatomic, assign) BOOL propertyKeyEnum;

@property (nonatomic, copy) NSString *photoPath;
@property (nonatomic, strong) NSArray *propertyTags;
@property (nonatomic, copy) NSString *takeToSeeCount;
@property (nonatomic, copy) NSString *keyId;
@property (nonatomic, copy) NSString *isPropertyKey;        // 是否有房源钥匙
@property (nonatomic, copy) NSString *isRegisterTrusts;     


@property (copy, nonatomic) NSString *salePer;
@property (copy, nonatomic) NSString *rentPer;

@property (nonatomic, copy) NSString *entrustKeyId;//押房keyId
@property (nonatomic, copy) NSString *onlyTrustKeyId;//房源签约keyId

// 部门权限
@property (nonatomic,  copy)NSString *departmentPermissions;

@property (nonatomic,  copy)NSString *isMacau;

@property (nonatomic, copy)NSString *hasRegisterTrusts;//是否是委托房源

@property (nonatomic, copy)NSString *isVideoPhotoAddress;

//新增是否已经阅读
@property (nonatomic, assign) BOOL isRead;

@property (nonatomic, copy) NSString *propertySituation;  

@end
