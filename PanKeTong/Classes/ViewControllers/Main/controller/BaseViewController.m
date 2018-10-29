
//
//  BaseViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "AgencyUserPermisstionUtil.h"

#import "CheckPermissionAlertDelegate.h"
#import "AgencyUserPermisstionUtil.h"
#import "CityCodeVersion.h"
#import <RongIMKit/RongIMKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ServiceHelper.h"
#import "BaseEntity.h"
#import "DataConvert.h"
#import "AgencyBaseEntity.h"
#import "FaceUploadEntity.h"
#import "CheckHttpErrorUtil.h"
#import "JDStatusBarNotification.h"

#define NoResultImageViewTag            90000

@interface BaseViewController ()
{
    HudViewUtil *_hudViewUtil;
    Error *_error;
    
    /// 是否需要隐藏导航栏
    BOOL _needHiddenNavBar;
    
    /// 是否需要动画隐藏导航栏
    BOOL _hiddenNavBarAnimation;
    
}

@end

@implementation BaseViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _manager = [RequestManager initManagerWithDelegate:self];
    _isShowErrorAlert = YES;
    _hudViewUtil = [[HudViewUtil alloc] init];
    
    // 默认不隐藏导航栏
    _needHiddenNavBar = NO;
    _hiddenNavBarAnimation = YES;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavConfig];
    //设置为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    // 处理导航栏是否显示
    [self setNeedHiddenNavBar:_needHiddenNavBar andAnimation:_hiddenNavBarAnimation];
    if (self.navigationController.viewControllers.count > 1) {
        self.hidesBottomBarWhenPushed = YES;
    } else {
        self.hidesBottomBarWhenPushed = NO;
    }
    
    // 手势的代理设置为self
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *className = [self getClassName];
    [[BaiduMobStat defaultStat] pageviewStartWithName:className];
    
    // 首页取消侧滑
    if (self.navigationController.viewControllers.count==1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)setNavConfig {
    
    // 取消导航栏模糊层
    self.navigationController.navigationBar.translucent = NO;
    // 设置系统的导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    // 设置导航栏背景及文字
    UINavigationBar *appearance = self.navigationController.navigationBar;
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    
    if (_isNewVC)
    {
        textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
        [self.navigationController.navigationBar setShadowImage:nil];
        //        [appearance setBackgroundImage:[UIImage imageNamed:@"horizontalLongSeperator_line"] forBarMetrics:UIBarMetricsDefault];
        //        [appearance setBackgroundImage:[UIImage imageNamed:@"navBar_bg"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        textAttrs[NSForegroundColorAttributeName] = YCTextColorBlack;
        textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
        //        [appearance setBackgroundImage:[UIImage imageNamed:@"navBarBg_img"] forBarMetrics:UIBarMetricsDefault];
    }
    
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:FontName size:16.0];
    
    // 设置导航栏背景
    textAttrs[NSShadowAttributeName] = [[NSShadow alloc] init];
    
    [appearance setTitleTextAttributes:textAttrs];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSString *className = [self getClassName];
    
    [[BaiduMobStat defaultStat] pageviewEndWithName:className];
}

#pragma mark - 设置导航栏黑线
- (void)setNavigationBarIsHasOffline:(BOOL)isHasOffline{
    
    UIImage * image = isHasOffline ? nil : [[UIImage alloc] init];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = image;
    
}

#pragma mark - 设置是否需要隐藏导航栏

/// 设置通用属性
- (void)navBarNeedHidden:(BOOL)isHidden
            andAnimation:(BOOL)isAnimation
{
    _needHiddenNavBar = isHidden;
    _hiddenNavBarAnimation = isAnimation;
    
}

/// 设置是否需要隐藏导航栏
- (void)setNeedHiddenNavBar:(BOOL)isHidden
               andAnimation:(BOOL)isAnimation
{
    BOOL isCurNavHidden = self.navigationController.isNavigationBarHidden;
    
    if (isHidden)
    {
        // 导航栏如果已经隐藏，不需要重复设置
        if (!isCurNavHidden)
        {
            [self.navigationController setNavigationBarHidden:isHidden animated:isAnimation];
        }
        
    }
    else
    {
        // 导航栏已经显示，不需要重复设置
        if (isCurNavHidden)
        {
            [self.navigationController setNavigationBarHidden:isHidden animated:isAnimation];
        }
        
    }
}

