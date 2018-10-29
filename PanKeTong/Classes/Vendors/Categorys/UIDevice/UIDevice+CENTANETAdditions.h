//
//  UIDevice+CENTANETAdditions.h
//

#import <UIKit/UIKit.h>

@interface UIDevice (CENTANETAdditions)


+ (BOOL)isHighResolutionDevice;

/// 获取当前手机设备方向状态
+ (UIInterfaceOrientation)currentOrientation;

/// 获取当前手机的BundleId
+ (NSString *)getBundleIdentifier;

/// 获取当前手机的Mac地址
- (NSString *)getMacAddress;

@end
