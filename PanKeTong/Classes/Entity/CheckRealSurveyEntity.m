//
//  CheckRealSurveyEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/18.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CheckRealSurveyEntity.h"

@implementation CheckRealSurveyEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSString *propertyRoomTypePhotoIsHav = @"PropertyRoomTypePhotoIsHav";
    
    if ([CommonMethod isRequestFinalApiAddress])
    {
        propertyRoomTypePhotoIsHav = @"PropertyRoomTypePhotoIsHave";
    }
    
    NSDictionary *dic = [self getBaseFieldWithOthers:@{
                                                       @"realSurveyComment":@"RealSurveyComment",
                                                       @"photos":@"Photos",
                                                       @"propertyRoomTypePhotoIsHav":propertyRoomTypePhotoIsHav,
                                                       @"decorationSituation":@"DecorationSituation"
                                                       }];
    NSLog(@"%@",dic);
    return dic;
}

+(NSValueTransformer *)photosJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PhotoEntity class]];
}


@end
