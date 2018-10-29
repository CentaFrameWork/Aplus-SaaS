//
//  UploadRealSurveyViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/14.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface UploadRealSurveyViewController : BaseViewController

// 相册数据库对象需保存为全局的，不然在大图页面生命周期会结束
@property (nonatomic, strong) ALAssetsLibrary *photoAssetsLibrary;

@property (nonatomic, strong) NSString *propKeyId;   //房源keyId
@property (nonatomic, assign) NSInteger widthScale;
@property (nonatomic, assign) NSInteger hightScale;
@property (nonatomic, assign) NSInteger imgUploadCount;
@property (nonatomic, assign) NSInteger imgRoomMaxCount;// 户型图的最大值
@property (nonatomic, assign) NSInteger imgAreaMaxCount;
@property (nonatomic, assign) NSInteger minUpdateCount; // 最小上传数量
@property (nonatomic, assign) NSInteger maxUpdateCount; // 最大上传数量
@property (nonatomic, assign) BOOL isLockRoom;

@property (nonatomic, copy) void (^uploadRealSurveySuccessBlock)();

@end
