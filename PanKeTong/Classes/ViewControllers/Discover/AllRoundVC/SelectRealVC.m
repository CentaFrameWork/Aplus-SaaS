//
//  SelectRealVC.m
//  PanKeTong
//
//  Created by 张旺 on 2017/11/22.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SelectRealVC.h"
#import "GetAllRealSurveyPhotoApi.h"
#import "CheckRealSurveyApi.h"
#import "CheckRealSurveyEntity.h"
#import "PhotoEntity.h"
#import "SelectRealCollectionCell.h"
#import "RealPhotoAndVideoVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SelectRealVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    __weak IBOutlet UICollectionView *_mainCollectionView;
    
    GetAllRealSurveyPhotoApi *_photoApi;
    CheckRealSurveyApi *_checkRealSurveyApi;
    NSMutableArray *_imageSource;
}

@end

@implementation SelectRealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
    [self initData];
}

#pragma mark Init

- (void)initView
{
    [self setNavTitle:@"查看实勘"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"SelectRealCollectionCell" bundle:nil]
          forCellWithReuseIdentifier:@"SelectRealCollectionCell"];
}

- (void)initData
{
    _checkRealSurveyApi = [CheckRealSurveyApi new];
    _photoApi = [GetAllRealSurveyPhotoApi new];
    
    [self showLoadingView:nil];
    _imageSource = [NSMutableArray array];
    
    if (_isItem)
    {
        _checkRealSurveyApi.keyId = _propKeyId;
        [_manager sendRequest:_checkRealSurveyApi];
    }
    else
    {
        _photoApi.keyId = _propKeyId;
        [_manager sendRequest:_photoApi];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectRealCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectRealCollectionCell"
                                                                               forIndexPath:indexPath];
    
    PhotoEntity *photoEntity = [_imageSource objectAtIndex:indexPath.row];
    
    // 添加水印后的图片
    NSString *newImagePath = [NSString stringWithFormat:@"%@%@&watermark=smallgroup_center",photoEntity.imgPath,PhotoDownWidth];
    
    if ([photoEntity.isVideo boolValue])
    {
        
        [CommonMethod setImageWithImageView:cell.estateImage
                                andImageUrl:photoEntity.thumbPhotoPath
                    andPlaceholderImageName:@"defaultPropBig_bg"];
    
        cell.imageType.hidden = NO;
    }else
    {
        [CommonMethod setImageWithImageView:cell.estateImage
                                andImageUrl:newImagePath
                    andPlaceholderImageName:@"defaultPropBig_bg"];
        cell.imageType.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RealPhotoAndVideoVC *realPhotoAndVideoVC = [[RealPhotoAndVideoVC alloc] initWithNibName:@"RealPhotoAndVideoVC" bundle:nil];
    realPhotoAndVideoVC.imageSource = _imageSource;
    realPhotoAndVideoVC.curImageindex = indexPath.row;
    [self.navigationController pushViewController:realPhotoAndVideoVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //  每列的宽度 = (屏幕宽 - 两边边距 - 两个按钮直接的间距 *(num-1) ) / num
    CGFloat itemSideSize = (APP_SCREEN_WIDTH - 20) / 3;
    return CGSizeMake(itemSideSize, itemSideSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    // 行间距
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    // 列间距
    return 5;
}

#pragma mark - ResponseDelegate

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[CheckRealSurveyEntity class]])
    {
        [self hiddenLoadingView];
        
        CheckRealSurveyEntity *propAllPhotos = [DataConvert convertDic:data toEntity:modelClass];
        
        if (propAllPhotos.photos.count > 0)
        {
            [_imageSource addObjectsFromArray:propAllPhotos.photos];
            
            [_mainCollectionView reloadData];    
        }
    }
}

@end
