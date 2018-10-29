//
//  ShowPanoramaViewCtontroller.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/2/27.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "ShowPanoramaViewCtontroller.h"
#import <WebKit/WebKit.h>

@interface ShowPanoramaViewCtontroller () <WKUIDelegate,WKNavigationDelegate>

@end

@implementation ShowPanoramaViewCtontroller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
  
}


- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *panoramaUrl = [NSString stringWithFormat:@"%@/home/panorama",[[BaseApiDomainUtil getApiDomain] getAPlusDomainUrl]];
    
    NSString *webURL = [NSString stringWithFormat:@"%@?url=%@",panoramaUrl,_photoPath];
        
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    [self.view addSubview:webView];
    [self showLoadingView:nil];
    
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 14, 23)];
    backImage.image = [UIImage imageNamed:@"backBtnImg"];
    [self.view addSubview:backImage];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(15, 30, 60, 60);
    [self.view addSubview:button];
    
    
}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}


// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self hiddenLoadingView];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [self hiddenLoadingView];
}



@end
