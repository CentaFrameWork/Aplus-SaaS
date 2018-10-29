//
//  getQuantificationSubEntitiy.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/26.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetQuantificationSubEntitiy.h"

@implementation GetQuantificationSubEntitiy

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"browsePhoneCount":@"browsePhoneCount",
             @"quantificationNewProSale":@"newProSale",
             @"quantificationNewProRent":@"newProRent",
             @"quantificationNewProRentSale":@"newProRentSale",
             @"actProSale":@"actProSale",
             @"actProRent":@"actProRent",
             @"actProRentSale":@"actProRentSale",
             @"keysSum":@"keysSum",
             @"keysSale":@"keysSale",
             @"keysRent":@"keysRent",
             @"keysRentSale":@"keysRentSale",
             @"proFollowSum":@"proFollowSum",
             @"validProFollow":@"validProFollow",
             @"invalidProFollow":@"invalidProFollow",
             @"priceChange":@"priceChange",
             @"exclusive":@"exclusive",
             @"realSurveyPhoto":@"realSurveyPhoto",
             @"reservePro":@"reservePro",
             @"takeSeePro":@"takeSeePro",
             @"takeSeeInqSum":@"takeSeeInqSum",
             @"takeSeeInqSale":@"takeSeeInqSale",
             @"takeSeeInqRent":@"takeSeeInqRent",
             @"quantificationNewInq":@"newInq",
             @"actInq":@"actInq",
             @"dragInq":@"dragInq",
             @"inqFollow":@"inqFollow"
             };
}


@end
