//
//  BRImageScrollView.m
//  LianDong
//
//  Created by 阎超杰 on 13-10-24.
//  Copyright (c) 2013年 Grant Yuan. All rights reserved.
//

#import "BRImageScrollView.h"
#import <QuartzCore/QuartzCore.h>

NSString * BRPathForBundleResource(NSString *relativePath) {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}

UIImage * BRLoadImageFromBundle(NSString *imageName) {
    NSString *relativePath = [NSString stringWithFormat:@"KTPhotoBrowser.bundle/images/%@", imageName];
    NSString *path  = BRPathForBundleResource(relativePath);
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:data];
}

const CGFloat ktkDefaultPortraitToolbarHeight   = 44;
const CGFloat ktkDefaultLandscapeToolbarHeight  = 33;
const CGFloat ktkDefaultToolbarHeight = 44;

#define BUTTON_DELETEPHOTO 0
#define BUTTON_CANCEL 1

@interface BRImageScrollView()

- (void)toggleChrome:(BOOL)hide;
- (void)startChromeDisplayTimer;
- (void)cancelChromeDisplayTimer;
- (void)hideChrome;
- (void)showChrome;
- (void)nextPhoto;
- (void)previousPhoto;
- (void)toggleNavButtons;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (void)loadPhoto:(NSInteger)index;
- (void)unloadPhoto:(NSInteger)index;
- (void)trashPhoto;
- (void)exportPhoto;

@end

@implementation BRImageScrollView

- (void)dealloc{
    
    _scrollView = nil;
    [_chromeHideTimer invalidate];
    _chromeHideTimer = nil;
    _photoViews = nil;
    _delegate = nil;
    
}

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)setDelegate:(id<BRImageScrollViewDelegate>)aDelegate{

    _delegate = aDelegate;
    
    if ([_delegate respondsToSelector:@selector(deleteImageAtIndex:)]) {
        // do sth
    }
    
    if ([_delegate respondsToSelector:@selector(exportImageAtIndex:)])
    {
        // do sth
    }
    _photoCount = [_delegate numberOfPhotos];
    [self setScrollViewContentSize];
    // Setup our photo view cache. We only keep 3 views in
    // memory. NSNull is used as a placeholder for the other
    // elements in the view cache array.
    _photoViews = [[NSMutableArray alloc] initWithCapacity:_photoCount];
    for (NSInteger i = 0; i < _photoCount; i++) {
        [_photoViews addObject:[NSNull null]];
    }
    
    // Set the scroll view's content size, auto-scroll to the stating photo,
    // and setup the other display elements.
    [self setScrollViewContentSize];
    [self setCurrentIndex:_startWithIndex];
    [self scrollToIndex:_startWithIndex];
    
    [self setTitleWithCurrentPhotoIndex];
    [self toggleNavButtons];
    [self layoutSubviews];
    
}

-(void)awakeFromNib{

    [super awakeFromNib];
    CGRect scrollFrame = [self frameForPagingScrollView];
    UIScrollView *newView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    [newView setDelegate:self];
    
    UIColor *backgroundColor = [_delegate respondsToSelector:@selector(imageBackgroundColor)] ?
    [_delegate imageBackgroundColor] : [UIColor blackColor];
    [newView setBackgroundColor:backgroundColor];
    [newView setAutoresizesSubviews:NO];
    [newView setPagingEnabled:YES];
    [newView setShowsVerticalScrollIndicator:NO];
    [newView setShowsHorizontalScrollIndicator:NO];
    [newView setBounces:YES];
    [newView setBouncesZoom:YES];
    
    [self addSubview:newView];
    _scrollView = newView;
  
}

- (void)setTitleWithCurrentPhotoIndex{
 
}

- (void)reloadData{

    for (UIView *itemView in [_scrollView subviews]) {
        [itemView removeFromSuperview];
    }
}

- (void)scrollToIndex:(NSInteger)index{
    
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:NO];
}

- (void)setScrollViewContentSize{
    
    NSInteger pageCount = _photoCount;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(_scrollView.frame.size.width * pageCount,
                             _scrollView.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    [_scrollView setContentSize:size];
}

- (void)deleteCurrentPhoto{
    
    if (_delegate) {
        // TODO: Animate the deletion of the current photo.
        
        NSInteger photoIndexToDelete = _currentIndex;
        [self unloadPhoto:photoIndexToDelete];
        [_delegate deleteImageAtIndex:photoIndexToDelete];
        
        _photoCount -= 1;
        if (_photoCount == 0) {
            [self showChrome];
            // 没有数据的时候 do sth
        } else {
            NSInteger nextIndex = photoIndexToDelete;
            if (nextIndex == _photoCount) {
                nextIndex -= 1;
            }
            [self setCurrentIndex:nextIndex];
            [self setScrollViewContentSize];
        }
    }
}

- (void)toggleNavButtons{
 
}

#pragma mark -
#pragma mark Frame calculations
#define PADDING  0

- (CGRect)frameForPagingScrollView{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    frame.size.height -= 64;
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index{
    
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = [_scrollView bounds];
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

#pragma mark -
#pragma mark Photo (Page) Management
- (void)loadPhoto:(NSInteger)index{
    
    if (index < 0 || index >= _photoCount) {
        return;
    }
    
    id currentPhotoView = [_photoViews objectAtIndex:index];
    if (NO == [currentPhotoView isKindOfClass:[BRIamgeViewItem class]]) {
        // Load the photo view.
        CGRect frame = [self frameForPageAtIndex:index];
        BRIamgeViewItem *photoView = [[BRIamgeViewItem alloc] initWithFrame:frame];
        [photoView setMScrollView:self];
        [photoView setIndex:index];
        [photoView setBackgroundColor:[UIColor clearColor]];
        
        // Set the photo image.
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(imageAtIndex:photoView:)] == NO) {
                UIImage *image = [_delegate imageAtIndex:index];
                [photoView setImage:image];
            } else {
                [_delegate imageAtIndex:index photoView:photoView];
            }
        }
        
        [_scrollView addSubview:photoView];
        [_photoViews replaceObjectAtIndex:index withObject:photoView];
        
    } else {
        // Turn off zooming.
        [currentPhotoView turnOffZoom];
    }
}

