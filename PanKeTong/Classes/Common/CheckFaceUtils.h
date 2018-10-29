//
//  CheckFaceUtils.h
//  PanKeTong
//
//  Created by 乔书超 on 2017/12/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"

/// 检查是否采集过人脸
@interface CheckFaceUtils : NSObject<ResponseDelegate>

@property (nonatomic, strong) RequestManager *manager;

+ (CheckFaceUtils *)sharedFaceUtils;

- (void)checkFaceExists;

@end
