//
//  CheckTrustEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/31.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "SubCheckTrustEntity.h"

///查看委托所有附件路径APi
@interface CheckTrustEntity : AgencyBaseEntity

@property (nonatomic,strong) NSArray *attachmentModels;


@end
