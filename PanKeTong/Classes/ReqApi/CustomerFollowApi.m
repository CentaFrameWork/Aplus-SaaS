//
//  CustomerFollowApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CustomerFollowApi.h"
#import "CustomerFollowEntity.h"

@implementation CustomerFollowApi


- (NSDictionary *)getBody
{
    return @{
             @"InquiryKeyId":_inquiryKeyId,
             @"FollowTypeKeyId":_followTypeKeyId,
             @"PageIndex":_pageIndex,
             @"PageSize":_pageSize,
             @"SortField":_sortField,
             @"Ascending":_ascending
             };


}

//客户跟进
- (NSString *)getPath {
    
    return @"inquiry/follows";
    

}


- (Class)getRespClass
{
    return [CustomerFollowEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}

@end
