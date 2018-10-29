//
//  ReleaseEstListResultEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/20.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface ReleaseEstListResultEntity : SubBaseEntity


@property (nonatomic,strong)NSString * postId;
@property (nonatomic,strong)NSString * advertKeyid;
@property (nonatomic,strong)NSString * displayEstName;
@property (nonatomic,strong)NSString * displayAddress;
@property (nonatomic,assign)double nArea;
@property (nonatomic,assign)NSInteger roomCnt;
@property (nonatomic,assign)double sellPrice;
@property (nonatomic,assign)double rentalPrice;
@property (nonatomic,strong)NSString * defaultImage;
@property (nonatomic,strong)NSString * expiredTime;
@property (nonatomic,strong)NSString * updateTime;
@property (nonatomic,assign)NSInteger hallCnt;
@property (nonatomic,assign)NSInteger toiletCnt;
@property (nonatomic,strong)NSString * opDate;
@property (nonatomic,strong)NSString * propertyType;
@property (nonatomic,assign)NSInteger floor;
@property (nonatomic,assign)NSInteger floorTotal;
@property (nonatomic,strong)NSString * direction;
@property (nonatomic,strong)NSString * fitment;
@property (nonatomic,assign)double unitSellPrice;
@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSString * staffNo;
@property (nonatomic,strong)NSString * isOnline;
@property (nonatomic,strong)NSString * createTime;
@property (nonatomic,assign)NSInteger regionId;
@property (nonatomic,assign)NSInteger districtId;
@property (nonatomic,assign)NSInteger propertyTypeId;
@property (nonatomic,strong)NSString * floorDisplay;
@property (nonatomic,assign)double gArea;
@property (nonatomic,assign)BOOL propertyStatus;
@property (nonatomic,assign)NSInteger balconyCnt;
@property (nonatomic,assign)NSInteger kitchenCnt;
@property (nonatomic,strong)NSString * postType;
@property (nonatomic,assign)BOOL withLease;
@property (nonatomic,strong)NSString * keywords;
@property (nonatomic,strong)NSString * remarkNo;
@property (nonatomic,assign)BOOL isFollow;
@property (nonatomic,assign)BOOL isSole;
@property (nonatomic,assign)NSInteger postTag;
@property (nonatomic,strong)NSString * staffName;
@property (nonatomic,strong)NSString * staffMobile;
@property (nonatomic,assign)NSInteger postStatus;
@property (nonatomic,strong)NSString * rotatedIn;
@property (nonatomic,strong)NSString * postScore;
@property (nonatomic,strong)NSString * agentScore;
@property (nonatomic,assign)BOOL flag;
@property (nonatomic,strong)NSString * errorMsg;
@property (nonatomic,strong)NSString * runTime;

/// <summary>
/// 广告交易类型
/// </summary>
@property (nonatomic,assign)NSInteger tradeType;
/// <summary>
/// 房源交易类型
/// </summary>
@property (nonatomic,assign)NSInteger trustType;



@end
