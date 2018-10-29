//
//  ChannelDetailModel.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/28.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "ChannelDetailModel.h"

@implementation ChannelDetailModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"callId":@"CallId",
             @"channelInquirySource":@"ChannelInquirySource",
             @"otherNetComment":@"OtherNetComment",
             @"startTime":@"StartTime",
             @"callerTimespan":@"CallerTimespan",
             @"calledStatus":@"CalledStatus",
             @"recordingUrl":@"RecordingUrl"
             };
    
}





@end
