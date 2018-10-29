//
//  MyMessageResultEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/12/1.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MyMessageResultEntity.h"

@implementation MyMessageResultEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"keyId":@"KeyId",
             @"lastMsgContent":@"LastMsgContent",
             @"lastMsgTime":@"LastMsgTime",
             @"notReadCount":@"NotReadCount",
             @"secondMessagerImageUrl":@"SecondMessagerImageUrl",
             @"secondMessagerKeyId":@"SecondMessagerKeyId",
             @"secondMessagerName":@"SecondMessagerName",
             @"waitReply":@"WaitReply",
             };
}
@end
