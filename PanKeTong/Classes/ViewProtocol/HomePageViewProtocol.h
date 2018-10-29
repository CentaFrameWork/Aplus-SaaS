//
//  HomePageViewProtocol.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AplusBaseViewProtocol.h"

@protocol HomePageViewProtocol <AplusBaseViewProtocol>

@optional
/// 通知检查人员异动
- (void)noticeCheckPersonnelAbnormalMove;

@end
