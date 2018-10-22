//
//  HudViewUtil.h
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/13.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 加载进度框工具类
@interface HudViewUtil : NSObject

- (void)showLoadingView:(NSString *)message;

- (void)hiddenLoadingView;

@end
