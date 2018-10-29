//
//  FilterEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterEntity : SubBaseEntity<NSCopying,MTLJSONSerializing>

//客户状态
@property (nonatomic,copy)NSString *clientStatuText;
@property (nonatomic,copy)NSString *clientStatuValue;
//房源交易类型
@property (nonatomic,copy)NSString *estDealTypeText;
@property (nonatomic,copy)NSString *estDealTypeValue;
//客户交易类型
@property (nonatomic,copy)NSString *clientDealTypeText;
@property (nonatomic,copy)NSString *clientDealTypeValue;
//价格类型
@property (nonatomic,copy)NSString *priceType;
//售价
@property (nonatomic,copy)NSString *salePriceText;
@property (nonatomic,copy)NSString *maxSalePrice;
@property (nonatomic,copy)NSString *minSalePrice;
//租价
@property (nonatomic,copy)NSString *rentPriceText;
@property (nonatomic,copy)NSString *maxRentPrice;
@property (nonatomic,copy)NSString *minRentPrice;
//是否输入框输入的价格
@property (nonatomic,assign)BOOL isInpuntPrice;
//标签文字
@property (nonatomic,copy)NSString *tagText;
//是否新上房源
@property (nonatomic,copy)NSString *isNewProInThreeDay;
/// 是否360全景
@property (nonatomic,copy)NSString *isPanorama;
/// 是否免打扰
@property (nonatomic,copy)NSString *isNoCall;
/// 是否有钥匙
@property (nonatomic,copy)NSString *isPropertyKey;
/// 是否有实堪
@property (nonatomic,copy)NSString *isRealSurvey;
//是否推荐
@property (nonatomic,copy)NSString *isRecommend;
//房型
@property (nonatomic,strong)NSMutableArray * roomType;
//房源状态
@property (nonatomic,strong)NSMutableArray * roomStatus;
//房屋现状
@property (nonatomic,copy)NSString *propSituationText;
@property (nonatomic,copy)NSString *propSituationValue;
@property (nonatomic,strong)NSMutableArray *roomSituation;

//房屋等级
@property (nonatomic,copy)NSString *roomLevelText;
@property (nonatomic,copy)NSString *roomLevelValue;
@property (nonatomic,strong)NSMutableArray *roomLevels;

//朝向
@property (nonatomic,strong)NSMutableArray * direction;
//房屋标签
@property (nonatomic,strong)NSMutableArray * propTag;
//建筑类型
@property (nonatomic,strong)NSMutableArray * buildingType;
//建筑面积
@property (nonatomic,copy)NSString *minBuildingArea;
@property (nonatomic,copy)NSString *maxBuildingArea;
//记录等级
@property (nonatomic,assign)NSInteger levelLogButtonTag;
@property (nonatomic,assign)BOOL levelLogButtonSelect;

//记录房源现状
@property (nonatomic,assign)NSInteger propSituationLogButtonTag;
@property (nonatomic,assign)BOOL propSituationLogButtonSelect;

//更多筛选里面的租价
@property (nonatomic,copy)NSString *moreFilterMinRentPrice;
@property (nonatomic,copy)NSString *moreFilterMaxRentPrice;
//更多筛选里面的售价
@property (nonatomic,copy)NSString *moreFilterMinSalePrice;
@property (nonatomic,copy)NSString *moreFilterMaxSalePrice;
//是否是默认的
@property (nonatomic,assign)BOOL isCurrent;
//是否是签约
@property (nonatomic,copy)NSString *isOnlyTrust;
//是否有钥匙
@property (nonatomic,copy)NSString *hasPropertyKey;
//查询类型
@property (nonatomic,copy)NSString *estateSelectType;
//房号
@property (nonatomic, copy)NSString *houseNo;
// 排序字段名称
@property (nonatomic, copy)NSString *sortField;
// 排序顺序
@property (nonatomic, copy)NSString *ascending;
// 是否为委托已审
@property (nonatomic, copy)NSString *isTrustsApproved;
//是否为证件齐全
@property (nonatomic, copy)NSString *isCompleteDoc;
//是否为委托房源
@property (nonatomic,copy) NSString *isTrustProperty;

// 房源编号搜索
@property (nonatomic, copy) NSString *propertyNo;

// 是否有视频
@property (nonatomic, copy) NSString *isVideo;


@end
