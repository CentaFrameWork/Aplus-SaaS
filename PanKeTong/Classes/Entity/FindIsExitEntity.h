//
//  FindIsExitEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface FindIsExitEntity : AgencyBaseEntity
/*
 KeyId－广告keyID
 PropertyKeyId - 房源keyid (Guid)
 Status - 状态 (Int32)
 AdNo - 广告号 (String)
 PostId - (Guid)
 */
@property (nonatomic,copy)NSString *keyId;
@property (nonatomic,copy)NSString *propertyKeyId;
@property (nonatomic,strong)NSNumber *status;
@property (nonatomic,copy)NSString *adNo;
@property (nonatomic,copy)NSString *postId;

@end
