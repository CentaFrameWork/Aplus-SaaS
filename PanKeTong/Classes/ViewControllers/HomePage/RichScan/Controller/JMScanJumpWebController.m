//
//  JMScanJumpController.m
//  PanKeTong
//
//  Created by Admin on 2018/5/21.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMScanJumpWebController.h"
#import <WebKit/WebKit.h>
@interface JMScanJumpWebController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic,strong) NSURL *webUrl;
@end

@implementation JMScanJumpWebController

- (instancetype)initWithUrl:(NSURL *)webUrl {
    
    if (self = [super init]) {
        
        self.webUrl = webUrl;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNav];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.webUrl]];
}


- (void)setNav {
    
    self.navigationItem.leftBarButtonItem = [self getLeftBtn];
      
}


#pragma mark - **********Delegate目前没用**********
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    self.progressView.hidden = NO;
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    

    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return NO;
}

#pragma mark *******KVO的监听代理********
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.5f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progressView setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 [self.progressView setProgress:0.0f animated:NO];
                             }];
        }
    }else if ([keyPath isEqualToString:@"title"]){
        
        self.title = self.webView.title;
        
    }
    
}


- (WKWebView *)webView {
    
    if (!_webView) {
        
        //暂时没有什么设置的 先这样写
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _webView.navigationDelegate = self;
        [_webView setAllowsBackForwardNavigationGestures:true];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        
        [self.view addSubview:_webView];
        
        
    }
    return _webView;
}

-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 5);
        
        [_progressView setTrackTintColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        _progressView.progressTintColor = YCThemeColorGreen;
        [self.view addSubview:_progressView];
        
    }
    return _progressView;
}

#pragma mark -  *********导航返回键***********
- (UIBarButtonItem*)getLeftBtn {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    
    UIButton *customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    customBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 10);
    customBtn.tag = 0;
    [customBtn setImage:[UIImage imageNamed:@"backBtnImg"] forState:UIControlStateNormal];
    
    [customBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:customBtn];
    
    
    
    UIButton *customBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 40)];
    customBtn1.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    
    [customBtn1 setImage:[UIImage imageNamed:@"删除2"] forState:UIControlStateNormal];
    
    [customBtn1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    customBtn1.tag = 1;
    [view addSubview:customBtn1];
    
    return [[UIBarButtonItem alloc] initWithCustomView:view];
    
    
}


- (void)click:(UIButton*)btn {
    
    if (btn.tag) {
        [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
    }else{
        
        if ([self.webView canGoBack]) {
            [self.webView goBack];
            
        } else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

@end
