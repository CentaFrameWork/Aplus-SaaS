//
//  CustomerEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface CustomerEntity : SubBaseEntity

@property (nonatomic,strong) NSString *customerKeyId;//客户Id
@property (nonatomic,strong) NSString *customerName;//客户名称
@property (nonatomic,strong) NSString *inquiryStatusKeyId;//客户状态id
@property (nonatomic,strong) NSString *inquiryTradeType;//求租，求购，租购
@property (nonatomic,strong) NSString *houseType;//房型
@property (nonatomic,strong) NSString *houseDirection;//朝向
@property (nonatomic,strong) NSString *area;//面积
@property (nonatomic,strong) NSString *salePrice;//售价
@property (nonatomic,strong) NSString *rentPrice;//租价
@property (nonatomic,strong) NSString *houseFloor;//楼层
@property (nonatomic,strong) NSString *decorationSituation;//装修情况
@property (nonatomic,assign) BOOL isVip;//是否vip
@property (nonatomic,strong) NSString *districts;//城区
@property (nonatomic,strong) NSString *areas;//片区
@property (nonatomic,assign) BOOL male;//男女
@property (nonatomic,strong) NSString *roomType;//户型
@property (nonatomic,strong) NSString *regDate;//登记日期
@property (nonatomic,copy) NSString *remark;//备注

@end
