//
//  UIImage+Cap.h
//  LianDong
//
//  Created by ByronYan on 14-6-27.
//  Copyright (c) 2014年 Grant Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Cap)

/**
 *  当前支持简单的边帽设置
 *
 *  @param name      图片名字
 *  @param capInsets 边帽的距离
 *
 *  @return
 */
+ (UIImage *)imageNamed:(NSString *)name withCapInsets:(UIEdgeInsets)capInsets;

- (NSString *)base64ImageStr;
-(UIImage *)scaledImage;
- (UIImage*)getSmallImage;
+ (UIImage *)resizableImageWithImageName:(NSString *)imageName;

@end
