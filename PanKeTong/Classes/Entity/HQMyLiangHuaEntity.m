//
//  HQMyLiangHuaEntity.m
//  PanKeTong
//
//  Created by 中原管家 on 2016/11/24.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "HQMyLiangHuaEntity.h"

@implementation HQMyLiangHuaEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{

    return @{@"userKeyId":@"userKeyId",
             @"employeeName":@"employeeName",
             @"departmentKeyId":@"departmentKeyId",
             @"parentDepartmentKeyId":@"parentDepartmentKeyId",
             @"departmentName":@"departmentName",
             @"departmentNo":@"departmentNo",
             @"startDate":@"startDate",
             @"endDate":@"endDate",
             @"level":@"level",
             @"type":@"type",
             @"dateType":@"dateType",
             @"remark":@"remark",
             @"column":@"column",
             @"sDate":@"sDate",
             @"theNewInquirysCountRent":@"newInquirysCountRent",
             @"theNewInquirysCountSale":@"newInquirysCountSale",
             @"dragInquirysCountRent":@"dragInquirysCountRent",
             @"dragInquirysCountSale":@"dragInquirysCountSale",
             @"inquirysCountSaleSum":@"inquirysCountSaleSum",
             @"inquirysCountRentSum":@"inquirysCountRentSum",
             @"theNewPropertysCountRent":@"newPropertysCountRent",
             @"theNewPropertysCountSale":@"newPropertysCountSale",
             @"propertysCountRentSum":@"propertysCountRentSum",
             @"propertysCountSaleSum":@"propertysCountSaleSum",
             @"keysRent":@"keysRent",
             @"exclusive":@"exclusive",
             @"realSurvey":@"realSurvey",
             @"propertyFllow":@"propertyFllow",
             @"takeSeeRent":@"takeSeeRent",
             @"takeSeeSale":@"takeSeeSale",
             @"takeSeeSum":@"takeSeeSum",
             @"inquiryFllow":@"inquiryFllow",
             @"commission":@"commission",
             @"officialWebsite":@"officialWebsite",
             @"clone":@"clone",
             @"changeCount":@"changeCount",
             @"browsePhoneCount":@"browsePhoneCount",
             @"exclusiveEntrustCount":@"exclusiveEntrustCount",
             @"virtualNumberCount":@"virtualNumberCount",
             @"channelInquiryCount":@"channelInquiryCount",
             
             };
}
@end
