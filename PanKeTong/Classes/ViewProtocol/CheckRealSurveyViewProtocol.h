//
//  CheckRealSurveyViewProtocol.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/10.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AplusBaseViewProtocol.h"
#import "PhotoEntity.h"

@protocol CheckRealSurveyViewProtocol <AplusBaseViewProtocol>

/// 控制装修情况显示情况
- (void)controlDecorationSituationDisplaySituation;

/// 弹出拒绝alert
- (void)refusedAlert;

/// 弹出通过alert
- (void)passAlert;

/// 控制全景图label状态
- (void)controlPanoramaLabelState:(PhotoEntity *)entity;
@end
