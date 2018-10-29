//
//  PropLeftFollowApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PropLeftFollowApi.h"
#import "PropLeftFollowEntity.h"

@implementation PropLeftFollowApi


- (NSDictionary *)getBody
{
    return @{
             @"FollowTypeKeyId":_followTypeKeyId,
             @"PropertyKeyId":_propertyKeyId,
             @"FollowTimeFrom":_followTimeFrom == nil?@"":_followTimeFrom,
             @"FollowTimeTo":_followTimeTo,
             @"Keyword":[_keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             @"FollowPersonKeyId":_followPersonKeyId,
             @"FollowDeptKeyId":_followDeptKeyId,
             @"PageIndex":_pageIndex,
             @"PageSize":_pageSize,
             @"SortField":_sortField,
             @"Ascending":@"true",
             @"IsDetails":@"true",
             };
}


- (NSString *)getPath {
    

    return @"property/left-follow";
    

}


- (Class)getRespClass
{
    return [PropLeftFollowEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}

@end
