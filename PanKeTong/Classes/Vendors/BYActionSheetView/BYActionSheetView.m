//
//  BYActionSheetView.m
//  LianDong
//
//  Created by 阎超杰 on 14-2-28.
//  Copyright (c) 2014年 Grant Yuan. All rights reserved.
//

#import "BYActionSheetView.h"
#import "UIImage+Cap.h"
#define BY_ScreenFrame   [UIScreen mainScreen].applicationFrame
#define BY_ScreenBounds  [UIScreen mainScreen].bounds
#define BY_ButtonHeight  46.0f

@interface BYActionSheetView(){

    UIWindow *_mainWindow;
    UIControl*_backgroundView;
    UIView   *_contentView;
    NSUInteger buttonTag;
    NSUInteger buttonNum;
    CGFloat    customHeight;
    
    NSUInteger _initialTag;
}


@end

@implementation BYActionSheetView

- (id)initWithTitle:(NSString *)title delegate:(id<BYActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle  otherButtonTitles:(NSString *)otherButtonTitle, ...{

    self = [super  initWithFrame:BY_ScreenBounds];
    if(self){
        customHeight = 0.0f;
        self.backgroundColor = [UIColor clearColor];
        _mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_mainWindow makeKeyAndVisible];
        _backgroundView = [[UIControl alloc] initWithFrame:BY_ScreenBounds];
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];
        _backgroundView.backgroundColor = [UIColor colorWithHue:0/255.0f saturation:0/255.0f brightness:0/255.0f alpha:0.75f];
        _backgroundView.alpha = 0.0f;
        [_backgroundView addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundView];
        [self addSubview:_contentView];
        
        _delegate = delegate;
        buttonTag = 90000;
        buttonNum = 0;
        _initialTag = 9000;
        
        if (title != nil) {
            [self buildItemButtonWithTitle:title withTitleColor:[UIColor darkTextColor]];
        }
        
        va_list  arguments;
        va_start(arguments, otherButtonTitle);
        if (otherButtonTitle) {
            [self buildItemButtonWithTitle:otherButtonTitle withTitleColor:[UIColor  darkTextColor]];
            NSString *otherString ;
            while ((otherString = va_arg(arguments , NSString *))) {
                [self buildItemButtonWithTitle:otherString withTitleColor:[UIColor  darkTextColor]];
            }
        }
        va_end(arguments);
        
        if (cancelButtonTitle != nil) {
           [self buildItemButtonWithTitle:cancelButtonTitle withTitleColor:[UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f]];
        }
        
        _backgroundView.tag = buttonTag;
    }
    
    return self;
}

- (id)initWithCustomeView:(UIView *)aCustomeView
                 delegate:(id<BYActionSheetViewDelegate>)delegate
        cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitles:(NSString *)otherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION{

    self = [super  initWithFrame:BY_ScreenBounds];
    if(self){
        customHeight = 0.0 ;
        self.backgroundColor = [UIColor clearColor];
        _mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_mainWindow makeKeyAndVisible];
        _backgroundView = [[UIControl alloc] initWithFrame:BY_ScreenBounds];
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];
        _backgroundView.backgroundColor = [UIColor colorWithHue:0/255.0f saturation:0/255.0f brightness:0/255.0f alpha:0.75f];
        _backgroundView.alpha = 0.0f;
        [_backgroundView addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundView];
        [self addSubview:_contentView];
        
        _delegate = delegate;
        buttonTag = 90000;
        buttonNum = 0;
        
        if (aCustomeView != nil) {
            [self buildItemButtonWithView:aCustomeView];
        }
        va_list  arguments;
        va_start(arguments, otherButtonTitle);
        if (otherButtonTitle) {
            [self customItemButtonWithTitle:otherButtonTitle withTitleColor:[UIColor  darkTextColor]];
            NSString *otherString ;
            while ((otherString = va_arg(arguments , NSString *))) {
                [self customItemButtonWithTitle:otherString withTitleColor:[UIColor  darkTextColor]];
                
            }
        }
        va_end(arguments);
        
        if (cancelButtonTitle != nil) {
            [self customItemButtonWithTitle:cancelButtonTitle withTitleColor:[UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f]];
        }
        
        _backgroundView.tag = buttonTag;
        customHeight = customHeight - BY_ButtonHeight;
    }

    return self;
}

- (void)show{

    [_mainWindow addSubview:self];
    _contentView.frame = CGRectMake(0,BY_ScreenBounds.size.height, BY_ScreenBounds.size.width, buttonNum * BY_ButtonHeight + customHeight);
    [self animationShow];
}

#pragma mark- commons
- (void)animationShow{
    
    __weak UIView *weakBackgroundView = _backgroundView;
    __weak UIView *weakContentView = _contentView;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         weakBackgroundView.alpha = 1.0f;
                         weakContentView.frame = CGRectMake(0,BY_ScreenBounds.size.height - buttonNum * BY_ButtonHeight - BOTTOM_SAFE_HEIGHT,BY_ScreenBounds.size.width, buttonNum * BY_ButtonHeight + customHeight);
                     }
                     completion:^(BOOL finished) {
                         
                     }];

}

