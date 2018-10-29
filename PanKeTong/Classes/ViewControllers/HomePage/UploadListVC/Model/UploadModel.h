//
//  UploadModel.h
//  AplusVideoUploadDemo
//
//  Created by Liyn on 2017/11/22.
//  Copyright © 2017年 Liyn. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "UploadStatusDefine.h"

@interface UploadModel : NSObject
// 上传的区域名称
@property (nonatomic, copy) NSString *uploadItemName;
// 上传的文件名
@property (nonatomic, copy) NSString *fileName;
// 上传文件的总大小
@property (nonatomic, assign) NSInteger totalSize;
// 已上传完成的大小
@property (nonatomic, assign) NSInteger uploadedSize;
// 已上传完成的百分比
@property (nonatomic, assign) float progress;
// 创建上传任务的时间
@property (nonatomic, strong) NSDate *beginDate;
// 任务的状态
@property (nonatomic, assign) UploadStatus uploadStatus;

@end
