//
//  ShowPhotoAssetsViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/16.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"

@protocol ShowPhotoAssetsDelegate <NSObject>

- (void)photoAssetsSource:(NSMutableArray *)array andUrl:(NSMutableArray *)urlArr;

@end

@interface ShowPhotoAssetsViewController : BaseViewController

@property (nonatomic,strong) NSMutableArray *photoAssetsSource;
@property (nonatomic,strong) NSMutableArray *photoAssetsUrlArr;
@property (nonatomic,assign) NSInteger selectImageIndex;
@property (nonatomic,assign) BOOL isLockRoom;
@property (nonatomic,assign) id<ShowPhotoAssetsDelegate>delegate;

@end
