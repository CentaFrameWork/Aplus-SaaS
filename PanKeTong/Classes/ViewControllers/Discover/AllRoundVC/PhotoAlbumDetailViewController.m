//
//  PhotoAlbumDetailViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/15.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PhotoAlbumDetailViewController.h"
#import "PhotoAlbumDetailCell.h"

#define PhotoAssetItemBtnTag            1000
#define LoadingQuantity                 100

@interface PhotoAlbumDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate>
{
    
    NSMutableArray *_photoAssetsListArray;
    NSMutableArray *_selectPhotoAssetArray;
    __weak IBOutlet UICollectionView *_mainCollectionView;
    
    
    NSInteger _collectionContentY;
    NSInteger _loadingQuantity;
    
}

@end

@implementation PhotoAlbumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}

-(void)initView
{
    
    [self setNavTitle:_selectAssetsGroupName
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"完成"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(selectPhotoSuccess)]];
    
    UINib *collectionCellNib = [UINib nibWithNibName:@"PhotoAlbumDetailCell" bundle:nil];
    [_mainCollectionView registerNib:collectionCellNib
          forCellWithReuseIdentifier:@"photoAlbumDetailCell"];
}



- (void)initData
{
    _loadingQuantity = LoadingQuantity;
    _photoAssetsListArray = [[NSMutableArray alloc]init];
    _selectPhotoAssetArray = [[NSMutableArray alloc]init];
    
    /**
     *  ALAssetsGroupAll    取得全部类型的相簿
     *
     */
    __weak typeof (self) weakSelf = self;
    
    [_photoAssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                       usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                           
                                           if (group) {
                                               
                                               /**
                                                *  添加照片、视频过滤条件
                                                */
                                               [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                               
                                               [weakSelf dealAssetsGroupListSuccessWithGroup:group];
                                               
                                           }
                                           
                                       } failureBlock:^(NSError *error) {
                                           
                                       }];
    
}

-(void)dealAssetsGroupListSuccessWithGroup:(ALAssetsGroup *)assetsGroup
{
    
    if (assetsGroup) {
        
        //相册的名称
        NSString *assetsPersistentId = [assetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
        //相册的照片数量
        NSInteger assetsGroupImageCount = [assetsGroup numberOfAssets];
        
        //过滤后的照片数量为零
        if (assetsGroupImageCount == 0) {
            
            return;
        }
        
        [self showLoadingView:@"加载中..."];
        
        __weak typeof (self) weakSelf = self;
        
        if ([_selectAssetsPersistentId isEqualToString:assetsPersistentId]) {
            
            //  后台执行：
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    
                    // 主线程执行：
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (result) {
                            
                            [weakSelf dealAssetsPhotoWithResult:result
                                                       andIndex:index];
                        }else{
                            
                            [weakSelf getAssetsPhotoSuccess];
                        }
                    });
                    
                }];
                
            });
        }
    }
    
}

-(void)dealAssetsPhotoWithResult:(ALAsset *)assetsResult andIndex:(NSInteger)currentIndex
{
    
    PhotoAssetsItemEntity *photoAssetsEntity = [[PhotoAssetsItemEntity alloc]init];
    
    //    UIImage *alAssetImage = [[UIImage alloc]initWithCGImage:[assetsResult thumbnail]];
    
    //    photoAssetsEntity.photoThumbnailImage = alAssetImage;
    photoAssetsEntity.photoThumbnailIndex = currentIndex;
    photoAssetsEntity.isSelected = NO;
//    photoAssetsEntity.realALAssetValue = assetsResult;
    
    [_photoAssetsListArray addObject:photoAssetsEntity];
    
    
    
}

/**
 *  获取相册图片完成
 */
