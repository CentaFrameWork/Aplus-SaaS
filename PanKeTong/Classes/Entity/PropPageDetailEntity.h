//
//  PropPageDetailEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface PropPageDetailEntity : AgencyBaseEntity

@property (nonatomic, copy) NSString *allHouseInfo;  //房源信息
@property (nonatomic, copy) NSString *estateName;    //楼盘名
@property (nonatomic, copy) NSString *buildingName;  //栋座名
@property (nonatomic, copy) NSString *houseNo;       //房号

@property (nonatomic, copy) NSString *salePrice;
@property (nonatomic, copy) NSString *saleUnitPrice;
@property (nonatomic, copy) NSString *rentPrice;
@property (nonatomic, copy) NSString *roomType;    // 户型
@property (nonatomic, copy) NSString *houseDirection;
@property (nonatomic, copy) NSString *floor;
@property (nonatomic, copy) NSString *propertySituation;
@property (nonatomic, copy) NSString *propertyCardClassName;
@property (nonatomic, copy) NSString *propertyTags;
@property (nonatomic, assign) NSInteger remainingBrowseCount;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *districtName;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *square;      // 建筑面积
@property (nonatomic, copy) NSString *squareUse;      // 实用面积
@property (nonatomic, copy) NSString *squareEdit;     //编辑面积
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, copy) NSString *propertyUsage;  // 物业用途
@property (nonatomic, copy) NSString *propertyStatus;   // 当前房源状态
@property (nonatomic, copy) NSString *hasRegisterTrusts;//是否有房源
@property (nonatomic, copy) NSString *entrustKeepOnRecord;// 委托
@property (nonatomic, copy) NSString *noCallMessage;    // 没有免扰房和独家权限的提示

/// <summary>
/// 房源所属人KeyId
/// </summary>
@property (nonatomic, copy) NSString *propertyChiefKeyId;

/// <summary>
/// 房源所属部门KeyId
/// </summary>
@property (nonatomic, copy) NSString *propertyChiefDepartmentKeyId;

/// <summary>
/// 房源交易人KeyId
/// </summary>
@property (nonatomic, copy) NSString *propertyTraderKeyId;

/// <summary>
/// 房源交易人所属部门KeyId
/// </summary>
@property (nonatomic, copy) NSString *propertyTraderDepartmentKeyId;

/// <summary>
/// 房源状态四大分类枚举：1-有效，2-暂缓，3-预定，4-无效
/// </summary>
@property (nonatomic,assign) NSNumber *propertyStatusCategory;

/// <summary>
/// CCAI回写委托类型（出售=1、出租=2）
/// </summary>
@property (nonatomic,assign) NSNumber *cCAIReturnTrustType;

/**
 *  带看次数
 */
@property (nonatomic, copy)NSString *takeSeeCount;


/**
 *  图片路径
 */
@property (nonatomic, copy)NSString *photoPath;


/**
 *  委托类型（出售=1、出租=2、租售=3
 */
@property (nonatomic, copy)NSString *trustType;

/**
 *  审批状态 -1 无委托信息 0 待审核 1 审核通过 2 审核拒绝
 */
@property (nonatomic, copy)NSString *trustAuditState;

/**
 *  房源数据操作权限code集合
 */
@property (nonatomic, copy)NSString *departmentPermissions;


//  售价(参考值)  港币
@property (nonatomic, copy)NSString *salePriceReferent;

// 原购价(参考值)
@property (nonatomic, copy)NSString *oldSalePriceReferent;

// 面积:125m²(参考值)
@property (nonatomic, copy)NSString *squareReferent;

// 售价单价(参考值)
@property (nonatomic, copy)NSString *saleUnitPriceReferent;

// 租价(参考值)
@property (nonatomic, copy)NSString *rentPriceReferent;

// 实用面积(参考值)
@property (nonatomic, copy)NSString *squareUseReferent;

// 花园面积(参考值)
@property (nonatomic, copy)NSString *squareGardenReferent;

// 是否为澳盘
@property (nonatomic, copy)NSString *isMacau;
// 装修情况
@property (nonatomic, copy) NSString *decorationSituation;

// 房源编号(广州虚拟号传参需要)
@property (nonatomic, copy) NSString *propertyNo;

// 一周内带看次数
@property (nonatomic, strong) NSNumber *latelyTakeSeeDay7Count;

// 最近带看时间
@property (nonatomic, copy) NSString *latelyTakeSeeTime;

// 实勘总数
@property (nonatomic, copy) NSNumber *realSurveyCount;

// 房型
@property (nonatomic, copy) NSString *houseType;


@end
