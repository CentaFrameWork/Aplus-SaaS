//
//  GetTJQuantificationSubEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/9/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "GetTJQuantificationSubEntity.h"

@implementation GetTJQuantificationSubEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{

    return @{
//             @"userKeyId":@"userKeyId",
//             @"employeeName":@"employeeName",
             @"departmentKeyId":@"departmentKeyId",
             @"departmentName":@"departmentName",
             @"departmentNo":@"departmentNo",
//             @"startDate":@"startDate",
//             @"endDate":@"endDate",
             @"level":@"level",
             @"dateType":@"dateType",
             @"tjNewInquirysCountRent":@"newInquirysCountRent",
             @"tjNewInquirysCountSale":@"newInquirysCountSale",
             @"dragInquirysCountRent":@"dragInquirysCountRent",
             @"dragInquirysCountSale":@"dragInquirysCountSale",
             @"inquirysCountSaleSum":@"inquirysCountSaleSum",
             @"inquirysCountRentSum":@"inquirysCountRentSum",
             @"tjNewPropertysCountRent":@"newPropertysCountRent",
//             @"transferPropertysCountRent":@"TransferPropertysCountRent",
//             @"performancePropertysCountRent":@"PerformancePropertysCountRent",
             @"tjNewPropertysCountSale":@"newPropertysCountSale",
//             @"transferPropertysCountSale":@"TransferPropertysCountSale",
//             @"performancePropertysCountSale":@"PerformancePropertysCountSale",
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
             @"commission":@"Commission",
             @"officialWebsite":@"officialWebsite",
             @"clone":@"clone",
             @"changeCount":@"changeCount",
             @"browsePhoneCount":@"browsePhoneCount",
//             @"currentDay":@"currentDay"
             };
}


@end
