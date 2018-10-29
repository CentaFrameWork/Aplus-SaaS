//
//  PublishEstOrCustomerApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/3.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
#define GetPublishEstateList 1//抢公盘
#define GetPublishEstDetail 2 //公盘详情
#define GetPublishCustomerList 3//抢公客
#define GetPublishCustomerDetail 4//公客详情
#define TransferPrivateInquiry 5//公客转私客

/// 抢公盘、公盘详情、抢公客、公客详情
@interface PublishEstOrCustomerApi : APlusBaseApi

@property (nonatomic,copy)NSString *keyId;
@property (nonatomic,copy)NSString *contactName;
@property (nonatomic,copy)NSString *inquiryKeyId;

@property (nonatomic,assign)NSInteger requestType;


@end
