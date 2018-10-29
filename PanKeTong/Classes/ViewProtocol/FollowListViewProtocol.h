//
//  FollowListViewProtocol.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/10.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AplusBaseViewProtocol.h"

@protocol FollowListViewProtocol <AplusBaseViewProtocol>

/// 进入房源详情页
- (void)enterPropDetailViewController:(NSInteger)indexRow;

@end
