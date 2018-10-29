//
//  ChannelCallModelEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/26.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface ChannelCallModelEntity : SubBaseEntity

@property (nonatomic,strong) NSString *mkeyId;//客户Id
@property (nonatomic,strong) NSString *mphone;//手机号码
@property (nonatomic,strong) NSString *mcreateTime;//创建日期
@property (nonatomic,strong) NSString *mchannelSourceKeyId;//
@property (nonatomic,strong) NSString *mchannelInquirySources;//
@property (nonatomic,strong) NSString *motherNetComments;//
@property (nonatomic,strong) NSString *mchannelInquiryChief;//
@property (nonatomic,strong) NSString *mchannelInquiryChiefDept;//
@property (nonatomic,strong) NSString *mpublicAccount;//
@property (nonatomic, copy) NSString *isMyPayChannelInquiry;

@end