- (void)unloadPhoto:(NSInteger)index{
    
    if (index < 0 || index >= _photoCount) {
        return;
    }
    
    id currentPhotoView = [_photoViews objectAtIndex:index];
    if ([currentPhotoView isKindOfClass:[BRIamgeViewItem class]]) {
        [currentPhotoView removeFromSuperview];
        [_photoViews replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

- (void)exeSingleTapView{

    if (_delegate && [_delegate respondsToSelector:@selector(tapImageViewAtIndex:)]) {
        [_delegate tapImageViewAtIndex:_currentIndex];
    }
}

- (void)setCurrentIndex:(NSInteger)newIndex{
    
    _currentIndex = newIndex;
    
    [self loadPhoto:_currentIndex];
    [self loadPhoto:_currentIndex + 1];
    [self loadPhoto:_currentIndex - 1];
    [self unloadPhoto:_currentIndex + 2];
    [self unloadPhoto:_currentIndex - 2];
    
    [self setTitleWithCurrentPhotoIndex];
    [self toggleNavButtons];
    if (_delegate && [_delegate respondsToSelector:@selector(imageAtCurrentIndex:photoView:)]) {
        if (newIndex >= [_photoViews count] || newIndex < 0) {
            return;
        }
        id currentPhotoView = [_photoViews objectAtIndex:newIndex];
        [_delegate imageAtCurrentIndex:_currentIndex photoView:currentPhotoView];
    }
}


#pragma mark -
#pragma mark Rotation Magic

- (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation{
 
}

- (void)layoutScrollViewSubviews{
    
    [self setScrollViewContentSize];
    NSArray *subviews = [_scrollView subviews];
    
    for (BRIamgeViewItem *item in subviews) {
        CGPoint restorePoint = [item pointToCenterAfterRotation];
        CGFloat restoreScale = [item scaleToRestoreAfterRotation];
        [item setFrame:[self frameForPageAtIndex:[item index]]];
        [item setMaxMinZoomScalesForCurrentBounds];
        [item restoreCenterPoint:restorePoint scale:restoreScale];
    }
    
    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = _scrollView.bounds.size.width;
    CGFloat newOffset = (_firstVisiblePageIndexBeforeRotation * pageWidth) + (_percentScrolledIntoFirstVisiblePage * pageWidth);
    _scrollView.contentOffset = CGPointMake(newOffset, 0);
    
}

#pragma mark -
#pragma mark Chrome Helpers

- (void)toggleChromeDisplay{
    [self toggleChrome:!_isChromeHidden];
}

- (void)toggleChrome:(BOOL)hide{
    _isChromeHidden = hide;
    if (hide) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
    }
    
    /*
    if ( ! [self isStatusbarHidden] ) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
            [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:NO];
        } else {  // Deprecated in iOS 3.2+.
            id sharedApp = [UIApplication sharedApplication];  // Get around deprecation warnings.
            [sharedApp setStatusBarHidden:hide animated:NO];
        }
    }
    */
    
    if (hide) {
        [UIView commitAnimations];
    }
    
    if ( ! _isChromeHidden ) {
        [self startChromeDisplayTimer];
    }
}

- (void)hideChrome{
    
    if (_chromeHideTimer && [_chromeHideTimer isValid]) {
        [_chromeHideTimer invalidate];
        _chromeHideTimer = nil;
    }
    [self toggleChrome:YES];
}

- (void)showChrome{
    
    [self toggleChrome:NO];
    
}

- (void)startChromeDisplayTimer{
    
    [self cancelChromeDisplayTimer];
    _chromeHideTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                        target:self
                                                      selector:@selector(hideChrome)
                                                      userInfo:nil
                                                       repeats:NO];
}

- (void)cancelChromeDisplayTimer{
    
    if (_chromeHideTimer) {
        [_chromeHideTimer invalidate];
        _chromeHideTimer = nil;
    }
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = floor(fractionalPage);
	if (page != _currentIndex) {
		[self setCurrentIndex:page];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self hideChrome];
    
}


#pragma mark -
#pragma mark Toolbar Actions

- (void)nextPhoto{
    
    [self scrollToIndex:_currentIndex + 1];
    [self startChromeDisplayTimer];
    
}

- (void)previousPhoto{
    
    [self scrollToIndex:_currentIndex - 1];
    [self startChromeDisplayTimer];
}

- (void)trashPhoto
{
  
}

- (void) exportPhoto
{
    if ([_delegate respondsToSelector:@selector(exportImageAtIndex:)])
        [_delegate exportImageAtIndex:_currentIndex];
    
    [self startChromeDisplayTimer];
}



@end

@interface BRIamgeViewItem (){
    
}
- (void)loadSubviewsWithFrame:(CGRect)frame;
- (BOOL)isZoomed;
- (void)toggleChromeDisplay;


- (void)addMultipleGesture;
- (void)didTwoFingerTap:(UIGestureRecognizer *)aGestureRecognizer;
- (void)didSingleTap:(UIGestureRecognizer *)aGestureRecognizer;
- (void)didDobleTap:(UIGestureRecognizer *)aGestureRecognizer;


@end
@implementation BRIamgeViewItem
@synthesize mImageView = _mImageView;
- (void)dealloc{
    
    _mImageView = nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:self];
        [self setMaximumZoomScale:3.0];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self loadSubviewsWithFrame:frame];
        [self addMultipleGesture];
    }
    return self;
}

