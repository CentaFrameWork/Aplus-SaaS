//
//  MyMessageInfoDetailResultEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/12/2.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MyMessageInfoDetailResultEntity.h"

@implementation MyMessageInfoDetailResultEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"keyId":@"KeyId",
             @"messageKeyId":@"MessageKeyId",
             @"senderKeyId":@"SenderKeyId",
             @"senderNo":@"SenderNo",
             @"senderName":@"SenderName",
             @"senderPhotoPath":@"SenderPhotoPath",
             @"msgContent":@"MsgContent",
             @"msgTime":@"MsgTime",
             @"messageType":@"MessageType",
             @"secondMessagerName":@"SecondMessagerName",
             @"secondMessagerPhotoPath":@"SecondMessagerPhotoPath",
             @"secondEmployeeNo":@"SecondEmployeeNo",
             @"propertyKeyId":@"PropertyKeyId",
             @"inquiryKeyId":@"InquiryKeyId",
             };
}

@end
