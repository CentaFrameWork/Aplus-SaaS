//
//  UserGuideViewController.h
//  PanKeTong
//
//  Created by zhwang on 16/4/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"

@interface UserGuideViewController : BaseViewController

/*!
 *  图片引导初始化
 *
 *  @param arrayImage 图片数组
 *
 *  @return 初始化UserGuideViewController对象
 */
- (id)initWithArrayGuideImage:(NSMutableArray *)arrayGuideImage;
@end