#pragma mark 创建导航栏搜索

/// 创建搜索框中的语音按钮
-(UIButton *)createVoiceSearchBtnWithSelector:(SEL)selector;
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"语音"]
              forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn addTarget:self
                 action:selector
       forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}

/// 文字搜索按钮
- (UIButton *)createTextSearchBtnWithSelector:(SEL)selector
{
    UIButton *textSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [textSearchBtn setBackgroundColor:[UIColor clearColor]];
    [textSearchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [textSearchBtn setTitleColor:RGBColor(153.0, 153.0, 153.0) forState:UIControlStateNormal];
    [textSearchBtn addTarget:self
                      action:selector
            forControlEvents:UIControlEventTouchUpInside];
    
    return textSearchBtn;
}

/// 创建顶部搜索框
- (void)createTopSearchBarViewWithTextSearchBtn:(UIButton *)textSearchBtn
                                    andRightBtn:(UIButton *)rightBtn
                                 andPlaceholder:(NSString *)placeholder
{
    CGFloat topSearchViewWidth = APP_SCREEN_WIDTH;
    
    if (self.navigationItem.leftBarButtonItems.count > 0 ||
        self.navigationItem.leftBarButtonItem) {
        
        topSearchViewWidth -= 62;
    }
    
    if (self.navigationItem.rightBarButtonItems.count > 0 ||
        self.navigationItem.rightBarButtonItem) {
        
        topSearchViewWidth -= 62;
    }
    
    // titleView
    UIView *topSearchView = [[UIView alloc] init];
    [topSearchView setFrame:CGRectMake(0, 0, topSearchViewWidth, 30)];
    
    // 默认提示文字
    [textSearchBtn setBackgroundColor:[UIColor clearColor]];
    [textSearchBtn setImage:[UIImage imageNamed:@"search"]
                   forState:UIControlStateNormal];
    [textSearchBtn setTitle:placeholder
                   forState:UIControlStateNormal];
    textSearchBtn.titleLabel.font = [UIFont fontWithName:FontName
                                                    size:13*NewRatio];
    [textSearchBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [textSearchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [textSearchBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [textSearchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    UILabel *placeholderLabel = [[UILabel alloc]init];
    placeholderLabel.backgroundColor = [UIColor clearColor];
    placeholderLabel.text = placeholder;
    placeholderLabel.font = [UIFont fontWithName:FontName
                                            size:12.0];
    placeholderLabel.textColor = [UIColor whiteColor];
    
    // 搜索框背景图片imageView
    UIImageView *searchBarBgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索框背景"]];
    searchBarBgImage.frame = CGRectMake(0, (CGRectGetHeight(topSearchView.frame)-30)/2, CGRectGetWidth(topSearchView.frame), 30);
    
    [topSearchView addSubview:searchBarBgImage];
    [topSearchView addSubview:rightBtn];
    [topSearchView addSubview:textSearchBtn];
    
    // 添加控件约束
    [searchBarBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        //            make.top.mas_equalTo(0);
        //            make.bottom.mas_equalTo(-2);
        
    }];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(-2);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(30);
    }];
    [textSearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-2);
        make.right.equalTo(rightBtn.mas_left).with.offset(-2);
    }];
    
    self.navigationItem.titleView = topSearchView;
}


///返回按钮barItem
-(UIButton *)backBarItemButtionWithSel:(SEL)sel
{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 50, 44)];
    
    if (MODEL_VERSION >= 11.0) {
        
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    }
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [backBtn setImage:[UIImage imageNamed:@"navBar_back_btnImg"]
             forState:UIControlStateNormal];
    
    
    if (sel) {
        [backBtn addTarget:self
                    action:sel
          forControlEvents:UIControlEventTouchUpInside];
    }
    
    return backBtn;
    
}

#pragma mark - <ShareAppdelegate>

