//
//  MoviePlayerVC.m
//  PanKeTong
//
//  Created by 张旺 on 2017/12/13.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "MoviePlayerVC.h"
#import "CLPlayerView.h"

@interface MoviePlayerVC ()

@property (nonatomic,strong) CLPlayerView *playerView;

@end

@implementation MoviePlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    
    WS(weakSelf);
    [self.playerView backButton:^(UIButton *button) {
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.playerView.url = [NSURL URLWithString:_videoUrl];// @"http://lihqceshi.oss-cn-hangzhou.aliyuncs.com/ceshiPlay?Expires=1512640636&OSSAccessKeyId=LTAIOJQn7ab5VRVX&Signature=pZgj%2B7bwmOqWzG7LvuH74MaQGOg%3D";
    
    [self.view addSubview:self.playerView];
    
    //播放
    [self.playerView playVideo];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.playerView pausePlay];
    [self.playerView destroyPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

@end
