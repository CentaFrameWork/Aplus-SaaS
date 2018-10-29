//
//  RealPhotoAndVideoVC.m
//  PanKeTong
//
//  Created by 张旺 on 2017/11/22.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "RealPhotoAndVideoVC.h"
#import "PhotoEntity.h"
#import "MoviePlayerVC.h"

#define YCSaveToPhotoAlbum 1001

@interface RealPhotoAndVideoVC ()<BRImageScrollViewDelegate>
{
    __weak IBOutlet BRImageScrollView *_imageScrollView;
    __weak IBOutlet UIImageView *_playVideoImage;
    
    
    BRIamgeViewItem *_curImageViewItem;
}

@end

@implementation RealPhotoAndVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavTitleIsHideRightButtonItem:NO];
    [self initData];
}

#pragma mark - Init

- (void)setNavTitleIsHideRightButtonItem:(BOOL)isHideRightButtonItem
{
    if (isHideRightButtonItem)
    {
        [self setNavTitle:nil
           leftButtonItem:[self customBarItemButton:nil
                                    backgroundImage:nil
                                         foreground:@"backBtnImg"
                                                sel:@selector(back)]
          rightButtonItem:nil];
    }else
    {
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
}

- (void)initData
{
    [_imageScrollView reloadData];
    _imageScrollView.delegate = self;
    
    [_imageScrollView scrollToIndex:_curImageindex];
    
    self.title = [NSString stringWithFormat:@"%ld/%@",_curImageindex + 1,@(_imageSource.count)];
}

#pragma mark - DownImageMethod

- (void)downImageMethod
{
    
    
    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"是否保存到相册" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    
    av.tag = YCSaveToPhotoAlbum;
    
    [av show];
    
//    BYActionSheetView *actionSheetView = [[BYActionSheetView alloc] initWithTitle:@"是否保存到相册"
//                                                                         delegate:self
//                                                                cancelButtonTitle:@"否"
//                                                                otherButtonTitles:@"是", nil];
//    [actionSheetView show];
}

#pragma mark - BRImageScrollViewDelegate
- (NSInteger)numberOfPhotos
{
    return [_imageSource count];
}

- (void)imageAtIndex:(NSInteger)index photoView:(BRIamgeViewItem *)photoView
{
    PhotoEntity *propDetailEntity = [_imageSource objectAtIndex:index];
    
    if ([propDetailEntity.isVideo boolValue])
    {
        _playVideoImage.hidden = NO;
        
        [CommonMethod setImageWithImageView:photoView.mImageView
                                andImageUrl:propDetailEntity.thumbPhotoPath
                    andPlaceholderImageName:@"defaultPropBig_bg"];
        
        return;
    }else
    {
        _playVideoImage.hidden = YES;
    }
    
    // 添加水印后的图片
    NSString *newImagePath = [NSString stringWithFormat:@"%@%@&watermark=smallgroup_center",propDetailEntity.imgPath,PhotoDownWidth];
    
    [CommonMethod setImageWithImageView:photoView.mImageView
                            andImageUrl:newImagePath
                andPlaceholderImageName:@"defaultPropBig_bg"];
}

- (void)imageAtCurrentIndex:(NSInteger)index photoView:(BRIamgeViewItem *)thumbView
{
    PhotoEntity *propDetailEntity = [_imageSource objectAtIndex:index];
    
    if ([propDetailEntity.isVideo boolValue])
    {
        [self setNavTitleIsHideRightButtonItem:YES];
         _playVideoImage.hidden = NO;
        NSString *titleStr = [NSString stringWithFormat:@"%@/%@",@(index+1),@(_imageSource.count)];
        self.title = titleStr;
        
        [CommonMethod setImageWithImageView:thumbView.mImageView
                                andImageUrl:propDetailEntity.thumbPhotoPath
                    andPlaceholderImageName:@"defaultPropBig_bg"];
        
        _curImageViewItem = thumbView;
        return;
    }else
    {
         _playVideoImage.hidden = YES;
    }
    
    // 添加水印后的图片
    NSString *newImagePath = [NSString stringWithFormat:@"%@%@&watermark=smallgroup_center",propDetailEntity.imgPath,PhotoDownWidth];
    
    [CommonMethod setImageWithImageView:thumbView.mImageView
                            andImageUrl:newImagePath
                andPlaceholderImageName:@"defaultPropBig_bg"];
    
    [self setNavTitleIsHideRightButtonItem:NO];
    NSString *titleStr = [NSString stringWithFormat:@"%@/%@",@(index+1),@(_imageSource.count)];
    self.title = titleStr;
    
    _curImageViewItem = thumbView;
}

/// 点击调到播放视频
- (void)tapImageViewAtIndex:(NSInteger)index
{
    PhotoEntity *propDetailEntity = [_imageSource objectAtIndex:index];
    if ([propDetailEntity.isVideo boolValue])
    {
        MoviePlayerVC *moviePlayerVC = [[MoviePlayerVC alloc] init];
        moviePlayerVC.videoUrl = propDetailEntity.imgPath;
        [self.navigationController presentViewController:moviePlayerVC animated:YES completion:nil];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.cancelButtonIndex) {
        
        return;
        
    }
    
    if (alertView.tag == YCSaveToPhotoAlbum) {
        
        UIImage *saveImage = _curImageViewItem.mImageView.image;
        UIImageWriteToSavedPhotosAlbum(saveImage,
                                       self,
                                       @selector(image:
                                                 didFinishSavingWithError:contextInfo:),
                                       NULL);
        
    }
    
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    if(error != NULL){
        showJDStatusStyleErrorMsg(@"保存图片失败");
    }else{
        showJDStatusStyleSuccMsg(@"保存图片成功");
    }
    
}

@end