- (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - SetNavItemMethod

- (void)setNavTitle:(NSString *)titleStr
     leftButtonItem:(UIButton *)leftBtn
    rightButtonItem:(UIButton *)rightBtn
{
    
    self.navigationItem.title = titleStr;
    
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil
                                            action:nil];
    
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    self.navigationItem.leftBarButtonItems = @[leftBackItem];
    self.navigationItem.rightBarButtonItems = @[rightNegativeSpacer,rightBarItem];
}

- (UIButton *)customBarItemButton:(NSString *)title
                  backgroundImage:(NSString *)bgImg
                       foreground:(NSString *)fgImg
                              sel:(SEL)sel {
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //    UIFont *font = [UIFont fontWithName:FontName size:15.0];
    UIFont *font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    
    CGFloat titleWidth = [title getStringWidth:font
                                        Height:44
                                          size:15.0];
    
    titleWidth = title.length?titleWidth+24:44;
    
    [customBtn setFrame:CGRectMake(0, 0, titleWidth, 44)];
    [customBtn setBackgroundColor:[UIColor clearColor]];
    //    [customBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    if (bgImg)
    {
        UIImage *image = [UIImage imageNamed:bgImg];
        [customBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (fgImg && MODEL_VERSION >= 7.0)
    {
//        [customBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [customBtn setImage:[UIImage imageNamed:fgImg] forState:UIControlStateNormal];
    }
    
    if (title)
    {
        [customBtn setTitle:title forState:UIControlStateNormal];
    }
    
    [customBtn.titleLabel setFont:font];
    //    UIColor *titleColor = _isNewVC == YES?[UIColor blackColor]:[UIColor whiteColor];
    UIColor *titleColor = YCTextColorGray;
    [customBtn setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (sel)
    {
        [customBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    
    return customBtn;
}

- (UIButton *)createVoiceOrDeleteBtnWithImageName:(NSString *)btnImageName
                                      andSelector:(SEL)selector
{
    /**
     *  语音搜索按钮
     */
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(APP_SCREEN_WIDTH - 180, 0, 38, 30)];
    [rightBtn setImage:[UIImage imageNamed:btnImageName]
              forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn addTarget:self
                 action:selector
       forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}

- (UITextField *)createTextfieldWithPlaceholder:(NSString *)placeHolderStr
                                andHaveRightBtn:(BOOL)haveRightBtn
{
    /**
     默认文字textfield
     */
    UITextField *textfield = [[UITextField alloc]init];
    [textfield setFrame:CGRectMake(35, 0, APP_SCREEN_WIDTH-(haveRightBtn?172:142)-25, 30)];
    [textfield setFont:[UIFont fontWithName:FontName
                                       size:13.0]];
    
    [textfield setTextColor:YCTextColorAuxiliary];
    [textfield setBackgroundColor:[UIColor clearColor]];
    [textfield setPlaceholder:placeHolderStr];
    [textfield setClearButtonMode:UITextFieldViewModeNever];
    //不要执行以下设置
//    [self setTextfieldStyleWithItem:textfield];
    
    return textfield;
}

- (void)createTopSearchBarViewWithTextField:(UITextField*)textfield
                                andRightBtn:(UIButton *)rightBtn
{
    /**
     titleView
     */
    UIView *topSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH-140, 30)];
    
    /**
     放大镜imageView
     */
    UIImageView *searchIconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Shape"]];
    searchIconImage.frame=CGRectMake(10, 7, 15, 15);
    
    /**
     搜索框背景图片imageView
     */
    UIImageView *searchBarBgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索框背景"]];
    searchBarBgImage.frame = CGRectMake(0, (CGRectGetHeight(topSearchView.frame)-30)/2, CGRectGetWidth(topSearchView.frame), 30);
        
    [topSearchView addSubview:searchBarBgImage];
    [topSearchView addSubview:searchIconImage];
    [topSearchView addSubview:textfield];
    [topSearchView addSubview:rightBtn];
    
    self.navigationItem.titleView = topSearchView;
    
}

- (void)back
{
    NSArray *vcArray = [self.navigationController viewControllers];
    
    if (vcArray.count > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - <NoResultMethod>

- (void)noResultImageWithHeight:(CGFloat)viewHeight
                      andOnView:(UIView *)showView
                        andShow:(BOOL)isShow
{
    UIImageView *noResultImageView = (UIImageView *)[self.view viewWithTag:NoResultImageViewTag];
    
    if (!isShow)
    {
        // 移除noResultView
        [noResultImageView removeFromSuperview];
        return;
    }
    
    if (!noResultImageView)
    {
        noResultImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 185, 90)];
        noResultImageView.center = showView.center;
        [noResultImageView setBackgroundColor:[UIColor clearColor]];
        noResultImageView.tag = NoResultImageViewTag;
        [noResultImageView setImage:[UIImage imageNamed:@"icon_jm_no_result_image"]];
    }
    
    [showView insertSubview:noResultImageView
                    atIndex:0];
}

#pragma mark - <SetTextfieldStyle>

- (void)setTextfieldStyleWithItem:(UITextField *)textfield
{
    // 设置placeholder的颜色，其中的_placeholderLabel.textColor是系统自带的，可以直接使用
    [textfield setValue:[UIColor colorWithRed:255.0/255.0
                                        green:255.0/255.0
                                         blue:255.0/255.0
                                        alpha:0.6]
             forKeyPath:@"_placeholderLabel.textColor"];
    
    // 设置光标颜色
//    [textfield setTintColor:YCTextColorBlack];
    
    // 设置输入字体颜色
    [textfield setTextColor:YCTextColorBlack];
}

#pragma mark - <GetClassNameMethod>

- (NSString *)getClassName
{
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    return className;
}



#pragma mark - <EndRefresh>

- (void)endRefreshWithTableView:(UITableView *)tableView
{
    if (tableView.mj_footer.isRefreshing)
    {
        
        [tableView.mj_footer endRefreshing];
    }
    
    if (tableView.mj_header.isRefreshing)
    {
        
        [tableView.mj_header endRefreshing];
        
    }
}

#pragma mark - <MBProgressHUD>

- (void)showLoadingView:(NSString *)message
{
    [_hudViewUtil showLoadingView:message];
}
- (void)hiddenLoadingView
{
    [_hudViewUtil hiddenLoadingView];
}

#pragma mark - <SendSharePropDetail>

/// 分享房源详情
- (void)sendSharePropDetailWithKeyId:(NSString *)keyId
                           andImgUrl:(NSString *)imgUrl
                          andEstName:(NSString *)estName
{
    UIImage *defaultImg = [UIImage imageNamed:@"defaultEstateBig"];
    NSString *estLink = [CommonMethod getPropDetailShareLinkWithKeyId:keyId];
    NSString *newImgUrl = [NSString stringWithFormat:@"%@%@",imgUrl,AllRoundListPhotoWidth];
    
    
    NSLog(@"分享链接 = %@",estLink);
    NSLog(@"imgUrl ====%@==== \n newImgUrl ===%@===  \n  estName = %@",imgUrl, newImgUrl, estName);
    
    [UMSocialWechatHandler setWXAppId:WeixinAppKey appSecret:WeixinAppSecret url:estLink];
    
    // 分享的图片
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:newImgUrl];
    [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeImage
                                                                           url:newImgUrl];
    // 微信好友内容
    [UMSocialData defaultData].extConfig.wechatSessionData.title = estName;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = [NSString stringWithFormat:@"【%@】",estName];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = estLink;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAppKey
                                      shareText:nil
                                     shareImage:defaultImg
                                shareToSnsNames:@[UMShareToWechatSession]
                                       delegate:self];
}

- (void)sendTakeGetEstates:(NSString *)imgUrl
                   andName:(NSString *)name
{
    UIImage *defaultImg = [UIImage imageNamed:@"defaultEstateBg_img.png"];
    
    NSString *estLink = [NSString stringWithFormat:@"%@/home/traffic?estate=%@",NewBaseUrl,name];
    
    [UMSocialWechatHandler setWXAppId:WeixinAppKey
                            appSecret:WeixinAppSecret
                                  url:estLink];
    
    // 分享的图片
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage
                                                        url:imgUrl];
    [[UMSocialData defaultData].extConfig.sinaData.urlResource
     setResourceType:UMSocialUrlResourceTypeImage
     url:imgUrl];
    
    // 微信好友内容
    [UMSocialData defaultData].extConfig.wechatSessionData.title = name;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = [NSString stringWithFormat:@"【%@】",name];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = estLink;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAppKey
                                      shareText:nil
                                     shareImage:defaultImg
                                shareToSnsNames:@[UMShareToWechatSession]
                                       delegate:self];
}

