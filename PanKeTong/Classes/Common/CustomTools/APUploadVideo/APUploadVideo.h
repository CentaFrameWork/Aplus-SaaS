//
//  APUploadVideo.h
//  PanKeTong
//
//  Created by 张旺 on 2017/11/24.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"
#import "APUploadFile.h"
#import "NetSpeedUtility.h"

@protocol APUploadVideoDelegate <NSObject>

@optional

- (void)uploadWithQNResponseInfo:(QNResponseInfo*)info fileUrl:(NSURL *)url resp:(NSDictionary *)resp;

- (void)uploadingProgress:(float)percent fileIndex:(NSInteger)index;

- (void)uploadSpeedfileIndex:(NSInteger)index;  // 每两秒计算下速度回调

- (void)uploadFinish;

@end

@interface APUploadVideo : NSObject

@property (nonatomic, assign) id<APUploadVideoDelegate> delegate;

/// 单例
+ (instancetype)sharedUploadVideo;

/// 上传token
@property (nonatomic, copy) NSString *token;

/// 当前是否有上传任务
@property (nonatomic, assign) BOOL isHaveUploadTask;

/// 上传任务数组
@property (nonatomic, strong) NSMutableArray *uploadTaskArr;

/// 当前下载的下标
@property (nonatomic, assign) NSInteger currentUploadIndex;

/// 开始上传某个文件
- (void)uploadWithUploadFile:(APUploadFile *)uploadFile;

/// 暂停上传某个文件
- (void)pauseUploadWithUploadFile:(APUploadFile *)uploadFile;

/// 让其它正在等待中的任务接着上传
- (void)otherTaskContinueUploadFile;

/// 继续上传某个文件
- (void)continueUploadWithUploadFile:(APUploadFile *)uploadFile;

/// 某个任务上传进度
- (float)uploadPersentOfUploadFile:(APUploadFile *)uploadFile;

/// 获取上传列表
- (NSMutableArray *)getUploadTaskArr;

/// 每两秒计算下速度
@property (nonatomic, strong) NSTimer *timer;

@end
