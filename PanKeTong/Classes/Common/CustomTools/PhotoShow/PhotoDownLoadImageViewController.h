//
//  PhotoDownLoadImageViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/14.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//



#import "BaseViewController.h"
#import "BRImageScrollView.h"
/// 实勘详情大图预览
@interface PhotoDownLoadImageViewController : BaseViewController

@property (assign, nonatomic) NSInteger curImageindex;
@property (nonatomic,copy) NSString *propKeyId;
@property (nonatomic,assign) BOOL isItem;

@end
