//
//  JMMyDaysWorkViewController.m
//  PanKeTong
//
//  Created by 陈行 on 2018/4/23.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMMyDaysWorkViewController.h"

#import "CustomWebProgressView.h"

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

@interface JMMyDaysWorkViewController ()

@property (nonatomic, weak) WKWebView * webView;

@property (nonatomic, weak) CustomWebProgressView * webProgressView;

@property (nonatomic, strong) NSMutableArray * kvoKeyPathArr;

@end

@implementation JMMyDaysWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNavigationBar];
    
    __block typeof(self) weakSelf = self;
    
    [self checkShowViewPermission:CENTER_QUANTIZATION andHavePermissionBlock:^(NSString *permission) {
        //检查权限
        [weakSelf loadMainView];
        
    }];
    
}

- (void)loadMainView{
    
    self.kvoKeyPathArr = [[NSMutableArray alloc] init];
    
    NSString *staff = [CommonMethod getUserdefaultWithKey:UserStaffNumber];

    NSString * corPorationKeyId = FINAL_CORPORATION_KEY_ID;
    
    NSDictionary * params = @{
                              @"staffno" : staff ? : @"",
                              @"CorPorationKeyId" : corPorationKeyId ? : @"",
                              };
    
    NSString * url = [NSString stringWithFormat:@"%@/home/quantification?urlParams=%@", NewBaseUrl, [[params mj_JSONString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    WKWebView * webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - BOTTOM_SAFE_HEIGHT)];
    
    [self.view addSubview:webView];
    self.webView = webView;
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [webView loadRequest:request];
    
    CustomWebProgressView * pv = [CustomWebProgressView progressViewAndFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 2) andWebView:self.webView andDelegate:nil];
    pv.backgroundColor = YCThemeColorGreen;
    [self.view addSubview:pv];
    self.webProgressView = pv;
    
}

- (void)loadNavigationBar{
    
    [self setNavTitle:@"我的量化" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:nil];
    
}

- (void)back{
    [self.webProgressView freeWebProgressView];
    [self.webProgressView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    
    [self.webProgressView freeWebProgressView];
    
    [self.webProgressView removeFromSuperview];
    
}

@end
