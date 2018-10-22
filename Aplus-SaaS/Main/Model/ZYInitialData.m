//
//  ZYInitialData.m
//  A+
//
//  Created by 陈行 on 2018/8/20.
//  Copyright © 2018年 陈行. All rights reserved.
//

#import "ZYInitialData.h"

@interface ZYInitialData()<CLLocationManagerDelegate>
/**
 *  定位类
 */
@property (nonatomic, strong) CLLocationManager * locationManager;

@end

static ZYInitialData * sharedInitialData;

@implementation ZYInitialData

+ (instancetype)sharedInitialData{
    
    @synchronized (self) {
        
        if (sharedInitialData==nil) {
            
            sharedInitialData = [[ZYInitialData alloc] init];
            sharedInitialData.userLocalProvince = @"北京市";
            sharedInitialData.userLocalCity = @"北京市";
            sharedInitialData.userLocalSubLocality = @"东城区";
            sharedInitialData.userCoordinate = CLLocationCoordinate2DMake(39.9040300000, 116.4075260000);
            
            //获取version
//            [sharedInitialData loadVersion];
        }
    }
    return sharedInitialData;
}


#pragma mark - 定位相关


#pragma mark - version
- (void)loadVersion{
    //获取ipa中的版本信息，
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.appName = [infoDictionary objectForKey:@"CFBundleName"];
}


+ (CGFloat)safeareaBottomHeight{
    
    if(@available(iOS 11.0, *)){
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
        
    }else{
        return 0;
        
    }
    
}

@end
