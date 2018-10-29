//
//  JMCropViewController.m
//  PanKeTong
//
//  Created by Admin on 2018/5/17.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMCropViewController.h"
#define cropRect CGRectMake(0, (APP_SCREEN_HEIGHT -APP_SCREEN_WIDTH *0.75)*0.5, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH *0.75);
@interface JMCropViewController ()
@property (nonatomic, strong) UIImageView *editImageView;

@property (nonatomic, strong) UIImage *editImage;

@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) CGRect largeFrame;
@property (nonatomic, assign) CGRect latestFrame;

@end

@implementation JMCropViewController

+ (instancetype)loadControllerWithImage:(UIImage *)image {
    
    JMCropViewController *vc = [[JMCropViewController alloc] init];
    vc.editImage = [self fixOrientation:image];
    
    return vc;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor blackColor];
    
    CGRect cropFrame = cropRect;
    
    CGFloat editImageW = cropFrame.size.width;
    CGFloat editImageH = self.editImage.size.height * (editImageW / self.editImage.size.width);
    CGFloat editImageX = cropFrame.origin.x + (cropFrame.size.width - editImageW) / 2;
    CGFloat editImageY = cropFrame.origin.y + (cropFrame.size.height - editImageH) / 2;
    
    
    CGRect editImageVRect = CGRectMake(editImageX, editImageY, editImageW, editImageH);
    
    self.editImageView = [[UIImageView alloc] initWithFrame:editImageVRect];
    self.editImageView.image = self.editImage;
    
    [self.view addSubview:self.editImageView];
    
    
    self.oldFrame = editImageVRect;
    self.largeFrame = CGRectMake(0, 0, 3 * self.oldFrame.size.width, 3 * self.oldFrame.size.height);
    
    self.latestFrame = editImageVRect;
   
    //剪切框
    
    UIView *view = [[UIView alloc] initWithFrame:cropFrame];
    view.layer.borderColor = YCThemeColorGreen.CGColor;
    view.layer.borderWidth = 1.0f;
    [self.view addSubview:view];
    
    
    
    UIView*view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, CGRectGetMinY(view.frame))];
    view1.backgroundColor = [UIColor blackColor];
    view1.alpha = 0.5;
    [self.view addSubview:view1];
    
    
    UIView*view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - CGRectGetMaxY(view.frame))];
    view2.backgroundColor = [UIColor blackColor];
    view2.alpha = 0.5;
    [self.view addSubview:view2];
    
    
    CGFloat width = (APP_SCREEN_WIDTH-18)*0.5;
    
    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, APP_SCREENSafeAreaHeight - 56, width, 50)];
    cancelBtn.contentHorizontalAlignment = 0;
    cancelBtn.backgroundColor = UICOLOR_RGB_Alpha(0xEAAB27,1.0);
    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [cancelBtn setLayerCornerRadius:5];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    
    
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtn.right+7, cancelBtn.y, width, 50)];
    sureBtn.backgroundColor = YCThemeColorGreen;
    sureBtn.titleLabel.textColor = [UIColor whiteColor];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    sureBtn.contentHorizontalAlignment = 0;
    [sureBtn setLayerCornerRadius:5];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    
    
    //导航
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, APP_SCREEN_WIDTH, 40)];
    label.textAlignment = 1;
    label.textColor = [UIColor whiteColor];
    label.text = @"图片裁切";
    [self.view addSubview:label];
    
    UIButton *cancelBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(-60, 15, width, 50)];
    [cancelBtn1 setImage:[UIImage imageNamed:@"返回箭头-白色"] forState:UIControlStateNormal];
    [cancelBtn1 addTarget:self action:@selector(cancelBtnClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn1];
    
    

    
    
}
- (void)cancelBtnClickBack:(UIButton*)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)cancelBtnClick:(UIButton*)btn {
    
    self.btnCancel();
}

- (void)sureBtnClick:(UIButton*)btn {
   
    self.btnSure([self getSubImage]);
}

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    UIView *view = self.editImageView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
        
        
    }else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.editImageView.frame;
        
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:0.3 animations:^{
            self.editImageView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer {
   
    UIView *view = self.editImageView;
    CGRect cropFrame = cropRect;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // calculate accelerator
        CGFloat absCenterX = cropFrame.origin.x + cropFrame.size.width / 2;
        CGFloat absCenterY = cropFrame.origin.y + cropFrame.size.height / 2;
        CGFloat scaleRatio = view.frame.size.width / cropFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // bounce to original frame
        CGRect newFrame = view.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:0.3 animations:^{
            self.editImageView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}


- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
   
   
    
    if (newFrame.size.width < self.oldFrame.size.width) {
        newFrame = self.oldFrame;
    }
    
    if (newFrame.size.width > self.largeFrame.size.width) {
        newFrame = self.largeFrame;
    }
    
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}


- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    
    CGRect cropFrame = cropRect;
    
    
    if (newFrame.origin.x > 0) newFrame.origin.x = 0;
    
    if (CGRectGetMaxX(newFrame) < cropFrame.size.width) newFrame.origin.x = cropFrame.size.width - newFrame.size.width;
    
    
    
    if (newFrame.origin.y > cropFrame.origin.y) newFrame.origin.y = cropFrame.origin.y;
    
    if (CGRectGetMaxY(newFrame) < cropFrame.origin.y + cropFrame.size.height) {
        newFrame.origin.y = cropFrame.origin.y + cropFrame.size.height - newFrame.size.height;
    }
    
    
    
    if (self.editImageView.frame.size.width > self.editImageView.frame.size.height && newFrame.size.height <= cropFrame.size.height) {
        
        newFrame.origin.y = cropFrame.origin.y + (cropFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}


-(UIImage *)getSubImage{
    
    
    CGRect squareFrame = cropRect;
    
    
    CGFloat scaleRatio = self.latestFrame.size.width / self.editImage.size.width;
    
    CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.height / scaleRatio;
    

    if (self.latestFrame.size.width < squareFrame.size.width) {
        CGFloat newW = self.editImage.size.width;
        CGFloat newH = newW * (squareFrame.size.height / squareFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = self.editImage.size.width; h = self.editImage.size.height;
    }

    if (self.latestFrame.size.height < squareFrame.size.height) {
        
        CGFloat newH = self.editImage.size.height;
        CGFloat newW = newH * (squareFrame.size.width / squareFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = self.editImage.size.width; h = self.editImage.size.height;
    }
    
    CGRect myImageRect = CGRectMake(x, y, w, h);
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.editImage.CGImage, myImageRect);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];

    return smallImage;
}

+ (UIImage *)fixOrientation:(UIImage *)srcImg {
    
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
