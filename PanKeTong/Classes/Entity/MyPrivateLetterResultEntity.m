//
//  MyPrivateLetterResultEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/12/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MyPrivateLetterResultEntity.h"

@implementation MyPrivateLetterResultEntity


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
