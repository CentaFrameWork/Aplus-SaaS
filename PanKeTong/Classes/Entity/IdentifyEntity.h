//
//  IdentifyEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface IdentifyEntity : SubBaseEntity<MTLJSONSerializing>

@property (nonatomic, copy)NSString * uId;
@property (nonatomic, copy)NSString * uName;
@property (nonatomic, copy)NSString * departId;
@property (nonatomic, copy)NSString * departName;
@property (nonatomic, copy)NSString * userNo;

@end
