//
//  PhotoDownLoadImageViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/14.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PhotoDownLoadImageViewController.h"
#import "PhotoEntity.h"
#import "GetAllRealSurveyPhotoApi.h"
#import "CheckRealSurveyApi.h"
#import "CheckRealSurveyEntity.h"
#import "ShowPanoramaViewCtontroller.h"
#import "UIImageView+WebCache.h"

#define PanoramaTag 10000

#define YCSaveToPhotoAlbum 1001

@interface PhotoDownLoadImageViewController ()<BRImageScrollViewDelegate>
{
    GetAllRealSurveyPhotoApi *_photoApi;
    CheckRealSurveyApi *_checkRealSurveyApi;
    
    __weak IBOutlet UIButton *_checkPanorama;
    __weak IBOutlet UILabel *_panoramaLable;
    __weak IBOutlet BRImageScrollView *_imageScrollView;
    __weak IBOutlet UILabel *_photoTypeLabel;
    
    NSMutableArray *_imageSource;
    BRIamgeViewItem *_curImageViewItem;
    NSInteger _selectInteger;
    

}

@end

@implementation PhotoDownLoadImageViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Init

- (void)initView
{
    _panoramaLable.hidden = YES;
    _checkPanorama.hidden = YES;
    _photoTypeLabel.hidden = YES;
    
    [_checkPanorama addTarget:self action:@selector(checkPanoramaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setNavTitle:nil
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"icon_jm_down_load_gray"
                                            sel:@selector(downImageMethod)]];
}



- (void)initData {
    _photoApi = [GetAllRealSurveyPhotoApi new];
    _checkRealSurveyApi = [CheckRealSurveyApi new];
    
    [self showLoadingView:nil];
    _imageSource = [NSMutableArray array];
    
    if (_isItem){
        
        _checkRealSurveyApi.keyId = _propKeyId;
        [_manager sendRequest:_checkRealSurveyApi];
    
    }else{
        
        _photoApi.keyId = _propKeyId;
        [_manager sendRequest:_photoApi];
    }
}

#pragma mark - DownImageMethod

- (void)downImageMethod {
    
    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"是否保存到相册" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    
    av.tag = YCSaveToPhotoAlbum;
    
    [av show];
    
//    BYActionSheetView *actionSheetView = [[BYActionSheetView alloc] initWithTitle:@"是否保存到相册"
//                                                                         delegate:self
//                                                                cancelButtonTitle:@"否"
//                                                                otherButtonTitles:@"是", nil];
//
//    actionSheetView.TitleBtn.userInteractionEnabled = NO;
//
//
//
//    [actionSheetView show];
}

#pragma mark - BRImageScrollViewDelegate

- (NSInteger)numberOfPhotos
{
    return [_imageSource count];
}

- (void)imageAtIndex:(NSInteger)index photoView:(BRIamgeViewItem *)photoView {

    PhotoEntity *propDetailEntity = [_imageSource objectAtIndex:index];
    
     NSString *newImagePath = [NSString stringWithFormat:@"%@%@",propDetailEntity.imgPath, PhotoDownWidth];

    
    [CommonMethod setImageWithImageView:photoView.mImageView
                            andImageUrl:newImagePath
                andPlaceholderImageName:@"defaultPropBig_bg"];
}

- (void)imageAtCurrentIndex:(NSInteger)index photoView:(BRIamgeViewItem *)thumbView
{
    _checkPanorama.tag = PanoramaTag + index;
    _selectInteger = index;
    PhotoEntity *propDetailEntity = [_imageSource objectAtIndex:index];
    
    
    NSString *newImagePath = [NSString stringWithFormat:@"%@%@",propDetailEntity.imgPath, PhotoDownWidth];
    // 添加水印后的图片
//    NSString *newImagePath = [NSString stringWithFormat:@"%@%@%@",propDetailEntity.imgPath, PhotoDownWidth, WaterMark];
    
    [CommonMethod setImageWithImageView:thumbView.mImageView
                            andImageUrl:newImagePath
                andPlaceholderImageName:@"defaultPropBig_bg"];
    
    NSString *titleStr = [NSString stringWithFormat:@"%@/%@",@(index+1),@(_imageSource.count)];
    self.title = titleStr;
    
    _curImageViewItem = thumbView;
    
}

- (void)checkPanoramaAction:(UIButton *)button
{
    NSInteger index = button.tag - PanoramaTag;
    
    PhotoEntity *propDetailEntity = [_imageSource objectAtIndex:index];

    ShowPanoramaViewCtontroller *showPanoramaVC = [ShowPanoramaViewCtontroller new];
    showPanoramaVC.photoPath = propDetailEntity.imgPath;
    
    [self presentViewController:showPanoramaVC animated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.cancelButtonIndex) {
        
        return;
        
    }
    
    if (alertView.tag == YCSaveToPhotoAlbum) {
        
        PhotoEntity *propDetailEntity = [_imageSource objectAtIndex:_selectInteger];
        NSString *newImagePath = [NSString stringWithFormat:@"%@%@",propDetailEntity.imgPath, RealPhotoDownWidth];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:newImagePath]];
        UIImage *saveImage = [UIImage imageWithData:data]; // 取得图片
        
        UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
    }
    
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    if(error != NULL){
        showJDStatusStyleErrorMsg(@"保存图片失败");
    }else{
        showJDStatusStyleSuccMsg(@"保存图片成功");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
            [_imageScrollView reloadData];
            _imageScrollView.delegate = self;
            
            if (self.isItem)
            {
                [_imageScrollView scrollToIndex:_curImageindex];
            }
            
            NSInteger currentImgIndex = (self.isItem == YES) ? (_curImageindex + 1) : 1;
            self.title = [NSString stringWithFormat:@"%ld/%@",currentImgIndex,@(_imageSource.count)];
        }
    }
}

@end
