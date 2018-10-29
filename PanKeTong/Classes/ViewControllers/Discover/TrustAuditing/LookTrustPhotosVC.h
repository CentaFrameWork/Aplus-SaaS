//
//  LookTrustPhotosVC.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/6/5.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

@interface LookTrustPhotosVC : BaseViewController<UIScrollViewDelegate>

@property (nonatomic,copy) NSString *navTitleStr;
@property (nonatomic,strong) NSArray *dataArr;

// 创建一个全局变量，用于记录上一次滑动的坐标
@property (nonatomic,assign) NSInteger lastIndex;

@property (nonatomic, assign) BOOL isHaveImgType;


@end
