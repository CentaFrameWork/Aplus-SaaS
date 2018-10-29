//
//  NSFileManager+FileCategory.m
//  biyanzhi
//
//  Created by 陈行 on 16-1-19.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "NSFileManager+FileCategory.h"

#import <WebKit/WebKit.h>

@implementation NSFileManager (FileCategory)

+ (BOOL)writeToFile:(NSString *)filePath withData:(NSData *)data{
    NSFileManager * fm=[NSFileManager defaultManager];
    NSArray * array = [filePath componentsSeparatedByString:@"/"];
    NSString * directoryPath = [[filePath componentsSeparatedByString:[array lastObject]] firstObject];
    if(![fm fileExistsAtPath:filePath]){
        [fm createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL res =[data writeToFile:filePath atomically:YES];
    if (!res) {
        NSLog(@"---->写入失败");
    }
    return res;
}

+ (BOOL)removeWKWebCache{
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
        
        // 清除所有
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            NSLog(@"清楚缓存完毕");
            
        }];
        
    }
    
    return YES;
}

+ (BOOL)removeFilePath:(NSString *)filePath{
    NSFileManager * fm = [NSFileManager defaultManager];
    return [fm removeItemAtPath:filePath error:nil];
}

@end