#pragma mark - <SendShareInformation>
/// 分享资讯
- (void)sendShareInformation:(NSString *)infoUrl InforTitle:(NSString *)title InforImage:(NSString *)imageUrl
{
    UIImage *defaultImg = [UIImage imageNamed:@"information_default.png"];
    
    NSLog(@"分享链接 = %@",infoUrl);
    [UMSocialWechatHandler setWXAppId:WeixinAppKey
                            appSecret:WeixinAppSecret
                                  url:infoUrl];
    
    // 分享的图片
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage
                                                        url:imageUrl];
    [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeImage
                                                                           url:imageUrl];
    
    // 微信好友内容
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    NSString *sharedContent = @"中原资讯，带您了解不一样的房地产世界~";
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = [NSString stringWithFormat:@"【%@】",sharedContent];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = infoUrl;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAppKey
                                      shareText:nil
                                     shareImage:defaultImg
                                shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                       delegate:self];
}

- (void)sendMy2017:(NSString *)infoUrl InforTitle:(NSString *)title InforImage:(NSString *)imageUrl Content:(NSString *)shareContent
{
    UIImage *defaultImg = [UIImage imageNamed:@"information_default.png"];
    
    NSLog(@"分享链接 = %@",infoUrl);
    [UMSocialWechatHandler setWXAppId:WeixinAppKey
                            appSecret:WeixinAppSecret
                                  url:infoUrl];
    
    // 分享的图片
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage
                                                        url:imageUrl];
    [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeImage
                                                                           url:imageUrl];
    
    // 微信好友内容
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    NSString *sharedContent = shareContent;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = [NSString stringWithFormat:@"【%@】",sharedContent];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = infoUrl;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAppKey
                                      shareText:nil
                                     shareImage:defaultImg
                                shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                       delegate:self];
}

