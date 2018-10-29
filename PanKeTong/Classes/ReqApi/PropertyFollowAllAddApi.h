//
//  PropertyFollowAllAddApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
#import "PropertyFollowAllAddEntity.h"

#define AddBidding 1    // 深圳叫价
#define AddContact 2    // 深圳新增联系人
#define AddInfo 3       // 新开盘&信息补充

///添加跟进(洗盘，新开盘,新增联系人,信息补充,叫价)
@interface PropertyFollowAllAddApi : APlusBaseApi

@property (nonatomic,strong)PropertyFollowAllAddEntity *entity;
@property (nonatomic,assign)NSInteger propertyFollowAllAddType;
@property (strong, nonatomic) NSArray *addTrustorSortNum;
@property (strong, nonatomic) NSArray *trustorKeyIdList;

@end