- (void)animationHiddenWithIndex:(NSUInteger)index andButtonTitle:(NSString *)buttonTitle
{
    __weak typeof (self) weakSelf = self;
    __weak UIView *weakBackgroundView = _backgroundView;
    __weak UIView *weakContentView = _contentView;
    __weak UIWindow *weakMainWindow = _mainWindow;
    [UIView animateWithDuration:0.3f
                     animations:^{
                        
                         weakBackgroundView.alpha = 0.0f;
                         weakContentView.frame = CGRectMake(0,BY_ScreenBounds.size.height,BY_ScreenBounds.size.width, buttonNum * BY_ButtonHeight + customHeight);
                     }
                     completion:^(BOOL finished) {
                         [weakMainWindow removeFromSuperview];
                         [weakSelf removeFromSuperview];
                         if (_delegate && [_delegate respondsToSelector:@selector(actionSheetView:clickedButtonAtIndex:andButtonTitle:)]){
                             [_delegate actionSheetView:self clickedButtonAtIndex:index andButtonTitle:buttonTitle];
                         }
                     }];
}

- (void)buildItemButtonWithTitle:(NSString *)title withTitleColor:(UIColor *)color{

    buttonTag ++;
    buttonNum ++;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = buttonTag;
    button.frame = CGRectMake(0,(buttonNum - 1) * BY_ButtonHeight, BY_ScreenBounds.size.width, BY_ButtonHeight);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    if (buttonNum == 1) {
        [button setBackgroundImage:[UIImage imageNamed:@"actionsheet_head_normal"] forState:UIControlStateNormal];
       // [button setBackgroundImage:[UIImage imageNamed:@"actionsheet_head_selected"] forState:UIControlStateHighlighted];
       // [button setBackgroundImage:[UIImage imageNamed:@"actionsheet_head_selected"] forState:UIControlStateSelected];
//         button.userInteractionEnabled = NO;
        _TitleBtn = button;
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"actionsheet_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"actionsheet_selected"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"actionsheet_selected"] forState:UIControlStateSelected];
    }
    
    [button addTarget:self action:@selector(currentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
}


- (void)initialValue:(NSString *)initialVale
{
    NSInteger num = buttonTag ;
    
    for (int i = 90001; i <= num; i++)
    {
        UIButton *button = [_contentView viewWithTag:i];
                
        if ([button.titleLabel.text isEqualToString:initialVale])
        {
            [button setTitleColor:ORANGE_COLOR forState:UIControlStateNormal];
        }
        
    }
}


#pragma mark- CommonsCustomView
- (void)buildItemButtonWithView:(UIView *)aView{

    buttonTag ++;
    buttonNum ++;
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, BY_ScreenBounds.size.width, aView.frame.size.height + 2)];
    bgImageView.tag = buttonTag;
  
    if (buttonNum == 1) {
        [bgImageView setImage:[UIImage imageNamed:@"actionsheet_head_normal" withCapInsets:UIEdgeInsetsMake(4, 1, 1, 1)] ];
         
         }else {
             
         [bgImageView setImage:[UIImage imageNamed:@"actionsheet_normal" withCapInsets:UIEdgeInsetsMake(4, 1, 1, 1)] ];
        
    }
    aView.frame = CGRectMake(0, 2, aView.frame.size.width, aView.frame.size.height);
    [bgImageView addSubview:aView];
    [_contentView addSubview:bgImageView];
    customHeight = bgImageView.frame.origin.y + bgImageView.frame.size.height;
}

- (void)customItemButtonWithTitle:(NSString *)title withTitleColor:(UIColor *)color{
    
    buttonTag ++;
    buttonNum ++;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = buttonTag;
    button.frame = CGRectMake(0,(buttonNum - 2) * BY_ButtonHeight + customHeight, BY_ScreenBounds.size.width, BY_ButtonHeight);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [button setBackgroundImage:[UIImage imageNamed:@"actionsheet_normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"actionsheet_selected"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"actionsheet_selected"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(currentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
}


#pragma mark- actions
- (void)currentButtonPressed:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    NSUInteger index = button.tag - 90001;
    [self animationHiddenWithIndex:index andButtonTitle:button.titleLabel.text];
    
    UIWindow *baseWindow = [[UIApplication sharedApplication].delegate window];
    
    [baseWindow makeKeyAndVisible];
}

- (void)cancelButtonPressed:(id)sender{
    
    __weak typeof (self) weakSelf = self;
    __weak UIView *weakBackgroundView = _backgroundView;
    __weak UIView *weakContentView = _contentView;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         weakBackgroundView.alpha = 0.0f;
                         weakContentView.frame = CGRectMake(0,BY_ScreenBounds.size.height,BY_ScreenBounds.size.width, buttonNum * BY_ButtonHeight + customHeight);
                     }
                     completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                         if (_delegate &&
                             [_delegate respondsToSelector:@selector(actionSheetView:clickedButtonAtIndex:andButtonTitle:)]){
                             
                             [_delegate actionSheetView:self
                                   clickedButtonAtIndex:-1
                                    andButtonTitle:@""];
                             
                             UIWindow *baseWindow = [[UIApplication sharedApplication].delegate window];
                             
                             [baseWindow makeKeyAndVisible];
                         }
                     }];

}

@end
