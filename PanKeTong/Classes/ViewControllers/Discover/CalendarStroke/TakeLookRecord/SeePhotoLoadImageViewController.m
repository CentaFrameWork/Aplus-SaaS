//
//  SeePhotoLoadImageViewController.m
//  PanKeTong
//
//  Created by 张旺 on 17/2/13.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SeePhotoLoadImageViewController.h"

#define YCSaveToPhotoAlbum 1001

@interface SeePhotoLoadImageViewController ()

@end

@implementation SeePhotoLoadImageViewController
{
    __weak IBOutlet UIImageView *_seeListImage;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)initView
{
    
    // 缩放手势
//    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
//    
//    [_seeListImage addGestureRecognizer:pinchGestureRecognizer];
//    [_seeListImage setUserInteractionEnabled:YES];
//    [_seeListImage setMultipleTouchEnabled:YES];
    
    [self setNavTitle:@"看房单"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"icon_jm_down_load_gray"
                                            sel:@selector(downImageMethod)]];
    
}

// 处理缩放手势
//- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
//{
//    UIView *view = pinchGestureRecognizer.view;
//    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
//        pinchGestureRecognizer.scale = 1;
//    }
//}

-(void)initData
{
    [CommonMethod setImageWithImageView:_seeListImage
                            andImageUrl:_seeImageUrl
                andPlaceholderImageName:@"defaultPropBig_bg"];
    
}

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
        
        UIImage *saveImage = _seeListImage.image;
        
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



@end
