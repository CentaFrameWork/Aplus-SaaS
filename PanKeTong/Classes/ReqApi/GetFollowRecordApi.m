//
//  GetFollowRecordApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetFollowRecordApi.h"
#import "FollowRecordEntity.h"

@implementation GetFollowRecordApi


- (NSDictionary *)getBody
{
    _pageIndex = _pageIndex?_pageIndex:@"";
    _pageSize = _pageSize?_pageSize:@"";
    _isDetails = _isDetails?_isDetails:@"";
    _propKeyId = _propKeyId?_propKeyId:@"";
    
    return @{
             @"PageIndex":_pageIndex,
             @"PageSize":_pageSize,
             @"IsDetails":_isDetails,
             @"PropertyKeyId":_propKeyId,
             @"FollowTypeKeyId":_followTypeKeyId?_followTypeKeyId:@"",
             };
}

- (NSString *)getPath {
   
 
    return @"property/follows";
 
    
}

- (Class)getRespClass {
    return [FollowRecordEntity class];
}
- (int)getRequestMethod {
    
    return RequestMethodGET;
}
@end
