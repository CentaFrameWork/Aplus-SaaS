//
//  BRImageScrollView.h
//  LianDong
//
//  Created by 阎超杰 on 13-10-24.
//  Copyright (c) 2013年 Grant Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
NSString * BRPathForBundleResource(NSString *relativePath);
UIImage  * BRLoadImageFromBundle(NSString *imageName);

typedef void (^BRIamgeViewerOpeningBlock)(void);
typedef void (^BRIamgeViewerClosingBlock)(void);

@protocol BRImageScrollViewDelegate ;
@interface BRImageScrollView : UIView<UIScrollViewDelegate>{

    UIScrollView    *_scrollView;
   
    NSUInteger      _startWithIndex;
    NSInteger       _currentIndex;
    NSInteger       _photoCount;
    NSMutableArray  *_photoViews;
    NSInteger       _firstVisiblePageIndexBeforeRotation;
    CGFloat         _percentScrolledIntoFirstVisiblePage;
    
    BOOL _statusbarHidden;
    BOOL _isChromeHidden;
    BOOL _rotationInProgress;
    BOOL _viewDidAppearOnce;
    BOOL _navbarWasTranslucent;

    NSTimer *_chromeHideTimer;
}

@property (nonatomic, weak)  IBOutlet id <BRImageScrollViewDelegate> delegate;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign, getter=isStatusbarHidden) BOOL statusbarHidden;
@property (nonatomic, weak) BRIamgeViewerOpeningBlock openingBlock;
@property (nonatomic, weak) BRIamgeViewerClosingBlock closingBlock;

- (void)toggleChromeDisplay;
- (void)scrollToIndex:(NSInteger)index;
- (void)setCurrentIndex:(NSInteger)newIndex;
- (void)exeSingleTapView;
- (void)reloadData;

@end

@interface BRIamgeViewItem : UIScrollView <UIScrollViewDelegate>{

    UIImageView       *_mImageView;
    NSInteger         index_;
    
}

@property (nonatomic, weak) BRImageScrollView *mScrollView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImageView  *mImageView;
//@property (nonatomic, strong) JMProgress *progressView;

- (void)setImage:(UIImage *)newImage;
- (void)turnOffZoom;
- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;
- (void)setProgress:(CGFloat)progress;

@end

@protocol BRImageScrollViewDelegate <NSObject>

@required
- (NSInteger)numberOfPhotos;

@optional
// Implement either these, for synchronous images…
- (UIImage *)imageAtIndex:(NSInteger)index;
- (UIImage *)thumbImageAtIndex:(NSInteger)index;
// …or these, for asynchronous images.
- (void)imageAtIndex:(NSInteger)index photoView:(BRIamgeViewItem *)photoView;
- (void)thumbImageAtIndex:(NSInteger)index thumbView:(BRIamgeViewItem *)thumbView;
- (void)imageAtCurrentIndex:(NSInteger)index photoView:(BRIamgeViewItem *)thumbView;
- (void)deleteImageAtIndex:(NSInteger)index;
- (void)exportImageAtIndex:(NSInteger)index;
- (void)tapImageViewAtIndex:(NSInteger)index;
- (CGSize)thumbSize;
- (NSInteger)thumbsPerRow;
- (BOOL)thumbsHaveBorder;
- (UIColor *)imageBackgroundColor;

@end

@interface BRTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, assign) NSInteger index;

@end
