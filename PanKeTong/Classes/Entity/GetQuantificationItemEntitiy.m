//
//  getQuantificationItemEntitiy.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/5/6.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetQuantificationItemEntitiy.h"

@implementation GetQuantificationItemEntitiy
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"propertysCountSaleSum":@"PropertysCountSaleSum",
             @"propertysCountRentSum":@"PropertysCountRentSum",
             @"inquirysCountSaleSum":@"InquirysCountSaleSum",
             @"inquirysCountRentSum":@"InquirysCountRentSum",
             @"propertyFllow":@"PropertyFllow",
             @"inquiryFllow":@"InquiryFllow",
             @"takeSeeSale":@"TakeSeeSale",
             @"takeSeeRent":@"TakeSeeRent",
             @"keysRent":@"KeysRent",
             @"exclusiveEntrustCount":@"exclusiveEntrustCount",
             @"exclusive":@"Exclusive",
             @"realSurvey":@"RealSurvey",
             @"changeCount":@"ChangeCount",
             @"browsePhoneCount":@"BrowsePhoneCount",
             @"dragInquirysCountSale":@"DragInquirysCountSale",
             @"dragInquirysCountRent":@"DragInquirysCountRent",
             @"virtualNumberCount":@"virtualNumberCount",
             @"channelInquiryCount":@"channelInquiryCount",
             @"deptKeyId":@"DeptKeyId",
             @"departmentName":@"DepartmentName",
             @"level":@"Level",
             @"departmentNo":@"DepartmentNo",
             @"shortName":@"shortName"
             };
}
@end
