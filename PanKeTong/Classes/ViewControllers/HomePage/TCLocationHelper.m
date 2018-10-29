//
//  TCLocationHelper.m
//  TCLocationHelper
//
//  Created by TailC on 16/3/24.
//  Copyright © 2016年 TailC. All rights reserved.
//

#import "TCLocationHelper.h"
#import <UIKit/UIKit.h>
#import "CLLocation+YCLocation.h"

@interface TCLocationHelper ()<CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager *manager;
@property (strong,nonatomic) CLGeocoder  *geocoder;

@property (copy ,nonatomic) getTCLocationSuccessBlock successBlock;
@property (copy ,nonatomic) getTCLocationFailBlock   failBlock;

@property (copy,nonatomic) getAddressDictBlock block;


@end

@implementation TCLocationHelper

#pragma mark init
-(instancetype)init{
	self = [super init];
	if (self) {
		//打开定位服务
		self.manager = [[CLLocationManager alloc] init];
		self.manager.delegate = self;
        [self.manager setDesiredAccuracy:kCLLocationAccuracyBest];
		
		self.geocoder = [[CLGeocoder alloc] init];
		
		/**    
		 iOS8兼容
		 Info.plist里面加上2项
		 NSLocationAlwaysUsageDescription      Boolean YES
		 NSLocationWhenInUseUsageDescription   Boolean YES
		 */
		//请求授权(ios8+)
		if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
			[self.manager requestWhenInUseAuthorization];
			[self.manager requestAlwaysAuthorization];
		}
		
		
	}
	return self;
}


#pragma mark Public Method
+(instancetype)shareInstance{
	static dispatch_once_t pred = 0;
	static TCLocationHelper *sharedObject = nil;
	dispatch_once(&pred, ^{
		sharedObject = [[self alloc] init];
	});
	return sharedObject;
}


+(void)getAddressDict:(getAddressDictBlock)block{
	
	if ([CLLocationManager locationServicesEnabled] == NO) {
		return;
	}
	[[TCLocationHelper shareInstance].manager startUpdatingLocation];
	
	[[TCLocationHelper shareInstance] getAddressDictWithBlock:block];
}


#pragma mark Private Method

-(void)getAddressDictWithBlock:(getAddressDictBlock)block{
	self.block = block;
}


- (void)getLocationSuccess:(getTCLocationSuccessBlock)locationSuccessBlock
           locationFailBlock:(getTCLocationFailBlock)locationFailBlock{
    
    self.successBlock = nil;
    self.failBlock = nil;
    self.successBlock = locationSuccessBlock;
    self.failBlock = locationFailBlock;
    
    [[TCLocationHelper shareInstance].manager startUpdatingLocation];
    
}

#pragma mark	<CLLocationManagerDelegate>
/**
 *  获取坐标
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
	
	CLLocation *location = [locations firstObject];
    
	__block NSDictionary *addressDict ;
	__weak typeof(self) weakSelf = self;
	//根据坐标获取反编译地理信息
	[self.geocoder reverseGeocodeLocation:location
						completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
										CLPlacemark *placeMark = [placemarks firstObject];
							
							addressDict = placeMark.addressDictionary;
							//判断是否获取到坐标，若获取到，则取消定位
							if (addressDict) {
								[weakSelf.manager stopUpdatingLocation];
								
							}
							
							if (weakSelf.block) {
                                weakSelf.block(placeMark.addressDictionary);
							}
                            
                            /*
                             *   CLLocationManager 定位得到的经纬度是“地球坐标系统”，需要先转换成“火星坐标系统”
                             *   再转换为“百度坐标系统”
                             *
                             */
                            weakSelf.location = [[[locations lastObject]locationMarsFromEarth]locationBaiduFromMars];
                            
                            /*
                             *itouch中的“addressDictionary”字典中没有“City”属性，要使用State
                             *
                             */
                            if (!placeMark.addressDictionary[@"City"] ||
                                [placeMark.addressDictionary[@"City"] isEqualToString:@""]) {
                                
                                weakSelf.cityName = placeMark.addressDictionary[@"State"];
                            }else{
                                
                                weakSelf.cityName = placeMark.addressDictionary[@"City"];
                            }
                            weakSelf.addressDetail = placeMark.addressDictionary[@"Street"];
                            weakSelf.subLocality = placeMark.subLocality;
                            if (_successBlock) {
                                _successBlock(weakSelf);
                                _successBlock = nil;
                            }
                            
						}];
	
	
}

@end
