//
//  CustomServiceViewController.m
//  PanKeTong
//
//  Created by TailC on 16/3/30.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CustomServiceViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>


#pragma mark static define
static NSInteger const tabCount = 4;
static NSInteger const tabHeight = 70;

@interface CustomServiceViewController ()<UIScrollViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


@property (strong,nonatomic) UIWebView *webView;
@property (strong,nonatomic) JSContext *context;

@property (assign,nonatomic) float currentArrowX;

@end

@implementation CustomServiceViewController

#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	[self setupView];
	[self setupScrollView];
	[self setupWebView];
	
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark setup
-(void)setupData{
	self.currentArrowX = self.arrowImageView.center.x;
}

-(void)setupView{
	
	self.topView.layer.shadowColor = [UIColor colorWithRed:0.875  green:0.875  blue:0.898 alpha:1].CGColor;
	self.topView.layer.shadowOffset = CGSizeMake(0, 1);
	self.topView.layer.shadowRadius = 1;
	self.topView.layer.shadowOpacity = 0.5;
	
}

-(void)setupScrollView{
	self.scrollView.delegate = self;
	self.scrollView.contentSize = CGSizeMake(APP_SCREEN_WIDTH * tabCount , APP_SCREEN_HEIGHT - tabHeight);
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsVerticalScrollIndicator = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.bounces = NO;
}

-(void)setupWebView{
	self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - tabHeight)];
	self.webView.delegate = self;
	self.webView.backgroundColor = [UIColor whiteColor];
	[self.scrollView addSubview:self.webView];
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
	
}


#pragma mark <UIScrollViewDelegate>



#pragma mark Private Method

- (void)onClickTopViewButton:(UIButton *)sender {
	
	//改变 “箭头图标” 位置动画
	float postionX = sender.center.x;
	float postionY = self.arrowImageView.center.y;
	
	[UIView animateWithDuration:0.5f
					 animations:^{
						 self.arrowImageView.center = CGPointMake(postionX, postionY);
					 }
					 completion:^(BOOL finished) {
						 self.currentArrowX = sender.center.x;
					 }];
	
}





@end