-(void)getAssetsPhotoSuccess
{
    [self hiddenLoadingView];
    
    // 倒叙先加载100张
    [self upsideDownLoadingPhoto];
    
    [_mainCollectionView reloadData];
    
    [_mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_photoAssetsListArray.count-1
                                                                    inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionBottom
                                        animated:NO];
    
    _collectionContentY = _mainCollectionView.contentOffset.y;
    
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        //子线程异步执行下载任务，防止主线程卡顿
        
        for (int i = 0; i < _photoAssetsListArray.count; i++)
        {
            PhotoAssetsItemEntity *photoAssetsEntity = _photoAssetsListArray[i];
            
//            UIImage *alAssetImage = [[UIImage alloc]initWithCGImage:[photoAssetsEntity.realALAssetValue aspectRatioThumbnail]];
//            photoAssetsEntity.photoThumbnailImage = alAssetImage;
//            
            [_photoAssetsListArray replaceObjectAtIndex:i withObject:photoAssetsEntity];
            
        }
        
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        //异步返回主线程，根据获取的数据，更新UI
        dispatch_async(mainQueue, ^{
            NSLog(@"根据更新UI界面");
        });
        
    });
    
}

/**
 *  正序加载图片
 */
- (void)normalLoadingPhoto
{
    NSInteger arrCount = _photoAssetsListArray.count - 1;
    
    
    NSInteger maxQuantity = _loadingQuantity;
    
    if (_loadingQuantity == arrCount) {
        maxQuantity = arrCount;
    }
    
    if (_photoAssetsListArray.count < LoadingQuantity) {
        maxQuantity = arrCount;
        _loadingQuantity = arrCount;
    }
    
    NSInteger minQuantity = _loadingQuantity;
    
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        //子线程异步执行下载任务，防止主线程卡顿
        
        for (int i = 0; i >= minQuantity && i <= maxQuantity; i++) {
            
            PhotoAssetsItemEntity *photoAssetsEntity = _photoAssetsListArray[i];
            
//            UIImage *alAssetImage = [[UIImage alloc]initWithCGImage:[photoAssetsEntity.realALAssetValue aspectRatioThumbnail]];
            
//            photoAssetsEntity.photoThumbnailImage = alAssetImage;
            
            [_photoAssetsListArray replaceObjectAtIndex:i withObject:photoAssetsEntity];
        }
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        //异步返回主线程，根据获取的数据，更新UI
        dispatch_async(mainQueue, ^{
            [_mainCollectionView reloadData];
        });
        
    });

}


/**
 *  倒叙加载图片
 */
- (void)upsideDownLoadingPhoto
{
    NSInteger arrCount = _photoAssetsListArray.count - 1;
    
    
    NSInteger maxQuantity = arrCount - (_loadingQuantity - LoadingQuantity);
    
    if (_loadingQuantity == arrCount) {
        maxQuantity = arrCount % LoadingQuantity;
    }
    if (_loadingQuantity == LoadingQuantity) {
        maxQuantity = arrCount;
    }
    
    if (_photoAssetsListArray.count < LoadingQuantity) {
        maxQuantity = arrCount;
        _loadingQuantity = arrCount;
    }
    
    NSInteger minQuantity = arrCount - _loadingQuantity;
    
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        //子线程异步执行下载任务，防止主线程卡顿
        
        for (int i = maxQuantity; i >= minQuantity && i <= maxQuantity; i--) {
            
            PhotoAssetsItemEntity *photoAssetsEntity = _photoAssetsListArray[i];
            
//            UIImage *alAssetImage = [[UIImage alloc]initWithCGImage:[photoAssetsEntity.realALAssetValue aspectRatioThumbnail]];
//            
//            photoAssetsEntity.photoThumbnailImage = alAssetImage;
            
            [_photoAssetsListArray replaceObjectAtIndex:i withObject:photoAssetsEntity];
        }

        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        //异步返回主线程，根据获取的数据，更新UI
        dispatch_async(mainQueue, ^{
           [_mainCollectionView reloadData];
        });
        
    });
    
   
}


#pragma mark - UIScrollViewDelegate



