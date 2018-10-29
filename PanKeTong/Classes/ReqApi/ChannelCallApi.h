//
//  ChannelCallApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//


#import "APlusBaseApi.h"
#define ChannelCall 1 //渠道来电
#define ChannelCustomer 2//渠道公客池

///渠道来电或渠道公客池
@interface ChannelCallApi : APlusBaseApi

@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *phoneLike;
@property (nonatomic,copy)NSString *channelSourceStr;
@property (nonatomic,copy)NSString *startDate;
@property (nonatomic,copy)NSString *endDate;
@property (nonatomic,copy)NSString *chiefDeptKeyId;
@property (nonatomic,copy)NSString *chiefKeyId;
@property (nonatomic,copy)NSString *publicAccountKeyId;
@property (nonatomic,copy)NSString *channelInquiryRange;
@property (nonatomic,copy)NSString *pageIndex;
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,copy)NSString *sortField;
@property (nonatomic,copy)NSString *ascending;

@property (nonatomic,assign)NSInteger channelType;

@end
