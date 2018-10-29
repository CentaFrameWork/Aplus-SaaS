//
//  AddTakingSeeApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/16.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "AddTakingSeeApi.h"
#import "SelectPropertyEntity.h"

@implementation AddTakingSeeApi

- (NSDictionary *)getBody {
    NSMutableArray *mArr = [NSMutableArray array];
    NSDictionary *dic = @{
                          @"ReserveTime":_reserveTime,
                          @"InquiryKeyId":_inquiryKeyId,
                          @"MsgUserKeyIds":_msgUserKeyIds,
                          @"MsgDeptKeyIds":_MsgDeptKeyIds,
                          @"MsgTime":_msgTime==nil?@"":_msgTime
                          };
    [mArr addObject:dic];
    NSDictionary *pragramDic;
    if ([CommonMethod isRequestNewApiAddress]) {
        pragramDic = @{@"Reserves":mArr};
    } else {
        pragramDic = @{@"InquiryFollows":mArr};
    }
    mArr = nil;
    return pragramDic;
}

- (NSString *)getPath {
    
        return @"Inquiry/add-reserve-follow";
    
}

- (Class)getRespClass {
    return [AgencyBaseEntity class];
}

//- (int)getRequestMethod {
//    
//    return RequestMethodGET;
//}

@end
