//
//  MessageResultEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MessageResultEntity.h"

@implementation MessageResultEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey

{
   return  @{
             @"informationType":@"InformationType",
             @"informationTypeE":@"InformationTypeE",
             @"createTime":@"CreateTime",
             @"content":@"Content",
             @"informationCategory":@"InformationCategory",
             @"keyId":@"KeyId",
             @"sourceObjectKeyId":@"SourceObjectKeyId"
             };
}

@end
