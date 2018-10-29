//
//  ChannelDetailModel.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/28.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface ChannelDetailModel : SubBaseEntity

@property (nonatomic,assign) NSInteger callId;
@property (nonatomic,strong) NSString *channelInquirySource;
@property (nonatomic,strong) NSString *otherNetComment;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *callerTimespan;
@property (nonatomic,assign) NSInteger calledStatus;
@property (nonatomic,strong) NSString *recordingUrl;

@end
