//
//  JMPhotoBrowser.m
//  PanKeTong
//
//  Created by Admin on 2018/4/13.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMPhotoBrowser.h"
#import <Photos/Photos.h>
#import "XLZoomingScrollView.h"
#import <SDWebImage/SDWebImageManager.h>
@interface JMPhotoBrowser ()<XLPhotoBrowserDatasource>
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorV;

@end

@implementation JMPhotoBrowser

+ (instancetype)showPhotoBrowserWithImages:(NSArray *)images currentImageIndex:(NSInteger)currentImageIndex
{
    if (images.count <=0 || images ==nil) {
        NSLog(@"一行代码展示图片浏览的方法,传入的数据源为空,请检查传入数据源");
        return nil;
    }
    
    //检查数据源对象是否非法
    for (id image in images) {
        if (![image isKindOfClass:[UIImage class]] && ![image isKindOfClass:[NSString class]] && ![image isKindOfClass:[NSURL class]] && ![image isKindOfClass:[ALAsset class]]) {
            NSLog(@"识别到非法数据格式,请检查传入数据是否为 NSString/NSURL/ALAsset 中一种");
            return nil;
        }
    }
    

    JMPhotoBrowser *browser = [[JMPhotoBrowser alloc] init];
    browser.imageCount = images.count;
    browser.currentImageIndex = currentImageIndex;
    [browser setValue:images forKeyPath:@"images"];
    browser.placeholderImage = [UIImage imageNamed:@"defaultPropBig_bg"];
    browser.pageControlStyle = 3;
    browser.datasource = browser;
    browser.label = [[UILabel alloc] initWithFrame:CGRectMake(0, APP_SCREENSafeAreaHeight-60, APP_SCREEN_WIDTH, 40)];
    browser.label.textAlignment = 1;
    browser.label.textColor = [UIColor whiteColor];
    
    
    browser.btn = [[UIButton alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH-115, APP_SCREENSafeAreaHeight-80, 100, 80)];
    [browser.btn setImage:[UIImage imageNamed:@"down_icon"] forState:UIControlStateNormal];
    browser.btn.contentHorizontalAlignment = 2;
    [browser.btn addTarget:browser action:@selector(saveImageClick) forControlEvents:UIControlEventTouchUpInside];
    
    [browser show];
    
    
    
    browser.window.windowLevel = UIWindowLevelStatusBar;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [browser addSubview:browser.label];
    [browser addSubview:browser.btn];
    [[NSNotificationCenter defaultCenter] removeObserver:browser name:UIDeviceOrientationDidChangeNotification object:nil];
    
    return browser;
}

//- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
//    
//    
//    NSArray* array =  [browser valueForKeyPath:@"images"];
//    NSURL *imageurl = array[index];
//    NSString *imageP = imageurl.absoluteString;
//    
//    if ([imageP containsString:@"?"]) {
//        
//        imageP = [imageP substringToIndex:[imageP rangeOfString:@"?"].location];
//    }
//    
//    NSString *imagePath = [NSString stringWithFormat:@"%@%@",imageP,PhotoWidth];
//    
//    return [NSURL URLWithString:imagePath];
//}



- (void)saveImageClick {
    
    NSURL *url = [self valueForKey:@"images"][self.currentImageIndex];
    NSString *imagePath = url.absoluteString;
    if ([imagePath containsString:@"?"]) {
        
        imagePath = [[imagePath substringToIndex:[imagePath rangeOfString:@"?"].location] stringByAppendingString:PhotoWidth];
    }
    NSURL *imageUrl = [NSURL URLWithString:imagePath];
    
    
    
    [self addSubview:self.indicatorV];
    [self.indicatorV startAnimating];
    
    
    
    [[SDWebImageManager sharedManager] loadImageWithURL:imageUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        if (image) UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        
    }];
    
//    [[SDWebImageManager sharedManager]  diskImageExistsForURL:imageUrl completion:^(BOOL isInCache) {
//
//
//        if (isInCache) {
//
//            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageUrl];
//
//            UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:key];
//
//            if (image) UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//
//        }else{
//
//
//
//        }
//
//
//
//
//    }];
//     [self saveCurrentShowImage];
    

}

- (UIActivityIndicatorView *)indicatorV {
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc] init];
        _indicatorV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _indicatorV.center = self.center;
    }
    return _indicatorV;
    
}




//- (void)zoomingScrollView:(XLZoomingScrollView *)zoomingScrollView imageLoadProgress:(CGFloat)progress{

//    NSLog(@"我是啊啊啊啊:%@--->%f---%f--->%ld",zoomingScrollView,progress,zoomingScrollView.progress,zoomingScrollView.tag);

//    _zoomingView = zoomingScrollView;
//}



- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    
    
    [self.indicatorV removeFromSuperview];

    if (error) {
     
        showJDStatusStyleErrorMsg(@"保存图片失败");
    } else {
        showJDStatusStyleSuccMsg(@"保存图片成功");
    }
    
}

- (void)setCurrentImageIndex:(NSInteger)currentImageIndex {

    [self setValue:@(currentImageIndex) forKey:@"_currentImageIndex"];
    
     self.label.text = [NSString stringWithFormat:@"%ld/%ld",currentImageIndex+1,self.imageCount];
}
//- (UIAlertController *)presentAlterVCWithString:(NSString*)string {
//    
//    NSString *title = [string stringByAppendingString:@"未授权"];
//    NSString *message = [NSString stringWithFormat:@"请前往设置，打开原萃的%@权限后继续使用",string];
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//    
//    
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
//        
//        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        if ([[UIApplication sharedApplication] canOpenURL:url])
//        {
//            [[UIApplication sharedApplication] openURL:url];
//        }
//        
//        
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:1 handler:nil]];
//    
//    return alert;
//}


@end
