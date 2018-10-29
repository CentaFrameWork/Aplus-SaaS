//
//  APFilterEntity.m
//  APlus
//
//  Created by 张旺 on 2017/10/30.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "APFilterEntity.h"

@implementation APFilterEntity

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        // 默认状态
        self.estateDealTypeStr = @"全部";
        self.priceType = @"价格";
        self.salePriceStr = @"";
        self.rentPriceStr = @"";
        self.tagStr = @"标签";
        self.transactType = @"交易类型";
        self.clientState = @"客户状态";
        self.clientDatum = @"资料完整度";
    }
    
    return self;
}

@end
