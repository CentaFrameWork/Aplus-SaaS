//
//  getQuantificationSubEntitiy.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/26.
//  Copyright © 2016年 苏军朋. All rights reserved.


#import "SubBaseEntity.h"

///北京二级实体
@interface GetQuantificationSubEntitiy : SubBaseEntity

/*
 "browsePhoneCount": "sample string 1",
 "newProSale": "sample string 2",
 "newProRent": "sample string 3",
 "newProRentSale": "sample string 4",
 "actProSale": "sample string 5",
 "actProRent": "sample string 6",
 "actProRentSale": "sample string 7",
 "keysSum": "sample string 8",
 "keysSale": "sample string 9",
 "keysRent": "sample string 10",
 "keysRentSale": "sample string 11",
 "proFollowSum": "sample string 12",
 "validProFollow": "sample string 13",
 "invalidProFollow": "sample string 14",
 "priceChange": "sample string 15",
 "exclusive": "sample string 16",
 "realSurveyPhoto": "sample string 17",
 "reservePro": "sample string 18",
 "takeSeePro": "sample string 19",
 "takeSeeInqSum": "sample string 20",
 "takeSeeInqSale": "sample string 21",
 "takeSeeInqRent": "sample string 22",
 "newInq": "sample string 23",
 "actInq": "sample string 24",
 "dragInq": "sample string 25",
 "inqFollow": "sample string 26"
 */


@property (nonatomic,copy)NSString *browsePhoneCount;//查看业主电话
@property (nonatomic,copy)NSString *quantificationNewProSale;//出售新增（房源)
@property (nonatomic,copy)NSString *quantificationNewProRent;//出租新增（房源）
@property (nonatomic,copy)NSString *quantificationNewProRentSale;//租售新增（房源)
@property (nonatomic,copy)NSString *actProSale;//出售激活（房源）
@property (nonatomic,copy)NSString *actProRent;//出租激活（房源）
@property (nonatomic,copy)NSString *actProRentSale;//租售激活（房源）
@property (nonatomic,copy)NSString *keysSum;//钥匙新增
@property (nonatomic,copy)NSString *keysSale;//钥匙新增-售盘
@property (nonatomic,copy)NSString *keysRent;//钥匙新增-租盘
@property (nonatomic,copy)NSString *keysRentSale;//钥匙新增-租售
@property (nonatomic,copy)NSString *proFollowSum;//房源跟进
@property (nonatomic,copy)NSString *validProFollow;//房源跟进（有效）
@property (nonatomic,copy)NSString *invalidProFollow;//房源跟进（非有效）
@property (nonatomic,copy)NSString *priceChange;//价格调整
@property (nonatomic,copy)NSString *exclusive;//委托新增
@property (nonatomic,copy)NSString *realSurveyPhoto;//照片
@property (nonatomic,copy)NSString *reservePro;//约看
@property (nonatomic,copy)NSString *takeSeePro;//带看房源
@property (nonatomic,copy)NSString *takeSeeInqSum;//带看客户量
@property (nonatomic,copy)NSString *takeSeeInqSale;//看售-客户数量
@property (nonatomic,copy)NSString *takeSeeInqRent;//看租-客户数量
@property (nonatomic,copy)NSString *quantificationNewInq;//客户新增
@property (nonatomic,copy)NSString *actInq;//客户激活
@property (nonatomic,copy)NSString *dragInq;//公客转私客
@property (nonatomic,copy)NSString *inqFollow;//客户跟进

/////天津特有
//@property (nonatomic,copy)NSString *realSurvey;//新增实勘
//@property (nonatomic,copy)NSString *propertyFllow;//房源跟进
//@property (nonatomic,copy)NSString *newInquirysCountRent;//新增客源





@end
