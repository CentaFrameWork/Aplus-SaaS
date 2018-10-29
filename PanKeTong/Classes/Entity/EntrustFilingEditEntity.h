//
//  EntrustFilingEditEntity.h
//  PanKeTong
//
//  Created by 张旺 on 2017/7/28.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "EntrustFilingEditDetailEntity.h"

// 编辑备案实体

@interface EntrustFilingEditEntity : AgencyBaseEntity

@property (nonatomic,strong) EntrustFilingEditDetailEntity *value;

@end
