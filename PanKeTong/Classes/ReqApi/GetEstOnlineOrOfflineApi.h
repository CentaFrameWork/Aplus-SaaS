//
//  GetEstOnlineOrOfflineApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
#define OnLine 1
#define OffLine 2

///上架或下架
@interface GetEstOnlineOrOfflineApi : APlusBaseApi

@property (nonatomic,assign)NSInteger getEstSetType;
@property (nonatomic,strong)NSArray *keyIds;//广告keyId

@end
