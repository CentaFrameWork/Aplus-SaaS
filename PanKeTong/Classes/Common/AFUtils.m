//
//  AFUtils.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/7.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "AFUtils.h"
#import "AFNetworking.h"
#import "BaseViewController.h"

#import "JDStatusBarNotification.h"

#define Apikey @"d053e2ab47b3345269a1c4c5147f0e27"     //手机号码归属地查询key

@implementation AFUtils

// manager设置
+ (AFHTTPSessionManager *)Manager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript",@"text/plain",@"text/json",@"application/json", nil];
    });
    return manager;
}

// parameters参数处理 请求头处理 path拼接处理
+ (id)Parameters:(NSDictionary *)parameters path:(NSString *)path controller:(BaseViewController *)controller manager:(AFHTTPSessionManager *)manager requestWay:(NSString *)requestway {
    [controller showLoadingView:nil];
    NSMutableDictionary *parametersDict = [[NSMutableDictionary alloc] init];   //
    NSString *parametersStr = nil;                                              //
    if ([path rangeOfString:NewHousekeeperUrl].location != NSNotFound) {
        
        [AFUtils header:manager withDic:[AFUtils baseHeader1]];
        [parametersDict addEntriesFromDictionary:parameters];
        
    }else if ([path rangeOfString:NewBaseUrl].location != NSNotFound) {
        [AFUtils header:manager withDic:[AFUtils baseHeader]];
        
        [parametersDict addEntriesFromDictionary:parameters];
        [parametersDict setObject:@"true" forKey:@"IsMobileRequest"];
        parametersStr = [NSString stringWithFormat:@"true=IsMobileRequest"];
    
    }else if (!([path rangeOfString:@"设置请求头：再次封装请求方式时，所调用的接口还没有用到这个服务器"].location == NSNotFound)) {
        
        [AFUtils header:manager withDic:[AFUtils baseHeader2]];
        [parametersDict setObject:[AFUtils headerParamWidthEmpNo:parameters[@"empNo"]] forKey:@"header"];
   
    }else if (!([path rangeOfString:@"设置请求头：再次封装请求方式时，所调用的接口还没有用到这个服务器"].location == NSNotFound)) {
        
        [AFUtils header:manager withDic:[AFUtils baseHeader3]];
    
    }else if (!([path rangeOfString:@"设置请求头：再次封装请求方式时，所调用的接口还没有用到这个服务器"].location == NSNotFound)) {
        
        [AFUtils header:manager withDic:[AFUtils baseHeader4]];
    }
    
    if ([requestway isEqualToString:@"GET0"]) {
        if (parametersStr != nil) {
            if ([path rangeOfString:@"?"].location != NSNotFound) {
                if ([path componentsSeparatedByString:@"?"].count >= 2) {
                    NSString *strUrl = [path stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSArray *array = [[parametersStr stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@"&"];
                    for (int i=0; i<array.count; i++) {
                        path = (([strUrl rangeOfString:array[0]].location != NSNotFound) ? path : [NSString stringWithFormat:@"%@&%@",path,parametersStr]);
                    }
                }else {
                    path = [NSString stringWithFormat:@"%@%@",path,parametersStr];
                }
            }else {
                path = [NSString stringWithFormat:@"%@?%@",path,parametersStr];
            }
        }
        return path;
    }else {
        return parametersDict;
    }
    
}

// POST请求
+ (void)POST:(NSString *)path parameters:(NSDictionary *)parameters controller:(BaseViewController *)controller successfulDict:(void (^)(NSDictionary *))successfulDict failureDict:(void (^)(NSDictionary *))failureDict failureError:(void (^)(NSError *))failureError {
    
    AFHTTPSessionManager *manager = [AFUtils Manager];
    parameters = [AFUtils Parameters:parameters path:path controller:controller manager:manager requestWay:@"POST"];
    
    NSLog(@"+++++++++++POST请求接口:%@",path);
    NSLog(@"+++++++++++POST请求参数:%@",parameters);
    [manager POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        [controller hiddenLoadingView];
       
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        //处理账号异常问题
        BOOL res = [self isCanUseAccountWithData:dictionary];
        
        if (res == false) {
            
            return;
            
        }
        
        if ([[NSString stringWithFormat:@"%@",dictionary[@"Flag"]] isEqualToString:@"1"]) {
            NSLog(@"+++++++++++POST返回成功数据:%@",dictionary);
            successfulDict(dictionary);
        }else if ([dictionary[@"RCode"] isEqualToNumber:@(200)]) {
            NSLog(@"+++++++++++POST返回成功数据:%@",dictionary);
            successfulDict(dictionary);
        } else {
            NSLog(@"+++++++++++POST返回错误数据:%@",dictionary);
            failureDict(dictionary);
            NSString *errorMsg;
            
            if (dictionary[@"ErrorMsg"]) {
                errorMsg = dictionary[@"ErrorMsg"];
                
            }else if ([dictionary[@"RMessage"] isKindOfClass: [NSString class]]) {
                
                errorMsg = dictionary[@"RMessage"];
           
            }else {
                
                errorMsg = @"未知错误";
            }
            
            if ([path contains:@"confirm-login"]  || [path contains:@"qrcode"])return;
            
            showMsg(errorMsg);
                
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"+++++++++++POST请求失败:%@",error);
        [controller hiddenLoadingView];
        showJDStatusStyleErrorMsg(error.localizedDescription);
        failureError(error);
    }];
}




// GET
+ (void)GET:(NSString *)path controller:(BaseViewController *)controller successfulDict:(void (^)(NSDictionary *successfuldict))successfulDict failureDict:(void (^)(NSDictionary *failuredict))failureDict failureError:(void (^)(NSError *failureerror))failureError {
    
    
    AFHTTPSessionManager *manager = [AFUtils Manager];
    path = [AFUtils Parameters:nil path:path controller:controller manager:manager requestWay:@"GET0"];
    
    NSLog(@"+++++++++++GET请求接口:%@",path);
    [manager GET:path parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [controller hiddenLoadingView];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        //处理账号异常问题
        BOOL res = [self isCanUseAccountWithData:dictionary];
        
        if (res == false) {
            
            return;
            
        }
        
        if ([[NSString stringWithFormat:@"%@",dictionary[@"Flag"]] isEqualToString:@"1"]) {
            NSLog(@"+++++++++++GET返回成功数据:%@",dictionary);
            successfulDict(dictionary);
        }else {
            NSLog(@"+++++++++++GET返回错误数据:%@",dictionary);
            failureDict(dictionary);
            NSString *errorMsg = [NSString stringWithFormat:@"%@",dictionary[@"ErrorMsg"]];
            showMsg(errorMsg)
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"+++++++++++GET请求失败:%@",error);
        [controller hiddenLoadingView];
        showJDStatusStyleErrorMsg(error.localizedDescription);
        failureError(error);
    }];
    
}

