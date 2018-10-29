//
//  SearchRemindPersonApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/4.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "SearchRemindPersonApi.h"
#import "RemindPersonListEntity.h"

@implementation SearchRemindPersonApi


- (NSDictionary *)getBody
{
    
//    NSDictionary *dic =  @{
//                           @"AutoCompleteType":_autoCompleteType,
//                           @"KeyWords":[_keyWords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
//                           @"ExceptMe":@(_exceptMe),
//                           @"TopCount":@"10",
//                           @"DepartmentKeyId":_departmentKeyId,
//                           };
    
    return @{
             @"AutoCompleteType":_autoCompleteType,
             @"KeyWords":[_keyWords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             @"ExceptMe":_exceptMe?@"true":@"false",
             @"TopCount":@"10",
             @"DepartmentKeyId":_departmentKeyId,
             };

}

//搜索提醒人或部门
- (NSString *)getPath
{
    
        return @"common/user-depart-auto-complete";
    
}


- (Class)getRespClass
{
    return [RemindPersonListEntity class];
}
- (int)getRequestMethod {
    
    return RequestMethodGET;
}


@end