- (void)loadSubviewsWithFrame:(CGRect)frame
{
    _mImageView = [[UIImageView alloc] initWithFrame:frame];
    _mImageView.userInteractionEnabled = YES;
    [_mImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_mImageView];
    

}

- (void)setImage:(UIImage *)newImage
{
    [_mImageView setImage:newImage];
 
}
- (void)addMultipleGesture{

    UITapGestureRecognizer *twoFingerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTwoFingerTap:)];
    twoFingerTapGesture.numberOfTapsRequired = 1;
    twoFingerTapGesture.numberOfTouchesRequired = 2;
    [self addGestureRecognizer:twoFingerTapGesture];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTapRecognizer];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDobleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTapRecognizer];
    
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
}

- (void)didTwoFingerTap:(UIGestureRecognizer *)aGestureRecognizer{

    CGFloat newZoomScale = self.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.minimumZoomScale);
    [self setZoomScale:newZoomScale animated:YES];
}

- (void)didSingleTap:(UIGestureRecognizer *)aGestureRecognizer{

    if (self.mScrollView) {
        [self.mScrollView exeSingleTapView];
    }
}

- (void)didDobleTap:(UIGestureRecognizer *)aGestureRecognizer{

    CGPoint pointInView = [aGestureRecognizer locationInView:self];
    [self zoomToLocation:pointInView];

}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if ([self isZoomed] == NO && CGRectEqualToRect([self bounds], [_mImageView frame]) == NO) {
        [_mImageView setFrame:[self bounds]];
    }
}

- (void)toggleChromeDisplay{
    
    if (_mScrollView) {
        [_mScrollView toggleChromeDisplay];
    }
}

- (BOOL)isZoomed{
    
    return !([self zoomScale] == [self minimumZoomScale]);
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center{
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)zoomToLocation:(CGPoint)location{
    
    CGFloat newScale;
    CGRect zoomRect;
    if ([self isZoomed]) {
        zoomRect = [self bounds];
    } else {
        newScale = [self maximumZoomScale];
        zoomRect = [self zoomRectForScale:newScale withCenter:location];
    }
    
    [self zoomToRect:zoomRect animated:YES];
}

- (void)turnOffZoom{
    
    if ([self isZoomed]) {
        [self zoomToLocation:CGPointZero];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self) {
        if ([touch tapCount] == 2) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggleChromeDisplay) object:nil];
            [self zoomToLocation:[touch locationInView:self]];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if ([touch view] == self) {
        if ([touch tapCount] == 1) {
            [self performSelector:@selector(toggleChromeDisplay) withObject:nil afterDelay:0.5];
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *viewToZoom = _mImageView;
    return viewToZoom;
}

#pragma mark -
#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image
- (void)setMaxMinZoomScalesForCurrentBounds{
    
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _mImageView.bounds.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

// returns the center point, in image coordinate space, to try to restore after rotation.
- (CGPoint)pointToCenterAfterRotation{
    
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return [self convertPoint:boundsCenter toView:_mImageView];
}

// returns the zoom scale to attempt to restore after rotation.
- (CGFloat)scaleToRestoreAfterRotation{
    
    CGFloat contentScale = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (contentScale <= self.minimumZoomScale + FLT_EPSILON)
        contentScale = 0;
    
    return contentScale;
}

- (CGPoint)maximumContentOffset{
    
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset{
    return CGPointZero;
}

// Adjusts content offset and scale to try to preserve the old zoomscale and center.
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale{
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:_mImageView];
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
    self.contentOffset = offset;
}




@end

@implementation BRTapGestureRecognizer

@end
