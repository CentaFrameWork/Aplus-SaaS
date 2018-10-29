//
//  GetPropListApi.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
#import "FilterEntity.h"

/// 获取通盘房源列表
@interface GetPropListApi : APlusBaseApi

@property (nonatomic, copy) NSString *propListTyp;      // 列表数据类型（通盘房源:1，我的贡献:3，我的收藏:5;
@property (nonatomic, strong) NSArray *propertyTypes;   // 房型
@property (nonatomic, strong) NSArray *popStatus;       //房源状态数据
@property (nonatomic, copy) NSString *trustType;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *searchKeyWord;
@property (nonatomic,copy) NSString *keywordType;       //关键字属于什么类型（全部、行政区、楼盘、地理片区）
@property (nonatomic, copy) NSString *pageIndex;
@property (nonatomic, copy) NSString *pageSize;

// 房源现状
@property (nonatomic,strong)NSString *propSituationValue;
// 房屋等级
@property (nonatomic,strong)NSString *roomLevelValue;
// 朝向
@property (strong, nonatomic)NSArray *houseDirection;
// 房屋标签
@property (strong, nonatomic) NSArray *propertyboolTag;
// 是否新上房源
@property (nonatomic, copy) NSString *isNewProInThreeDay;
/// 是否360全景
@property (nonatomic,copy)NSString *isPanorama;
/// 是否免打扰
@property (nonatomic,copy)NSString *isNoCall;
/// 是否有钥匙
@property (nonatomic,copy)NSString *isPropertyKey;
/// 是否有实堪
@property (nonatomic,copy)NSString *isRealSurvey;
// 建筑类型
@property (nonatomic, strong) NSArray *buildTypes;
// 建筑面积
@property (nonatomic,strong)NSString *minBuildingArea;
@property (nonatomic,strong)NSString *maxBuildingArea;
// 租价
@property (nonatomic, copy) NSString *rentPriceText;
@property (nonatomic, copy) NSString *maxRentPrice;
@property (nonatomic, copy) NSString *minRentPrice;
// 售价
@property (nonatomic, copy) NSString *salePriceText;
@property (nonatomic, copy) NSString *maxSalePrice;
@property (nonatomic, copy) NSString *minSalePrice;

// 查询类型
@property (nonatomic, copy) NSString *estateSelectType;

// 是否推荐
@property (nonatomic, copy) NSString *isRecommend;

// 是否有钥匙
@property (nonatomic, copy) NSString *hasPropertyKey;

// 是否是签约
@property (nonatomic, copy) NSString *isOnlyTrust;

// 房号
@property (nonatomic, copy) NSString *houseNo;

// 排序字段
@property (nonatomic, copy) NSString *sortField;

// 排序 (true or false)
@property (nonatomic, copy) NSString *ascending;

// 是否为委托已审
@property (nonatomic, copy) NSString *isTrustsApproved;

// 是否是证件齐全
@property (nonatomic,copy) NSString *isCredentials;

// 是否为委托房源
@property (nonatomic,copy) NSString *isHasRegisterTrusts;

// 选择的栋座单元名称条件,多栋座单元用","分隔
@property (nonatomic,copy) NSString *buildingNames;

// 房源编号
@property (nonatomic, copy) NSString *propertyNo;

/// 是否有视频
@property (nonatomic, copy) NSString *isVideo;

//是否精确搜索，=1精确搜索
@property (nonatomic, copy) NSString * houseNoType;

- (NSDictionary *)getBody;

@end
