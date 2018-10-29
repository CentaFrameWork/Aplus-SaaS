//
//  WJAllDealScreenController.h
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/22.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

#import "ZYDealScreen.h"

@interface WJAllDealScreenController : BaseViewController
@property (nonatomic,assign) BOOL isMyDeal;
/**
 *  缓存展示筛选对象
 */
- (void)setDealScreen:(ZYDealScreen *)dealScreen;
/**
 *  确定筛选条件
 */
@property (nonatomic, copy) void (^ensureDealScreenBlock)(NSDictionary * dict, ZYDealScreen * dealScreen);

@end
