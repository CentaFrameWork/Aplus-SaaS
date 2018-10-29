//
//  CallRealPhoneManager.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseManager.h"

/// 拨打过真实电话的所有房源KeyId
@interface CallRealPhoneManager : BaseManager

- (void)insertCallRealPhoneWithStaffNo:(NSString *)staffNo
                          andPropKeyId:(NSString *)propKeyId
                               andDate:(NSString *)date;

- (NSInteger)selectCountForStaffNo:(NSString *)staffNo
                           andDate:(NSString *)date;

- (void)deleteRealPhoneForStaffNo:(NSString *)staffNo
                          andDate:(NSString *)date;

- (BOOL)isExistWithStaffNo:(NSString *)staffNo
              andPropKeyId:(NSString *)propKeyId
                   andDate:(NSString *)date;

@end
