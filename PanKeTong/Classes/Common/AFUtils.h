//
//  AFUtils.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/7.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+MD5Additions.h"
#import "CENTANETKeyChain.h"
#import "DascomDefine.h"
#import "NSDictionary+Json.h"
@class AFHTTPSessionManager;
@class BaseViewController;

@interface AFUtils : NSObject

// manager
+ (AFHTTPSessionManager *)Manager;
// parameters参数处理  path拼接处理
+ (id)Parameters:(NSDictionary *)parameters path:(NSString *)path controller:(BaseViewController *)controller manager:(AFHTTPSessionManager *)manager requestWay:(NSString *)requestway ;
// POST
+ (void)POST:(NSString *)path parameters:(NSDictionary *)parameters controller:(BaseViewController *)controller successfulDict:(void (^)(NSDictionary *successfuldict))successfulDict failureDict:(void (^)(NSDictionary *failuredict))failureDict failureError:(void (^)(NSError *failureerror))failureError;
// GET
+ (void)GET:(NSString *)path controller:(BaseViewController *)controller successfulDict:(void (^)(NSDictionary *successfuldict))successfulDict failureDict:(void (^)(NSDictionary *failuredict))failureDict failureError:(void (^)(NSError *failureerror))failureError;
// PUT
+ (void)PUT:(NSString *)path parameters:(NSDictionary *)parameters controller:(BaseViewController *)controller successfulDict:(void (^)(NSDictionary *successfuldict))successfulDict failureDict:(void (^)(NSDictionary *failuredict))failureDict failureError:(void (^)(NSError *failureerror))failureError;
// DELETE
+ (void)DELETE:(NSString *)path parameters:(NSDictionary *)parameters controller:(BaseViewController *)controller successfulDict:(void (^)(NSDictionary *successfuldict))successfulDict failureDict:(void (^)(NSDictionary *failuredict))failureDict failureError:(void (^)(NSError *failureerror))failureError;


+ (void)GET:(NSString *)path parameters:(NSDictionary *)parameters controller:(BaseViewController *)controller successfulDict:(void (^)(NSDictionary *successfuldict))successfulDict failureDict:(void (^)(NSDictionary *failuredict))failureDict failureError:(void (^)(NSError *failureerror))failureError;

// 设置请求头
+ (void)header:(AFHTTPSessionManager *)manager withDic:(NSDictionary *)header;
// 请求头内容0
+ (NSDictionary *)baseHeader;
// 请求头内容1
+ (NSDictionary *)baseHeader1;
// 请求头内容2
+ (NSMutableDictionary *)baseHeader2;
// 请求头内容3
+ (NSDictionary *)baseHeader3;
// 请求头内容4
+ (NSDictionary *)baseHeader4;
#warning 辅助
+ (NSDictionary *)headerParamWidthEmpNo:(NSString *)empNo;

@end
