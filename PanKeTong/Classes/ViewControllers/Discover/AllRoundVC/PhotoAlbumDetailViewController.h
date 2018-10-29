//
//  PhotoAlbumDetailViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/15.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "PhotoAlbumListViewController.h"
#import "PhotoAssetsItemEntity.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface PhotoAlbumDetailViewController : BaseViewController

@property (nonatomic,strong) PhotoAlbumListViewController *photoAlbumListVC;
@property (nonatomic,strong) NSString * selectAssetsPersistentId;   //选择的相册的ID
@property (nonatomic,strong) NSString * selectAssetsGroupName;  //相簿名称
@property (nonatomic,strong) ALAssetsLibrary *photoAssetsLibrary;

@property (nonatomic,strong) NSMutableArray *selectedPhotosArr; //已经选择过的图片,为了防止选择超过9张

@end