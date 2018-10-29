//
//  MyClientApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "MyClientApi.h"

@implementation MyClientApi


- (NSDictionary *)getBody
{
   NSDictionary *dict =  @{
             @"PrivateInquiryRange":_privateInquiryRange,
             @"InquiryStatusKeyIds":_inquiryStatusKeyIds,
             @"ContactType":_contactType,
             @"ContactContent":_contactContent,
             @"HouseTypeKeyIds":_houseTypeKeyIds,
             @"InquiryTag":_inquiryTag,
             @"IsExpire30Day":_isExpire30Day,
             @"InquiryTradeTypeKeyId":_inquiryTradeTypeKeyId,
             @"SalePriceFrom":_salePriceFrom,
             @"SalePriceTo":_salePriceTo,
             @"RentPriceFrom":_rentPriceFrom,
             @"RentPriceTo":_rentPriceTo,
             @"PageIndex":_pageIndex,
             @"PageSize":_pageSize,
             @"SortField":_sortField,
             @"Ascending":_ascending,
             @"SearchKey":_searchKey,
             @"ChiefKeyId":_chiefKeyId?_chiefKeyId:@"",
             @"ChiefDeptKeyId":_chiefDeptKeyId?_chiefDeptKeyId:@""
             };
    
    
    
    
    
    
    NSString *string = [dict JSONString];
    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, (CFStringRef)@":", kCFStringEncodingUTF8));
    
    return @{@"urlParams":encodedString};
}

//我的客户列表
- (NSString *)getPath
{
    
        return @"inquiry/all";
    

}


- (Class)getRespClass
{
    return [CustomerListEntity class];
}
- (int)getRequestMethod {
    
    return RequestMethodGET;
}

@end
