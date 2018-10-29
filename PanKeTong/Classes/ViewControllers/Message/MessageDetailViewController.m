//
//  MessageDetailViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/9/23.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MessageDetailViewController.h"

#import "CustomWebProgressView.h"

#import "CAShapeLayer+Category.h"

#import <WebKit/WebKit.h>

@interface MessageDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerConView;

@property (weak, nonatomic) IBOutlet UILabel *headerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *webConView;

@property (nonatomic, weak) WKWebView * webView;

@property (nonatomic, weak) CustomWebProgressView * webProgressView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerConViewHeightCon;



@property (nonatomic, strong) NSMutableArray * kvoKeyPathArr;

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMainView];
    [self loadNavigationBar];
    
}

- (void)loadMainView{
    
    self.headerNameLabel.text = self.headerName;
    self.timeLabel.text = self.timeString;
    
    //计算标题高度
    CGFloat headerHeight = [self.headerName heightWithLabelFont:self.headerNameLabel.font withLabelWidth:APP_SCREEN_WIDTH - 24] + 66 - 22;
    self.headerConViewHeightCon.constant = headerHeight;
    
    NSString * pageSourceUrl = [[BaseApiDomainUtil getApiDomain] getMessageUrlWithInfoId:self.infoId];
    
    pageSourceUrl = [pageSourceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    WKWebView * webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - BOTTOM_SAFE_HEIGHT - headerHeight)];
    
    [self.webConView addSubview:webView];
    
    self.webView = webView;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pageSourceUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [self.webView loadRequest:request];
    
    self.webView.scrollView.bounces = NO;
    
    CustomWebProgressView * pv = [CustomWebProgressView progressViewAndFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 2) andWebView:self.webView andDelegate:nil];
    pv.backgroundColor = YCThemeColorGreen;
    [self.view addSubview:pv];
    self.webProgressView = pv;
    
    CAShapeLayer * shapeLayer = [CAShapeLayer shaperLayerAddLineFromPoint:CGPointMake(12, headerHeight) toPoint:CGPointMake(APP_SCREEN_WIDTH - 12, headerHeight) andColor:YCOtherColorBorder];
    
    [self.headerConView.layer addSublayer:shapeLayer];
    
}

- (void)loadNavigationBar{
    
    [self setNavTitle:@"消息详情" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:nil];
    
}

- (void)back{
    
    [self.webProgressView freeWebProgressView];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    
    [self.webProgressView freeWebProgressView];
    
}

@end