+ (void)GET:(NSString *)path parameters:(NSDictionary *)parameters controller:(BaseViewController *)controller successfulDict:(void (^)(NSDictionary *successfuldict))successfulDict failureDict:(void (^)(NSDictionary *failuredict))failureDict failureError:(void (^)(NSError *failureerror))failureError {
    
    
    AFHTTPSessionManager *manager = [AFUtils Manager];
    parameters = [AFUtils Parameters:parameters path:path controller:controller manager:manager requestWay:@"GET"];
    
    NSLog(@"+++++++++++GET请求接口:%@",path);
    [manager GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [controller hiddenLoadingView];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        //处理账号异常问题
        BOOL res = [self isCanUseAccountWithData:dictionary];
        
        if (res == false) {
            
            return;
            
        }
        
        if ([[NSString stringWithFormat:@"%@",dictionary[@"Flag"]] isEqualToString:@"1"]) {
            NSLog(@"+++++++++++GET返回成功数据:%@",dictionary);
            successfulDict(dictionary);
        }else {
            NSLog(@"+++++++++++GET返回错误数据:%@",dictionary);
            failureDict(dictionary);
            NSString *errorMsg = [NSString stringWithFormat:@"%@",dictionary[@"ErrorMsg"]];
            showMsg(errorMsg)
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"+++++++++++GET请求失败:%@",error);
        [controller hiddenLoadingView];
        showJDStatusStyleErrorMsg(error.localizedDescription);
        failureError(error);
    }];
    
    
    
    
}
// PUT
+ (void)PUT:(NSString *)path parameters:(NSDictionary *)parameters controller:(BaseViewController *)controller successfulDict:(void (^)(NSDictionary *successfuldict))successfulDict failureDict:(void (^)(NSDictionary *failuredict))failureDict failureError:(void (^)(NSError *failureerror))failureError{
    AFHTTPSessionManager *manager = [AFUtils Manager];
    parameters = [AFUtils Parameters:parameters path:path controller:controller manager:manager requestWay:@"PUT"];
    
    NSLog(@"+++++++++++PUT请求接口:%@",path);
    [manager PUT:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [controller hiddenLoadingView];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        //处理账号异常问题
        BOOL res = [self isCanUseAccountWithData:dictionary];
        
        if (res == false) {
            
            return;
            
        }
        
        if ([[NSString stringWithFormat:@"%@",dictionary[@"Flag"]] isEqualToString:@"1"]) {
            NSLog(@"+++++++++++PUT返回成功数据:%@",dictionary);
            successfulDict(dictionary);
        }else {
            NSLog(@"+++++++++++PUT返回错误数据:%@",dictionary);
            failureDict(dictionary);
            NSString *errorMsg = [NSString stringWithFormat:@"%@",dictionary[@"ErrorMsg"]];
            showMsg(errorMsg)
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"+++++++++++PUT请求失败:%@",error);
        [controller hiddenLoadingView];
        showJDStatusStyleErrorMsg(error.localizedDescription);
        failureError(error);
    }];
}
// DELETE
+ (void)DELETE:(NSString *)path parameters:(NSDictionary *)parameters controller:(BaseViewController *)controller successfulDict:(void (^)(NSDictionary *successfuldict))successfulDict failureDict:(void (^)(NSDictionary *failuredict))failureDict failureError:(void (^)(NSError *failureerror))failureError {
    AFHTTPSessionManager *manager = [AFUtils Manager];
    parameters = [AFUtils Parameters:parameters path:path controller:controller manager:manager requestWay:@"DELETE"];
    
    NSLog(@"+++++++++++DELETE请求接口:%@",path);
    [manager DELETE:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [controller hiddenLoadingView];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        //处理账号异常问题
        BOOL res = [self isCanUseAccountWithData:dictionary];
        
        if (res == false) {
            
            return;
            
        }
        
        if ([[NSString stringWithFormat:@"%@",dictionary[@"Flag"]] isEqualToString:@"1"]) {
            NSLog(@"+++++++++++DELETE返回成功数据:%@",dictionary);
            successfulDict(dictionary);
        }else {
            NSLog(@"+++++++++++DELETE返回错误数据:%@",dictionary);
            failureDict(dictionary);
            NSString *errorMsg = [NSString stringWithFormat:@"%@",dictionary[@"ErrorMsg"]];
            showMsg(errorMsg)
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"+++++++++++DELETE请求失败:%@",error);
        [controller hiddenLoadingView];
        showJDStatusStyleErrorMsg(error.localizedDescription);
        failureError(error);
    }];
}


