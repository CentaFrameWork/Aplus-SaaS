//
//  ShareInforEntity.h
//  PanKeTong
//
//  Created by 乔书超 on 2017/8/9.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface ShareInforEntity : AgencyBaseEntity

@property (nonatomic, copy) NSString *staffNo;
@property (nonatomic, copy) NSString *staffName;
@property (nonatomic, copy) NSString *departName;
@property (nonatomic, copy) NSString *bigCode;
@property (nonatomic, copy) NSString *extCode;
@property (nonatomic, copy) NSString *thumbImage;
@property (nonatomic, copy) NSString *platform;

@end
