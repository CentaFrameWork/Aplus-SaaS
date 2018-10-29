//
//  APUploadFile.h
//  PanKeTong
//
//  Created by 张旺 on 2017/11/24.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APUploadFile : NSObject

@property (nonatomic, copy) NSString *estateName;         // 上传楼盘名称
@property (nonatomic, copy) NSString *estateId;           // 楼盘Id
@property (nonatomic, copy) NSString *startTime;          // 起始时间
@property (nonatomic, copy) NSString *videoName;          // 视频名称
@property (nonatomic, copy) UIImage *videoImage;          // 视频缩略图
@property (nonatomic, assign) NSInteger videoTotalSize;   // 视频总大小
@property (nonatomic, copy) NSString *uploadedSize;       // 已上传完成的大小
@property (nonatomic, assign) float progress;             // 上传进度
@property (nonatomic, copy) NSString *uploadSpeed;        // 上传速度
@property (nonatomic, strong) NSURL *fileUrl;             // 上传路径
@property (nonatomic, assign) UploadStatus uploadState;   // 上传状态
@property (nonatomic, copy) NSString *uploadFileKey;      // 唯一标识
@property (nonatomic, copy) NSString *token;              // 上传token
@property (nonatomic, assign) NSInteger realListIndex;    // 实勘列表索引
@property (nonatomic, copy) NSString *realKeyId;          // 实勘ID
@property (nonatomic, copy) NSArray *realImageArr;        // 之前的实勘图
@property (nonatomic, assign) BOOL isTranscoding;         // 是否转码中

@end
