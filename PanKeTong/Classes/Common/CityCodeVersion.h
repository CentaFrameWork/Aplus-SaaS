//
//  CityCodeVersion.h
//  PanKeTong
//
//  Created by 燕文强 on 16/4/12.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityCodeVersion : NSObject

+ (CityCodeVersion *)lazyLoad;

+ (BOOL)isTianJin;

+ (BOOL)isShenZhen;

+ (BOOL)isBeiJing;

+ (BOOL)isNanJing;

+ (BOOL)isAoMenHengQin;

+ (BOOL)isGuangZhou;

+ (BOOL)isChongQing;

+ (BOOL)isChangSha;

+ (BOOL)isHangZhou;

+ (BOOL)isDongGuan;

+ (BOOL)isHuiZhou;

+ (BOOL)isWuHan;

+ (NSString *)getCurrentCityCode;

/// 获取城市名
+ (NSString *)getCurrentCityName;
+ (NSString *)getCurrentCompanyName;
@end
