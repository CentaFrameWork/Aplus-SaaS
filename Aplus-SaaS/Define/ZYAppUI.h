//
//  ZYAppUI.h
//  A+
//
//  Created by 陈行 on 2018/8/20.
//  Copyright © 2018年 陈行. All rights reserved.
//

#ifndef ZYAppUI_h
#define ZYAppUI_h

#import "ZYInitialData.h"
/**
 *  屏幕宽
 */
#define APP_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
/**
 *  屏幕高
 */
#define APP_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/**
 *  状态栏高度
 */
#define HEIGHT_STATUSBAR [[UIApplication sharedApplication] statusBarFrame].size.height
/**
 *  导航栏高度
 */
#define HEIGHT_NAV self.navigationController.navigationBar.frame.size.height
/**
 *  底部tabbar高度
 */
#define HEIGHT_TABBAR self.tabBarController.tabBar.height
/**
 *  底部安全距离高度
 */
#define HEIGHT_SAFEAREA_BOTTOM [ZYInitialData safeareaBottomHeight]
/**
 *  安全frame
 */
#define FRAME_MAINVIEW_SAFEAREA CGRectMake(0, HEIGHT_NAV_AND_STATUSBAR, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - HEIGHT_NAV_AND_STATUSBAR - HEIGHT_SAFEAREA_BOTTOM)

/**
 *  顶部导航栏+状态栏高度
 */
#define HEIGHT_NAV_AND_STATUSBAR (HEIGHT_STATUSBAR + HEIGHT_NAV)









#endif /* ZYAppUI_h */
