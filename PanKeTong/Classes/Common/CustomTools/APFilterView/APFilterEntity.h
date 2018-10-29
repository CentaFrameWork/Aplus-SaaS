//
//  APFilterEntity.h
//  APlus
//
//  Created by 张旺 on 2017/10/30.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APFilterEntity : NSObject

@property (nonatomic, copy)NSString *estateDealTypeStr;          // 房源交易类型
@property (nonatomic, copy)NSString *priceType;                  // 价格类型
@property (nonatomic, copy)NSString *salePriceStr;               // 售价
@property (nonatomic, copy)NSString *rentPriceStr;               // 租价
@property (nonatomic, copy)NSString *tagStr;                     // 标签
@property (nonatomic, copy)NSString *transactType;               // 交易类型
@property (nonatomic, copy)NSString *clientState;                // 客户状态
@property (nonatomic, copy)NSString *clientDatum;                // 客户资料完整度

@end