//scrollView滚动时，就调用该方法。任何offset值改变都调用该方法。即滚动过程中，调用多次

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    NSLog(@"scrollViewDidScroll");
    
    CGPoint point = scrollView.contentOffset;
    
    NSLog(@"%f,%f",point.x,point.y);
    
    // 从中可以读取contentOffset属性以确定其滚动到的位置。
    
    NSInteger arrCount = _photoAssetsListArray.count - 1;
    
    
    if (_loadingQuantity == arrCount) {
        return;
    }
    
    
    
    if (point.y == 0) {
        _collectionContentY = 0;
        
        if( point.y - _collectionContentY > 200){
            if (_loadingQuantity + LoadingQuantity > arrCount)
            {
                // 剩下的图片数量不足100
                _loadingQuantity = arrCount;
            }
            else
            {
                _loadingQuantity += LoadingQuantity;
            }

        }
        

        
    }
    
    
    
    if (_collectionContentY - point.y > 200) {
        
        _collectionContentY = point.y;
        
        
        if (_loadingQuantity + LoadingQuantity > arrCount)
        {
            // 剩下的图片数量不足100
            _loadingQuantity = arrCount;
        }
        else
        {
            _loadingQuantity += LoadingQuantity;
        }
        
        //倒叙
        [self upsideDownLoadingPhoto];
        
    }
    
    
    // 注意：当ContentSize属性小于Frame时，将不会出发滚动
    
    
    
}

#pragma mark - UICollectionViewDelegate/DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _photoAssetsListArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat itemSideSize = ([[UIScreen mainScreen] bounds].size.width - 9) / 4;
    
    return CGSizeMake(itemSideSize, itemSideSize);
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"photoAlbumDetailCell";
    
    PhotoAlbumDetailCell *photoDetailCell = (PhotoAlbumDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PhotoAssetsItemEntity *alAssetItem = [_photoAssetsListArray objectAtIndex:indexPath.row];
    
    [photoDetailCell.assetsImageView setImage:alAssetItem.photoThumbnailImage];
    photoDetailCell.selectAssetsBtn.tag = PhotoAssetItemBtnTag+indexPath.row;
    [photoDetailCell.selectAssetsBtn addTarget:self
                                        action:@selector(clickAssetsItemWithBtn:)
                              forControlEvents:UIControlEventTouchUpInside];
    
    if (alAssetItem.isSelected) {
        
        photoDetailCell.selectAssetsView.hidden = NO;
    }else{
        
        photoDetailCell.selectAssetsView.hidden = YES;
    }
    
    return photoDetailCell;
}

-(void)clickAssetsItemWithBtn:(UIButton *)button
{
    
    NSInteger clickItemIndex = button.tag - PhotoAssetItemBtnTag;
    
    PhotoAssetsItemEntity *clickPhotoAssetItem = [_photoAssetsListArray objectAtIndex:clickItemIndex];
    
    //选择图片后，获取此图片的等比例的原图
//    UIImage *alAssetAspectRatioImage = [[UIImage alloc]initWithCGImage:
//                                        [clickPhotoAssetItem.realALAssetValue aspectRatioThumbnail]];
//    clickPhotoAssetItem.photoAspectRatioThumbnailImage = alAssetAspectRatioImage;
    
    
    //添加到当前选择过的数组中
    if (clickPhotoAssetItem.isSelected) {
        
        [_selectPhotoAssetArray removeObject:clickPhotoAssetItem];
    }
    else
    {
        NSInteger selectImgCount = _selectedPhotosArr.count + _selectPhotoAssetArray.count;
        
        NSInteger maxPhotoNumber = 30;
        
        if (selectImgCount >= maxPhotoNumber) {
            
            NSString *showMsgStr =[NSString stringWithFormat:@"最多选择%ld张",maxPhotoNumber];
            
            showMsg(showMsgStr);
            
            return;
        }
        
        [_selectPhotoAssetArray addObject:clickPhotoAssetItem];
    }
    
    clickPhotoAssetItem.isSelected = !clickPhotoAssetItem.isSelected;
    
    [_mainCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:clickItemIndex
                                                                      inSection:0]]];
}

/**
 *  点击完成按钮
 */
- (void)selectPhotoSuccess
{
    if (_selectPhotoAssetArray.count > 0)
    {
        [_photoAlbumListVC.delegate selectPhotoAssetSuccess:_selectPhotoAssetArray];
    }
    
    [_photoAlbumListVC dismissViewControllerAnimated:YES
                                          completion:^{
                                              
                                          }];
}

-(void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
