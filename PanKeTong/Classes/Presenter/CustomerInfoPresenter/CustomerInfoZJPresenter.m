//
//  CustomerInfoHZPresenter.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/7/5.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CustomerInfoZJPresenter.h"

@implementation CustomerInfoZJPresenter

/// 是否可以拨打电话
- (BOOL)canCallPhoneWithCustomerDetailEntity:(CustomerDetailEntity *)customerDetailEntity {
    
    // 本人客户
    NSString *myID = [AgencyUserPermisstionUtil getIdentify].uId;
    if ([customerDetailEntity.chiefKeyId isEqualToString:myID])
    {
        return YES;
    }
    
    // 查看本部客源并勾选联系人电话
    if ([AgencyUserPermisstionUtil hasRight:CUSTOMER_CONTACTINFORMATION_SEARCH_MYDEPARTMENT]
        && [AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_MYDEPARTMENT])
    {
        NSString *departmentKeyIds = [AgencyUserPermisstionUtil getAgencyPermisstion].departmentKeyIds;
        if ([departmentKeyIds contains:customerDetailEntity.chiefDeptKeyId])
        {
            return YES;
        }
        
        return NO;
    }
    
    // 查看全部客源并勾选联系人电话
    if ([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_ALL]
        && [AgencyUserPermisstionUtil hasRight:CUSTOMER_CONTACTINFORMATION_SEARCH_ALL])
    {
        return YES;
    }
    
    return NO;
    
    
   
//
//
//    BOOL isAble = [AgencyUserPermisstionUtil hasRight:CUSTOMER_CONTACTINFORMATION_SEARCH_ALL];
//    if (!isAble)
//    {
//        return NO;
//    }
//
//    return YES;
}

@end