#pragma mark - <ShareAppMethod>

- (void)shareAppMethod
{
    NSString *shareContent = [NSString stringWithFormat:@"中原自己的贴身管家，为您管理房源、客户提供帮助，下载地址：%@",APPDownloadUrl];
    
    [UMSocialWechatHandler setWXAppId:WeixinAppKey
                            appSecret:WeixinAppSecret
                                  url:nil];
    
    // 分享微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = shareContent;
    
    // 分享朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = shareContent;
    
    // 新浪微博分享内容
    [UMSocialData defaultData].extConfig.sinaData.shareText = shareContent;
    
    // 短信分享
    [UMSocialData defaultData].extConfig.smsData.shareText = shareContent;
    
    
    // 清空图片
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage
                                                        url:nil];
    [[UMSocialData defaultData].extConfig.sinaData.urlResource
     setResourceType:UMSocialUrlResourceTypeImage
     url:nil];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAppKey
                                      shareText:nil
                                     shareImage:nil
                                shareToSnsNames:@[
                                                  UMShareToSina,
                                                  UMShareToSms,
                                                  UMShareToWechatSession,
                                                  UMShareToWechatTimeline,
                                                  ]
                                       delegate:nil];
}

- (BOOL)checkShowViewPermission:(NSString *)permission
         andHavePermissionBlock:(HaveMenuPermissionBlock)block
{
    BOOL isHave = [AgencyUserPermisstionUtil hasMenuPermisstion:permission];
    if(!isHave)
    {
        [self showNotPermissionShowViewDialog];
    }
    else
    {
        if(block)
        {
            block(permission);
        }
    }
    
    return isHave;
}

- (void)showNotPermissionShowViewDialog
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您没有相关权限！"
                                                       delegate:[CheckPermissionAlertDelegate initWithController:self]
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)dealloc
{
    _manager.delegate = nil;
    _manager = nil;
    
}


