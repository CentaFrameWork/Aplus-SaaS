//
//  PhotoAssetsItemEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/16.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface PhotoAssetsItemEntity : NSObject

@property (nonatomic,strong) UIImage *photoThumbnailImage;      //相册图片的封面图
@property (nonatomic,strong) UIImage *photoAspectRatioThumbnailImage;  //相册图片等比例图片
@property (nonatomic,assign) NSInteger photoThumbnailIndex;     //图片所在的位置index
@property (nonatomic,assign) BOOL isSelected;                   //是否点选了当前的图片
@property (nonatomic,assign) BOOL isPanorama;                   //是否为全景图

@property (nonatomic,strong) NSString *photoAssetTypeTitleStr;      //图片的类型
@property (nonatomic,assign) NSInteger photoAssetTypeTitleTypeEnum;     //图片的类型的枚举值

@property (nonatomic,strong) NSString *photoAssetTypeTextStr;       //图片的类型显示的值
@property (nonatomic,strong) NSString *photoAssetTypeValueStr;      //图片的类型请求用到的值
@property (nonatomic,assign) NSInteger photoassetTypeTextIndex;     //图片的类型的值的index
@property (nonatomic,strong) NSURL *photoURL;                       //图片路径

@property (nonatomic,strong) id realALAssetValue;         //相册图片的原数据

@end
