//
//  SeeEstatePhotoViewController.m
//  PanKeTong
//
//  Created by 张旺 on 17/4/20.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SeeEstatePhotoViewController.h"

#define NavigationHeight    44

#define YCSaveToPhotoAlbum 1001

@interface SeeEstatePhotoViewController ()<UIScrollViewDelegate>

@end

@implementation SeeEstatePhotoViewController
{
    UIImageView * _imageView;
    
    CGFloat scaleNum;//图片放大倍数
    UIScrollView * _scrollview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self initImageLoad];
}

-(void)initImageLoad
{
    [self setNavTitle:@"看房单"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"icon_jm_down_load_gray"
                                            sel:@selector(downImageMethod)]];
    
    
    //图片
    
//    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, self.view.size.height / 8)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [CommonMethod setImageWithImageView:_imageView
                            andImageUrl:_seeImageUrl
                andPlaceholderImageName:@"defaultPropBig_bg"];
    
    
//    _imageView.frame = CGRectMake(0,((self.view.height  - (_imageView.frame.size.height * self.view.width/_imageView.frame.size.width+100))/2) - NavigationHeight, self.view.width, _imageView.frame.size.height * self.view.width/_imageView.frame.size.width + 100);

    
    //双击手势
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:doubleTapGesture];
    
    //添加捏合手势，放大与缩小图片
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,APP_SCREEN_WIDTH,APP_SCREEN_HEIGHT - 64)];
    
    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    _scrollview.contentSize = _imageView.frame.size;
    //设置实现缩放
    //设置代理scrollview的代理对象
    _scrollview.delegate = self;
    //设置最大伸缩比例
    _scrollview.maximumZoomScale = 3;
    //设置最小伸缩比例
    _scrollview.minimumZoomScale = 1;
    [_scrollview setZoomScale:1 animated:NO];
    
    _scrollview.scrollsToTop = NO;
    _scrollview.scrollEnabled = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    
    
    
    [_scrollview addSubview:_imageView];
    [self.view addSubview:_scrollview];
    
}

#pragma mark - 处理双击手势
-(void)handleDoubleTap:(UIGestureRecognizer *)sender{
    if (scaleNum >= 1 && scaleNum <= 2) {
        scaleNum++;
    }else{
        scaleNum=1;
    }
    [_scrollview setZoomScale:scaleNum animated:YES];
}
#pragma mark - UIScrollViewDelegate,告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}
#pragma mark - 等比例放大，让放大的图片保持在scrollView的中央
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (_scrollview.bounds.size.width > _scrollview.contentSize.width)?(_scrollview.bounds.size.width - _scrollview.contentSize.width) *0.5 : 0.0;
    CGFloat offsetY = (_scrollview.bounds.size.height > _scrollview.contentSize.height)?
    (_scrollview.bounds.size.height - _scrollview.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(_scrollview.contentSize.width *0.5 + offsetX,_scrollview.contentSize.height *0.5 + offsetY);
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
        
        UIImage *saveImage = _imageView.image;
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
