//
//  UploadListCell.h
//  AplusVideoUploadDemo
//
//  Created by Liyn on 2017/11/22.
//  Copyright © 2017年 Liyn. All rights reserved.
//




#import <UIKit/UIKit.h>
//#import "UploadModel.h"
#import "APUploadFile.h"
#import "UploadStatusDefine.h"

typedef void(^ChangUploadSequenceBlock)(UploadStatus status);

@interface UploadListCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *beginDateLabel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *fileNameLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UIView *sepLine;

// 改变上传状态
@property (nonatomic,   copy) ChangUploadSequenceBlock changeSequence;

- (void)setUploadModel:(APUploadFile *)uploadModel;
@end
