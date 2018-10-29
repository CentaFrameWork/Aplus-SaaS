//
//  TurnPrivateCustomerApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
#define BJ 1
#define OTHERCITY 2


/// 转私客
@interface TurnPrivateCustomerApi : APlusBaseApi

@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *inquiryStatusKeyId;
@property (nonatomic, copy) NSString *channelInquiryKeyId;
@property (nonatomic, copy) NSString *genderKeyId;
@property (nonatomic, copy) NSString *contactTypeKeyId;
@property (nonatomic, copy) NSString *inquirySourceKeyId;
@property (nonatomic, copy) NSString *buyReasonKeyId;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *inquiryTradeTypeId;
@property (nonatomic, copy) NSString *salePriceFrom;
@property (nonatomic, copy) NSString *salePriceTo;
@property (nonatomic, copy) NSString *rentPriceFrom;
@property (nonatomic, copy) NSString *rentPriceTo;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *isMyPayChannelInquiry;        // 自费/公费

@property (nonatomic,assign)NSInteger TurnPrivateCustomerType;

@end