// 设置请求头
+ (void)header:(AFHTTPSessionManager *)manager withDic:(NSDictionary *)header {
    if(!header) {
        return;
    }
    NSArray *keys = [header allKeys];
    NSInteger count = [keys count];
    for (int i = 0; i < count; i++) {
        NSString *key = keys[i];
        NSString *value = [header objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
}

// 请求头内容0
+ (NSDictionary *)baseHeader {
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *agencyToken = [AgencyUserPermisstionUtil getToken];
    
    if (agencyToken &&
        ![agencyToken isEqualToString:@""])
    {
        [headerDic setValue:agencyToken forKey:@"token"];
//        NSLog(@"+++++++++++token:%@",headerDic);
    }
    
    NSString *staffNo = [CommonMethod getUserdefaultWithKey:UserStaffNumber];
    NSString *key = @"CYDAP_com-group";
    NSString *company = @"~Centa@";
    
    //时间戳
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timestamp = [nowDate timeIntervalSince1970];
    long unixTimeLong = (long)timestamp;
    NSString *unixTimeStr = [NSString stringWithFormat:@"%@",@(unixTimeLong)];
    
//    NSLog(@"unixTimeStr:%@",unixTimeStr);
    
    NSString *osign = [NSString stringWithFormat:@"%@%@%@%@",key,company,unixTimeStr,staffNo];
    NSString *sign = [osign md5];
    
    NSString *companyCode = [[NSUserDefaults standardUserDefaults]stringForKey:CityCode];
    
    [headerDic setValue:@"application/json" forKey:@"content-type"];
    [headerDic setValue:@"application/json" forKey:@"Accept"];
    
    [headerDic setValue:app_Version forKey:@"ClientVer"];
    [headerDic setValue:@"iOS" forKey:@"platform"];
    [headerDic setValue:@"iPhone" forKey:@"User-Agent"];
    [headerDic setValue:FINAL_CORPORATION_KEY_ID forKey:@"corporationKeyId"];
    [headerDic setValue:staffNo forKey:@"staffno"];
    [headerDic setValue:unixTimeStr forKey:@"number"];
    [headerDic setValue:sign forKey:@"sign"];
    [headerDic setValue:companyCode forKey:@"code"];
    [headerDic setValue:@"原萃" forKey:@"appName"];
//    NSLog(@"headerDicheaderDicheaderDic:%@",headerDic);
    
    return headerDic;
}

// 请求头内容1
+ (NSDictionary *)baseHeader1 {
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *deviceUDID = [CENTANETKeyChain getAppOnlyIdentifierOnDevice];
    NSString * session=[[NSUserDefaults standardUserDefaults]stringForKey:HouseKeeperSession];
    NSString *companyCode = [[NSUserDefaults standardUserDefaults]stringForKey:CityCode];
    
    [headerDic setValue:deviceUDID forKey:@"Udid"];
    [headerDic setValue:app_Version forKey:@"ClientVer"];
    
    if (session.length) [headerDic setValue:session forKey:@"HKSession"];
    
    if (companyCode.length) [headerDic setValue:companyCode forKey:@"CompanyCode"];
      
    
    [headerDic setValue:@"none" forKey:@"Channel"];
    [headerDic setValue:@"iOS" forKey:@"platform"];
    [headerDic setValue:@"application/json" forKey:@"Accept"];
    [headerDic setValue:@"application/json" forKey:@"content-type"];
    [headerDic setValue:@"iPhone" forKey:@"User-Agent"];
    
    return headerDic.copy;
}

// 请求头内容2
+ (NSMutableDictionary *)baseHeader2 {
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    
    NSString *staffNo = [CommonMethod getUserdefaultWithKey:UserStaffNumber];
    NSString *key = @"CYDAP_com-group";
    NSString *company = @"~Centa@";
    
    //时间戳
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timestamp = [nowDate timeIntervalSince1970];
    long unixTimeLong = (long)timestamp;
    NSString *unixTimeStr = [NSString stringWithFormat:@"%@",@(unixTimeLong)];
    
    NSLog(@"unixTimeStr:%@",unixTimeStr);
    
    NSString *osign = [NSString stringWithFormat:@"%@%@%@%@",key,company,unixTimeStr,staffNo];
    NSString *sign = [osign md5];
    
    [headerDic setValue:staffNo forKey:@"staffno"];
    [headerDic setValue:unixTimeStr forKey:@"number"];
    [headerDic setValue:sign forKey:@"sign"];
    
    return headerDic;
}

// 请求头内容3
+ (NSDictionary *)baseHeader3 {
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    
    //随机数
    int nonceNum = arc4random() % 100;
    NSString *nonceStr = [NSString stringWithFormat:@"%@",@(nonceNum)];
    
    //时间戳
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timestamp = [nowDate timeIntervalSince1970];
    long timesTampLong = (long)timestamp;
    NSString *timestampStr = [NSString stringWithFormat:@"%@",@(timesTampLong)];
    
    //数据签名 MD5/SHA1
    NSString *signatureStr = [CommonMethod getSHA1WithStringWithSecret:RongCloudAppSecret
                                                              andNonce:nonceStr
                                                          andTimestamp:timestampStr];
    
    //添加App Key、随机数、时间戳、数据签名 到requestHeader
    
    [headerDic setValue:RongCloudAppKey forKey:@"App-Key"];
    [headerDic setValue:nonceStr forKey:@"Nonce"];
    [headerDic setValue:timestampStr forKey:@"Timestamp"];
    [headerDic setValue:signatureStr forKey:@"Signature"];
    [headerDic setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    [headerDic setValue:@"application/json" forKey:@"Accept"];
    [headerDic setValue:@"application/json" forKey:@"content-type"];
    [headerDic setValue:@"iPhone" forKey:@"User-Agent"];
    
    return (NSDictionary *)headerDic;
}

// 请求头内容4
+ (NSDictionary *)baseHeader4 {
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    [headerDic setValue:Apikey forKey:@"apikey"];
    return (NSDictionary *)headerDic;
}


+ (NSDictionary *)headerParamWidthEmpNo:(NSString *)empNo {
    NSString *strTemp = [NSString stringWithFormat:@"%@%@", empNo,DAS_CALL_KEY];
    NSString *md5Str = [strTemp md5];
    NSDictionary *headerParam = [[NSDictionary alloc]initWithObjectsAndKeys:md5Str,@"token", nil];
    return headerParam;
}

/**
 *  判定如果ErrorMsg是410，提示用户
 */
+ (BOOL)isCanUseAccountWithData:(id)data{
    
    if ([data isKindOfClass:[NSDictionary class]]) {//其他类型数据暂不处理
        
        NSDictionary * tmpDict = data;
        
        NSString * errorCode = [NSString stringWithFormat:@"%@", tmpDict[@"ErrorMsg"]];
        
        if ([errorCode isEqualToString:@"410"]) {
            
            [[[UIAlertView alloc] initWithTitle:@"信息提示" message:@"您的账号出现异常，请联系公司管理员处理" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
            // 用户退出登录后清除用户信息
            [LogOffUtil clearUserInfoFromLocal];
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeDiscoverRootVCIsLogin:YES];
            
            return false;
        }
        
    }
    
    return true;
    
}

@end