// －－－－－分析：
// 总体来看，数据响应状态分为两种类型：［请求数据成功］／［请求数据失败］
// 而［请求数据成功］又分为了 ［数据正常］／［数据不正常］
// 因此，数据返回类型粗略的分析便有了三种类型。（ 一定要先理清思路 ）

#pragma mark - <ResponseDelegate>

- (void)respSuc:(id)data andRespClass:(id)cls
{
    id perUser = data;
    
    BOOL isCanUse = [self isCanUseAccountWithData:data];
    
    if (isCanUse == false) {
        
        return;
        
    }
    
    if (![cls isEqual:[NSDictionary class]])
    {
        perUser = [DataConvert convertDic:data toEntity:cls];
        
    }
    
    if([perUser isKindOfClass:[AgencyBaseEntity class]])
    {
        // A+
        id checkData = [ServiceHelper checkAPlusData:data];
        
        if ([checkData isKindOfClass:[Error class]])
        {
            [self hiddenLoadingView];
            // 统一处理错误的消息
            _error = (Error *)checkData;
            _error.isDataError = true;
            
            [self respFail:_error andRespClass:cls];
            
            return;
        }
        else
        {
            [self hiddenLoadingView];
            [self dealData:data andClass:cls];
        }
    }
    else if([perUser isKindOfClass:[BaseEntity class]] && ![perUser isKindOfClass:[FaceUploadEntity class]])
    {
        // 上海
        id checkData = [ServiceHelper checkHKData:data];
        
        if ([checkData isKindOfClass:[Error class]])
        {
            // 统一处理错误的消息
            _error = (Error *)checkData;
            _error.isDataError = true;
            
            [self respFail:_error andRespClass:cls];
            
            return;
        }
        else
        {
            [self hiddenLoadingView];
            [self dealData:data andClass:cls];
        }
    }
    else
    {
        NSLog(@"%@<*********>%@",self,cls);
        // 处理错误的server响应
        id checkData = [ServiceHelper checkAuthorityWith:data];
        
        if ([checkData isKindOfClass:[Error class]])
        {
            // 统一处理错误的消息
            _error = (Error *)data;
            _error.isDataError = true;
            
            [self respFail:_error andRespClass:cls];
            
            return;
        }
        else
        {
            [self hiddenLoadingView];
            [self dealData:data andClass:cls];
        }
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [self hiddenLoadingView];
    
    
    NSLog(@"1*********%@***********1",self);
    NSLog(@"2*********%@***********2",cls);
    
    NSString *errorMsg = @"";
    
    Error * failError = nil;
    
    if ([error isKindOfClass:[Error class]]) {
        failError = (Error *)error;
        errorMsg = [CheckHttpErrorUtil handleError:failError];
        
    }else {
        
        failError = [[Error alloc]init];
        
        failError.rDescription = error.localizedDescription;
        failError.httpCode = error.code;
        
        errorMsg = [CheckHttpErrorUtil handleError:failError];
    }
    
    if (![NSString isNilOrEmpty:errorMsg]){
        
        if (failError.isDataError == true) {
            
            showMsg(errorMsg);
            
        }else{
            
            showJDStatusStyleErrorMsg(errorMsg);
            
        }
        
    }
    
}

- (void)dealData:(id)data andClass:(id)modelClass
{
    
}

- (BOOL)isCanUseAccountWithData:(id)data{
    
    if ([data isKindOfClass:[NSDictionary class]]) {//其他类型数据暂不处理
        
        NSDictionary * tmpDict = data;
        
        NSString * errorCode = [NSString stringWithFormat:@"%@", tmpDict[@"ErrorMsg"]];
        
        if ([errorCode isEqualToString:@"410"]) {
            
            [[[UIAlertView alloc] initWithTitle:@"信息提示" message:@"您的账号出现异常，请联系公司管理员处理" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
            // 用户退出登录后清除用户信息
            [LogOffUtil clearUserInfoFromLocal];
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeDiscoverRootVCIsLogin:YES];
            
            return false;
        }
        
    }
    
    return true;
    
}


@end

