//
//  TCLocationHelper.h
//  TCLocationHelper
//
//  Created by TailC on 16/3/24.
//  Copyright © 2016年 TailC. All rights reserved.
//	========================
//	iOS7 需在info.plist中配置(Privacy - Location Usage Description)(可选)
//	iOS8以上 需配置 NSLocationWhenInUseUsageDescription（NSLocationAlwaysUsageDescription）（必须）
//	========================

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class TCLocationHelper;


typedef void(^getTCLocationSuccessBlock)(TCLocationHelper *mananger);
typedef void(^getTCLocationFailBlock)(NSError *error);

typedef void(^getAddressDictBlock)(NSDictionary *addressDict);


@interface TCLocationHelper : NSObject

@property (nonatomic, strong) NSString *cityName; //城市
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *subLocality;//区域
@property (nonatomic, strong) NSString *addressDetail;//详细地址

+(instancetype)shareInstance;
/**
 *  获取地理位置信息
 *
 *  @param block block
 */
+(void)getAddressDict:(getAddressDictBlock)block;

/**
 *  Description
 *
 *  @param locationSuccessBlock 定位成功 回调该方法
 *  @param locationFailBlock    定位失败 回调该方法
 */
- (void)getLocationSuccess:(getTCLocationSuccessBlock)locationSuccessBlock
           locationFailBlock:(getTCLocationFailBlock)locationFailBlock;

@end
