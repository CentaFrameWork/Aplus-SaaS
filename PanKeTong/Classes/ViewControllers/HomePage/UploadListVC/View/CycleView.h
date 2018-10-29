//
//  CycleView.h
//  AplusVideoUploadDemo
//
//  Created by Liyn on 2017/11/22.
//  Copyright © 2017年 Liyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadStatusDefine.h"

@interface CycleView : UIView
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) UploadStatus uploadStatus;
@property (nonatomic, strong) UIImageView *statusImageView;

@property (nonatomic, strong)  CAShapeLayer *grayCyclelayer;
@property (nonatomic, strong)  CAShapeLayer *cyclelayer;
@end
