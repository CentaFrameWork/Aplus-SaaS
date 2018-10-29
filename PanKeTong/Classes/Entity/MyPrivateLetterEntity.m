//
//  MyPrivateLetterEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/12/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MyPrivateLetterEntity.h"
#import "MyPrivateLetterResultEntity.h"
@implementation MyPrivateLetterEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return  @{
              @"messages":@"Messages",
              @"recordCount":@"RecordCount",
              };
}
+(NSValueTransformer *)messagesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MyPrivateLetterResultEntity class]];
}


@end
