//
//  APUploadVideo.m
//  PanKeTong
//
//  Created by 张旺 on 2017/11/24.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APUploadVideo.h"
#import "AgencySysParamUtil.h"
#import "RequestManager.h"
#import "UploadRealPhotoApi.h"

//#define Token @"N3p4z_1FaNt-4Q5sdvuJbEvtYQj5eTI9S2LftWkA:SiWnVK9tMvfJ5eSVbH9JzPnKG-4=:eyJzY29wZSI6InpoYW5nd2FuZ2RhdGEiLCJkZWFkbGluZSI6MTUxMjEzODAxNn0="

@interface APUploadVideo ()

@property (nonatomic, strong) RequestManager *manager;
@property (nonatomic, strong) QNUploadManager *upmanager;
@property (nonatomic, strong) QNUploadOption *opt;
@property (nonatomic, strong) NSMutableDictionary *flagDic;             // 标记暂停或继续上次
@property (nonatomic, strong) NSMutableDictionary *uploadingTaskDic;    // 某个任务的上次进度
@property (nonatomic, assign) float lastProgress;
@property (nonatomic, strong) APUploadFile * currentFile;               // 当前上传的file

@end

@implementation APUploadVideo

+ (instancetype)sharedUploadVideo
{
    static APUploadVideo *uploadVideo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uploadVideo = [[self alloc]init];
    });
    return uploadVideo;
}

- (void)uploadWithUploadFile:(APUploadFile *)uploadFile
{
    // 加入到任务数组中
    [self.uploadTaskArr addObject:uploadFile];
    
    for (APUploadFile *file in self.uploadTaskArr)
    {
        if (file.uploadState == UploadStatusUploading)
        {
            _isHaveUploadTask = YES;
            break;
        }
    }
    
    if (!_isHaveUploadTask)
    {
        uploadFile.uploadState = UploadStatusUploading;
        
        [self uploadObject:uploadFile];
    }
    else
    {
        uploadFile.uploadState = UploadStatusWaiting;
    }
}

- (void)uploadObject:(APUploadFile*)file
{
    self.currentUploadIndex = [self.uploadTaskArr indexOfObject:file];
    
    // 计算已经上传的进度
    float uploadedSize = [[[file.uploadedSize componentsSeparatedByString:@"M"] firstObject] floatValue] * 1024 * 1024;
    _lastProgress = uploadedSize/file.videoTotalSize;
    
    _isHaveUploadTask = YES;
    
    _currentFile = file;
    
    // 每两秒更新上传速度
    if (_timer)
    {
        [_timer setFireDate:[NSDate date]];
    }
    else
    {
        _timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
        NSRunLoop*runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:_timer forMode:NSDefaultRunLoopMode];
    }

    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self.flagDic setValue:@(0) forKey:file.fileUrl.path];
    
    WS(weakSelf);
    // QNFileRecorde
    _opt = [[QNUploadOption alloc] initWithMime:nil progressHandler: ^(NSString *key, float percent) {
        
        [self.uploadingTaskDic setObject:@(percent) forKey:file.fileUrl.path];

        file.progress = percent;
        file.uploadedSize = [NSString stringWithFormat:@"%.1lfM",percent * file.videoTotalSize/1024.0/1024.0];
        NSLog(@"---***---上传进度：%f-----*",percent);
        NSLog(@"---***---上次上传进度：%f-----*",_lastProgress);
        
        if ([self.delegate respondsToSelector:@selector(uploadingProgress:fileIndex:)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate uploadingProgress:percent fileIndex:self.currentUploadIndex];
            });
        }
        
        if (percent >= 1)
        {
            
        }
    } params:nil checkCrc:NO cancellationSignal: ^BOOL () {
        return [[self.flagDic objectForKey:file.fileUrl.path]boolValue];
    }];
    
    if ([file.fileUrl isKindOfClass:[NSURL class]])
    {
        [self.upmanager putFile:[(NSURL*)file.fileUrl path]
                            key:file.uploadFileKey
                          token:_token
                       complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                           
                           if (resp)
                           {
                               file.isTranscoding = YES;
                               
                               // 上传实勘到A+
                               SysParamItemEntity *sysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_PHOTOTYPE_KEYID];
                               NSArray *itemList = sysParamItemEntity.itemList;
                               SelectItemDtoEntity *itemDtoEntity = itemList[0];
                               
                               UploadRealPhotoApi * api = [UploadRealPhotoApi new];
                               
                               api.photo = @[@{
                                                 @"PhotoTypeKeyId":itemDtoEntity.itemValue,
                                                 @"PhotoPath":file.uploadFileKey
                                                 }];
                               api.realKeyId = file.realKeyId;
                               api.keyId = file.estateId;
                               
                               [weakSelf.manager sendRequest:api sucBlock:^(id result) {
                                   
                                   AgencyBaseEntity *agencyEntity = [DataConvert convertDic:result toEntity:[AgencyBaseEntity class]];
                                   file.isTranscoding = NO;
                                   if (agencyEntity.flag)
                                   {
                                       [self.flagDic setValue:@(1) forKey:file.fileUrl.path];
                                       [self.flagDic removeObjectForKey:file.fileUrl.path];
                                       [self removeTaskWithFile:file];
                                       [self.uploadingTaskDic removeObjectForKey:file.fileUrl.path];
                                       
                                       if ([self.delegate respondsToSelector:@selector(uploadFinish)])
                                       {
                                           _isHaveUploadTask = NO;
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [self.delegate uploadFinish];
                                           });
                                       }
                                       
                                       // 上传完后接着下一个正在等待中的文件上传，改变状态为正在上传中
                                       [self otherTaskContinueUploadFile];
                                   }
                                   else
                                   {
                                       showMsg(@"上传出错,请重试");
                                   }
                                   
                               } failBlock:^(NSError *error) {
                                   
                                   showMsg(@"上传出错,请重试");
                                   
                               }];
                           }
                           
                           [self uploadWithQNResponseInfo:info key:key resp:resp fileUrl:file.fileUrl];
                       } option:_opt];
    }
}

