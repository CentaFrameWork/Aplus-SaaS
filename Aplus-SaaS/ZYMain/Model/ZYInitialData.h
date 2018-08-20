//
//  ZYInitialData.h
//  A+
//
//  Created by 陈行 on 2018/8/20.
//  Copyright © 2018年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

/**
 *  初始化的一些数据
 */
@interface ZYInitialData : NSObject

/**
 *  定位之后用户所在省
 */
@property (nonatomic, copy) NSString *userLocalProvince;
/**
 *  定位之后用户所在市
 */
@property (nonatomic, copy) NSString *userLocalCity;
/**
 *  定位之后用户所在区
 */
@property (nonatomic, copy) NSString *userLocalSubLocality;
/**
 *  定位之后用户高德经纬度
 */
@property (assign, nonatomic) CLLocationCoordinate2D userCoordinate;
/**
 *  app版本号
 */
@property (nonatomic, copy) NSString *appVersion;
/**
 *  app名称
 */
@property (nonatomic, copy) NSString *appName;

/**
 *  底部安全距离
 */
+ (CGFloat)safeareaBottomHeight;

@end
