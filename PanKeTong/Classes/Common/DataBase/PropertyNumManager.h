//
//  PropertyNumManager.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseManager.h"

/// 查看过房号的房源keyId
@interface PropertyNumManager : BaseManager

- (void)insertKeyIdOfCheckedRoomNum:(NSString *)propKeyId
                         andStaffNo:(NSString *)staffNo
                            andDate:(NSString *)date;

- (NSMutableArray *)selectAllKeyIdOfCheckedRoomNumWithStaffNo:(NSString *)staffNo
                                                      andDate:(NSString *)date;

@end
