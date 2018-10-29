//
//  PhotoAlbumListViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/15.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@protocol PhotoAlbumDetailDelegate <NSObject>

-(void)selectPhotoAssetSuccess:(NSMutableArray *)photoAssetItems;

@end

@interface PhotoAlbumListViewController : BaseViewController

@property (nonatomic,assign) id <PhotoAlbumDetailDelegate> delegate;
@property (nonatomic,strong) ALAssetsLibrary *photoLibrary;
@property (nonatomic,strong) NSMutableArray  *selectedPhotosArr;    //已经选择过的图片

@end
