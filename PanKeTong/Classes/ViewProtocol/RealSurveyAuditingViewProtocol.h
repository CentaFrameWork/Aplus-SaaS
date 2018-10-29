//
//  RealSurveyAuditingViewProtocol.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/9.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AplusBaseViewProtocol.h"

@protocol RealSurveyAuditingViewProtocol <AplusBaseViewProtocol>

/// 通过审核
- (void)passAction;

/// 拒绝实勘
- (void)refusedAction;

@end
