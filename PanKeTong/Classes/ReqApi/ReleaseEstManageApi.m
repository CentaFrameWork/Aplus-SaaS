//
//  ReleaseEstManageApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "ReleaseEstManageApi.h"
#import "ReleaseEstListEntity.h"

@implementation ReleaseEstManageApi

- (NSDictionary *)getBody
{
    
    NSString *pageIndex = @"pageindex";
    NSString *pageSize = @"pagesize";
    NSString *postType = @"posttype";
    NSString *postStatus = @"poststatus";
    
    if ([CommonMethod isRequestFinalApiAddress])
    {
        pageIndex = @"PageIndex";
        pageSize = @"PageSize";
        postType = @"PostType";
        postStatus = @"PostStatus";
    }

    if (self.ReleaseEstManageType == ReleaseEstManage)
    {
        // 放盘管理
        return @{
                 @"staffno" : _staffno ? _staffno:@"",
                 pageIndex : _pageindex ? _pageindex:@"1",
                 pageSize : @"10",
                 postType : _posttype ? _posttype:@"",
                 postStatus : _poststatus ? _poststatus:@""
                 };
    }

    // 刷新放盘管理
    return @{
             @"postid" : _postid ? _postid:@"",
             @"staffno" : _staffno ? _staffno:@"",
             };
}


- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        if (self.ReleaseEstManageType == ReleaseEstManage) {
            // 放盘管理
            return @"advert/properties";

        }

        return @"advert/batch-refresh";

    }
    if (self.ReleaseEstManageType == ReleaseEstManage) {
        // 放盘管理
        return @"WebApiAdvert/advert-propertys";
        
    }

    return @"WebApiAdvert/advert-property-refresh";
}


- (Class)getRespClass
{
    return [ReleaseEstListEntity class];
}


@end
