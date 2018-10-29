//
//  EditPropertyApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/23.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "EditPropertyApi.h"

@implementation EditPropertyApi

- (NSDictionary *)getBody
{

    return @{
             @"Square":(_square == nil)?@"0":_square,
             @"SquareUse":(_squareUse == nil)?@"0":_squareUse,
             @"RentPrice":(_rentPrice == nil)?@"0":_rentPrice,
             @"SalePrice":(_salePrice == nil)?@"0":_salePrice,
             @"HouseDirectionKeyId":_houseDirectionKeyId,
             @"PropertyRightNatureKeyId":_propertyRightNatureKeyId,
             @"PropertyUsageKeyId":_propertyUsageKeyId,
             @"TrustType":_trustType,
             @"KeyId":_keyId
             };
}



- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"property/property-edit";
    }
    return @"WebApiProperty/property-edit";
}


- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}


@end
