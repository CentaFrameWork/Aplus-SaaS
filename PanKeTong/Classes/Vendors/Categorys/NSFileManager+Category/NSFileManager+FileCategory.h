//
//  NSFileManager+FileCategory.h
//  biyanzhi
//
//  Created by 陈行 on 16-1-19.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileManager (FileCategory)
/**
 *  写入到沙盒
 *
 *  @param filePath 文件路径
 *  @param data     数据
 *
 *  @return 成功or失败
 */
+ (BOOL)writeToFile:(NSString *)filePath withData:(NSData *)data;

/**
 *  清除WKWebView产生的缓存
 *
 *  @return 成功or失败
 */
+ (BOOL)removeWKWebCache;

/**
 *  删除文件
 *
 *  @param filePath 文件路径
 *
 *  @return 成功or失败
 */
+ (BOOL)removeFilePath:(NSString *)filePath;

@end
