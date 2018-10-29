//
//  CustomActionSheet.m
//  LZWCustomActionSheet
//
//  Created by hbh  on 14-9-26.
//  Copyright (c) 2014年 lizhiwei. All rights reserved.
//

#import "CustomActionSheet.h"
#import "CommonMethod.h"

#define WINDOW_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION                        0.25f
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:212.0/255.00f green:212.0/255.00f blue:212.0/255.00f alpha:1.0]



@implementation CustomActionSheet

-(id)initWithView:(UIView *)view AndHeight:(float)height{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        //生成LZWActionSheetView
        self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - height), view.frame.size.width, height)];
        self.backGroundView.backgroundColor = [UIColor whiteColor];
        
        
        UIView *toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 41)];
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 40)];
        [backImageView setImage:[UIImage imageNamed:@"BackgroundImg.png"]];
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton addTarget:self
                       action:@selector(docancel)
             forControlEvents:UIControlEventTouchUpInside];
        [leftButton setFrame:CGRectMake(0, 0, 50, 40)];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [leftButton setTitleColor:YCButtonColorGreen
                          forState:UIControlStateNormal];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setFrame:CGRectMake(view.frame.size.width-50, 0, 50, 44)];
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [rightButton setTitleColor:YCButtonColorGreen
                              forState:UIControlStateNormal];
        
        [toolBarView addSubview:backImageView];
        [toolBarView addSubview:leftButton];
        [toolBarView addSubview:rightButton];
        
        
        //给LZWActionSheetView添加响应事件(如果不加响应事件则传过来的view不显示)
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
        [self.backGroundView addGestureRecognizer:tapGesture1];
        
        
        [self addSubview:self.backGroundView];
        
        [self.backGroundView addSubview:toolBarView];
        [self.backGroundView addSubview:view];
        
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-height, [UIScreen mainScreen].bounds.size.width, height)];
            
        } completion:^(BOOL finished) {
            
        }];


    }
    
    return self;
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];

    ///视图消失后在具体页面的处理
    if (self.doneDelegate && [self.doneDelegate respondsToSelector:@selector(haveHidden)]) {
        [self.doneDelegate haveHidden];
    }
}

-(void)showInView:(UIView *)view{
    
    [view addSubview:self];
    
}

- (void)tappedBackGroundView
{
    
}

-(void)done{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.doneDelegate doneSelectItemMethod];
        if (_indexPath) {
            [self.doneDelegate doneSelectItemMethod:_indexPath];
        }
    });
    [self tappedCancel];
}

-(void)docancel
{
    [self tappedCancel];
}


@end
