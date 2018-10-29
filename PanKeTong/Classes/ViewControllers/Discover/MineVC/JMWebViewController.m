//
//  JMWebViewController.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/29.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMWebViewController.h"

#import "CustomWebProgressView.h"

#import "WebViewFilterUtil.h"
#import "APPConfigEntity.h"

#import <MJExtension/MJExtension.h>
#import <WebKit/WebKit.h>

/**
 *  状态栏高度
 */
#define HEIGHT_STATUSBAR [[UIApplication sharedApplication] statusBarFrame].size.height
/**
 *  导航栏高度
 */
#define HEIGHT_NAV self.navigationController.navigationBar.frame.size.height
/**
 *  顶部导航栏+状态栏高度
 */
#define HEIGHT_NAV_AND_STATUSBAR (HEIGHT_STATUSBAR + HEIGHT_NAV)

@interface JMWebViewController ()

@property (nonatomic, weak) WKWebView * webView;

@property (nonatomic, weak) CustomWebProgressView * webProgressView;

@property (nonatomic, strong) NSMutableArray * kvoKeyPathArr;

@end

@implementation JMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNavigationBar];
    
    __block typeof(self) weakSelf = self;
    
    if ([self.entity.title isEqualToString:@"工作量化"]) {
        
        BOOL isHave = [self checkShowViewPermission:CENTER_QUANTIZATION andHavePermissionBlock:nil];
        
        if (isHave == false) {
            
            return;
            
        }
        
    }
    
    [weakSelf loadMainView];
}

- (void)loadMainView{
    
    self.kvoKeyPathArr = [[NSMutableArray alloc] init];
    
    NSDictionary *urlDic = @{
                             @"Description" : self.entity.mDescription,
                             @"JumpContent" : self.entity.jumpContent,
                             @"Title" : self.entity.title,
                             };
    
    AbsWebViewFilter *webviewFilter = [WebViewFilterUtil instantiation];
    
    NSString * url = [webviewFilter getFullUrl:urlDic];
    
    WKWebView * webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - BOTTOM_SAFE_HEIGHT)];
    
    [self.view addSubview:webView];
    self.webView = webView;
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [webView loadRequest:request];
    
    CustomWebProgressView * pv = [CustomWebProgressView progressViewAndFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 2) andWebView:self.webView andDelegate:nil];
    pv.backgroundColor = YCThemeColorGreen;
    [self.view addSubview:pv];
    self.webProgressView = pv;
    
    //增加监听事件
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.kvoKeyPathArr addObject:@"title"];
    
}

- (void)loadNavigationBar{
    
    [self setNavTitle:self.entity.title leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:nil];
    
}

- (void)back{
    
    [self.webProgressView freeWebProgressView];
    [self.webProgressView removeFromSuperview];
    [self removeKeyPath];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeKeyPath{
    
    @synchronized(self){
        
        for (NSString * keyPath in self.kvoKeyPathArr) {
            
            [self.webView removeObserver:self forKeyPath:keyPath];
            
        }
        
        [self.kvoKeyPathArr removeAllObjects];
        
    }
    
}

#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"title"] && object == self.webView){
        
        self.navigationItem.title = self.webView.title;
        
    }else{
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
}

#pragma mark - 系统协议
- (void)dealloc{
    
    [self.webProgressView freeWebProgressView];
    
    [self.webProgressView removeFromSuperview];
    
    [self removeKeyPath];
    
}

@end
