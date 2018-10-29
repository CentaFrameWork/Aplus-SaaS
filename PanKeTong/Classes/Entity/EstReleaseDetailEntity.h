//
//  EstReleaseDetailEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface EstReleaseDetailEntity : SubBaseEntity

@property (nonatomic,strong)NSString * rentType;
@property (nonatomic,strong)NSString * propertyRight;
@property (nonatomic,strong)NSString * payType;
@property (nonatomic,strong)NSString * tenantType;
@property (nonatomic,strong)NSString * infoDescription;
@property (nonatomic,strong)NSString * opDate;
@property (nonatomic,strong)NSString * displayEstName;
@property (nonatomic,strong)NSString * displayAddress;
@property (nonatomic,strong)NSString * propertyTypeId;
@property (nonatomic,assign)NSInteger floor;
@property (nonatomic,assign)NSInteger floorTotal;
@property (nonatomic,assign)double nArea;
@property (nonatomic,assign)NSInteger roomCnt;
@property (nonatomic,assign)NSInteger hallCnt;
@property (nonatomic,assign)NSInteger toiletCnt;
@property (nonatomic,strong)NSString * direction;
@property (nonatomic,strong)NSString * fitment;
@property (nonatomic,assign)double sellPrice;
@property (nonatomic,assign)double rentalPrice;
@property (nonatomic,strong)NSString * title;
@property (nonatomic,assign)BOOL isOnline;
@property (nonatomic,assign)NSInteger tradeType;
@property (nonatomic,strong)NSString * postId;
@property (nonatomic,strong)NSString * advertKeyid;
@property (nonatomic,strong)NSString * defaultImage;
@property (nonatomic,assign)NSInteger expiredTime;
@property (nonatomic,strong)NSString * propertyType;
@property (nonatomic,assign)double unitSellPrice;
@property (nonatomic,strong)NSString * staffNo;
@property (nonatomic,assign)NSInteger regionId;
@property (nonatomic,assign)NSInteger districtId;
@property (nonatomic,strong)NSString * floorDisplay;
@property (nonatomic,assign)double gArea;
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
@property (nonatomic,strong)NSString * statusMessage;
@property (nonatomic,strong)NSString * regionName;
@property (nonatomic,strong)NSString * districtName;
@property (nonatomic,strong)NSString * rentTyep;
@property (nonatomic,strong)NSString * serviceInfo;
@property (nonatomic,strong)NSString * applianceInfo;
@property (nonatomic,strong)NSString * mgtPrice;
@property (nonatomic,assign)BOOL mgtInclude;
@property (nonatomic,assign)double withLeaseRental;
@property (nonatomic,strong)NSString * withLeaseExpired;
@property (nonatomic,strong)NSString * visitTime;
@property (nonatomic,strong)NSString * defaultImageExt;
@property (nonatomic,strong)NSString * soleExpired;
@property (nonatomic,strong)NSString * staffEmail;
@property (nonatomic,strong)NSString * cestKeywords;
@property (nonatomic,strong)NSString * plainDescription;
@property (nonatomic,strong)NSString * adsNo;
@property (nonatomic,strong)NSString * untCode;
@property (nonatomic,strong)NSString * blgCode;
@property (nonatomic,strong)NSString * estCode;
@property (nonatomic,strong)NSString * bigEstCode;
@property (nonatomic,strong)NSString * rotatedIn;
@property (nonatomic,strong)NSString * postScore;
@property (nonatomic,strong)NSString * agentScore;
@property (nonatomic,strong)NSString * createTime;
@property (nonatomic,strong)NSString * updateTime;
@property (nonatomic,assign)BOOL flag;
@property (nonatomic,strong)NSString * errorMsg;
@property (nonatomic,strong)NSString * runTime;
@property (nonatomic,assign)NSInteger tag;
@property (nonatomic,strong)NSArray * photos;
@end
