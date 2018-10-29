//
//  MyMessageEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/12/1.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MyMessageEntity.h"
#import "MyMessageResultEntity.h"
@implementation MyMessageEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return  @{
            @"messages":@"Messages",
            @"recordCount":@"RecordCount",
              };
}
+(NSValueTransformer *)messagesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MyMessageResultEntity class]];
}



@end
