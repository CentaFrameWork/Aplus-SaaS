//
//  RegisterTrustsApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/25.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "RegisterTrustsApi.h"

@implementation RegisterTrustsApi

- (NSDictionary *)getBody
{
    return @{
             @"BuildingNames":_buildingNames.length > 0?_buildingNames:@"",
             @"HouseNo":_houseNo.length > 0?_houseNo:@"",
             @"CreateTimeFrom":_createTimeFrom,
             @"CreateTimeTo":_createTimeTo,
             @"EstateKeyId":_estateKeyId.length > 0?_estateKeyId:@"",
             @"EstateNames":_estateNames.length >0?_estateNames:@"",
             @"BuildingKeyId":_buildingKeyId.length > 0?_buildingKeyId:@"",
             @"RegTrustsAuditStatus":@(_regTrustsAuditStatus),
             @"CreatorPersonDeptKeyId":_creatorPersonDeptKeyId.length > 0?_creatorPersonDeptKeyId:@"",
             @"CreatorPersonKeyId":_creatorPersonKeyId.length > 0?_creatorPersonKeyId:@"",
             @"AuditPerScope":@(_auditPerScope),
             @"PageIndex":_pageIndex,
             @"PageSize":_pageSize,
             @"SortField":_sortField,
             @"Ascending":_ascending,
             };
}


- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"property/register-trusts";
    }
    return @"WebApiProperty/RegisterTrusts";
}


- (Class)getRespClass
{
    return [RegisterTrustsEntity class];
}


@end
