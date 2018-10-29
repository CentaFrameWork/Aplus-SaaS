//
//  SignedRecordEntity.h
//  PanKeTong
//
//  Created by zhwang on 16/4/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "SigendRecordListEntity.h"

@interface SignedRecordEntity : AgencyBaseEntity

@property (nonatomic ,strong) NSArray *checkIns;
@end
