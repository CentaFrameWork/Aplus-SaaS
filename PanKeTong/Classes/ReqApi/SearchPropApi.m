//
//  SearchPropApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/4.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "SearchPropApi.h"
#import "SearchPropEntity.h"

@implementation SearchPropApi

- (NSDictionary *)getBody
{
    return @{
             @"Name":[_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             @"TopCount":_topCount,
             @"BuildName":_buildName.length > 0 ? [_buildName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : @"",
             @"EstateSelectType":_estateSelectType?_estateSelectType:[NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME]
             };
}

//搜索通盘房源
- (NSString *)getPath {
    
    
    return @"property/auto-estate";
    
}

- (Class)getRespClass
{
    return [SearchPropEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}
@end