/// 每两秒计算一次上传速度
- (void)timerAction
{
    _currentFile.uploadSpeed = [NetSpeedUtility getNetSpeedWithTotalSize:_currentFile.videoTotalSize progress:_currentFile.progress lastProgress:_lastProgress time:2];
    if ([self.delegate respondsToSelector:@selector(uploadSpeedfileIndex:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate uploadSpeedfileIndex:self.currentUploadIndex];
        });
    }
    
    _lastProgress = _currentFile.progress;
}

- (void)uploadWithQNResponseInfo:(QNResponseInfo*)info key:(NSString *)key resp:(NSDictionary *)resp fileUrl:url
{
    if ([self.delegate respondsToSelector:@selector(uploadWithQNResponseInfo:fileUrl:resp:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate uploadWithQNResponseInfo:info
                                            fileUrl:url
                                               resp:resp];
        });
    }
}

// lazy upmanager
- (QNUploadManager *)upmanager
{
    if (_upmanager == nil)
    {
        NSError *error = nil;
        
        QNFileRecorder *recorder = [QNFileRecorder fileRecorderWithFolder:[NSTemporaryDirectory() stringByAppendingString:@"UploadFileRecord"]
                                                                    error:&error];
        _upmanager = [[QNUploadManager alloc]initWithRecorder:recorder];
    }
    
    return _upmanager;
}

- (RequestManager *)manager
{
    if (_manager == nil)
    {
        _manager = [RequestManager initManager];
    }
    
    return _manager;
}

- (NSMutableDictionary *)flagDic
{
    if (_flagDic == nil)
    {
        _flagDic = [[NSMutableDictionary alloc]init];
    }
    
    return _flagDic;
}

- (NSMutableArray *)uploadTaskArr
{
    if (_uploadTaskArr == nil)
    {
        _uploadTaskArr = [[NSMutableArray alloc]init];
    }
    
    return _uploadTaskArr;
}

- (NSMutableDictionary *)uploadingTaskDic
{
    if (_uploadingTaskDic == nil)
    {
        _uploadingTaskDic = [[NSMutableDictionary alloc]init];
    }
    
    return _uploadingTaskDic;
}

/// 获取下载任务
- (NSMutableArray *)getUploadTaskArr
{
    return self.uploadTaskArr;
}

/// 暂停上传
- (void)pauseUploadWithUploadFile:(APUploadFile *)uploadFile;
{
    //设置屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    _isHaveUploadTask = NO;
    [_timer setFireDate:[NSDate distantFuture]];
    [self.flagDic setObject:@1 forKey:uploadFile.fileUrl.path];
}

/// 继续上传
- (void)continueUploadWithUploadFile:(APUploadFile *)uploadFile;
{
    //设置屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self.flagDic setObject:@0 forKey:uploadFile.fileUrl.path];
    APUploadFile *file = [self fileWithUploadFile:uploadFile];
    
    if (file == nil)
    {
        return;
    }
    
    NSLog(@"继续上传%@,%@",file.uploadFileKey,file.token);
    [self uploadObject:file];
}

/// 让其它正在等待中的任务接着上传
- (void)otherTaskContinueUploadFile
{
    BOOL isHaveUploadFile = NO;
    NSInteger arrCount = self.uploadTaskArr.count;
    for (int i = 0; i < arrCount; i++)
    {
        APUploadFile * file = self.uploadTaskArr[i];
        if (file.uploadState == UploadStatusWaiting)
        {
            file.uploadState = UploadStatusUploading;
            [self uploadObject:file];
            isHaveUploadFile = YES;
            //self.currentUploadIndex = i;
            break;
        }
    }
    
    if (isHaveUploadFile == NO)
    {
        [_timer invalidate];
        _timer = nil;
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}

- (APUploadFile *)fileWithUploadFile:(APUploadFile *)uploadFile
{
    for (APUploadFile *file in self.uploadTaskArr)
    {
        if ([file isEqual:uploadFile]) {
            return file;
        }
    }
    NSLog(@"Error：任务不存在或已经结束");
    return nil;
}

- (void)removeTaskWithFile:(APUploadFile *)file
{
    APUploadFile *uploadFile = [self fileWithUploadFile:file];
    if (uploadFile == nil)
    {
        return;
    }
    [self.uploadTaskArr removeObject:uploadFile];
}

- (float)uploadPersentOfUploadFile:(APUploadFile *)uploadFile;
{
    NSNumber *persent = [self.uploadingTaskDic objectForKey:uploadFile.fileUrl.path];
    return persent.floatValue;
}

@end
