//
//  EstReleaseDetailPhotoViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "EstReleaseDetailPhotoViewController.h"
#import "EstReleaseDetailImgResultEntity.h"
#import "BRImageScrollView.h"

#define YCSaveToPhotoAlbum  1001

@interface EstReleaseDetailPhotoViewController ()<BRImageScrollViewDelegate>
{  
    __weak IBOutlet BRImageScrollView *_imageScrollView;
    BRIamgeViewItem *_curImageViewItem;

}
@end


@implementation EstReleaseDetailPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    _imageScrollView.delegate = self;

   [_imageScrollView scrollToIndex:_count];
}

- (void)initView
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
#pragma mark - <DownImageMethod>

#pragma mark - DownImageMethod
-(void)downImageMethod
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.cancelButtonIndex) {
        
        return;
        
    }
    
    if (alertView.tag == YCSaveToPhotoAlbum) {
        
        UIImage *saveImage = _curImageViewItem.mImageView.image;
        UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image: didFinishSavingWithError:contextInfo:), NULL);
        
    }
    
}

#pragma mark - <BRImageScrollViewDelegate>
- (NSInteger)numberOfPhotos
{

    return [self.imageArray count];
}

- (void)imageAtIndex:(NSInteger)index photoView:(BRIamgeViewItem *)photoView
{

    EstReleaseDetailImgResultEntity *firstPostImg = [self.imageArray objectAtIndex:index];
    
    [CommonMethod setImageWithImageView:photoView.mImageView
                            andImageUrl:firstPostImg.imgPath
                andPlaceholderImageName:@"defaultPropBig_bg"];

}

- (void)imageAtCurrentIndex:(NSInteger)index photoView:(BRIamgeViewItem *)thumbView
{

    EstReleaseDetailImgResultEntity *firstPostImg = [self.imageArray objectAtIndex:index];
    
    [CommonMethod setImageWithImageView:thumbView.mImageView
                            andImageUrl:firstPostImg.imgPath
                andPlaceholderImageName:@"defaultPropBig_bg"];

    NSString *titleStr = [NSString stringWithFormat:@"%@/%@",@(index+1),@(self.imageArray.count)];
    self.title = titleStr;

    _curImageViewItem = thumbView;

}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    if(error != NULL){
        showJDStatusStyleErrorMsg(@"保存图片失败");
    }else{
        showJDStatusStyleSuccMsg(@"保存图片成功");
    }
    
}


@end
