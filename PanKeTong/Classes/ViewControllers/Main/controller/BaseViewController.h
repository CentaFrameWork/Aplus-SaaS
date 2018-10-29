//
//  BaseViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "Error.h"
#import "RequestManager.h"
#import "SQLiteManager.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsService.h"
#import "LogOffUtil.h"

#define     NotHavePermissionTip        "抱歉,您没有相关权限!"

/**
 *  搜索框按钮tag：语音、文字
 */
typedef enum
{
    TopTextSearchType = 60000,
    TopVoidSearchType,
    
}TopSearchTypeEnum;

typedef void (^HaveMenuPermissionBlock) (NSString *permission);

@interface BaseViewController : UIViewController<ResponseDelegate,UMSocialUIDelegate,UIGestureRecognizerDelegate>
{
    RequestManager *_manager;
    BOOL _isShowErrorAlert;     // 有错误提示时是否显示

    BOOL _isNewVC;              // 是否是2.X的页面
}

    ///返回按钮barItem
- (UIButton *)backBarItemButtionWithSel:(SEL)sel;

/// 返回上一级页面
- (void)back;

- (AppDelegate *)sharedAppDelegate;

- (NSString *)getClassName;


/// 设置导航栏item
- (void)setNavTitle:(NSString *)titleStr
     leftButtonItem:(UIButton *)leftBtn
    rightButtonItem:(UIButton *)rightBtn;

/// 设置无结果时显示的icon
- (void)noResultImageWithHeight:(CGFloat)viewHeight
                      andOnView:(UIView *)showView
                        andShow:(BOOL)isShow;
/// 创建navItem
- (UIButton *)customBarItemButton:(NSString *)title
                  backgroundImage:(NSString *)bgImg
                       foreground:(NSString *)fgImg
                              sel:(SEL)sel;

#pragma mark - 设置是否让导航栏有下边线
- (void)setNavigationBarIsHasOffline:(BOOL)isHasOffline;

#pragma mark - 设置是否需要隐藏导航栏

- (void)navBarNeedHidden:(BOOL)isHidden
            andAnimation:(BOOL)isAnimation;

/// 设置是否需要隐藏导航栏
- (void)setNeedHiddenNavBar:(BOOL)isHidden
               andAnimation:(BOOL)isAnimation;

#pragma mark 创建导航栏搜索

/// 设置输入框样式
- (void)setTextfieldStyleWithItem:(UITextField *)textfield;

/// 创建搜索框中的语音按钮
-(UIButton *)createVoiceSearchBtnWithSelector:(SEL)selector;

/// 文字搜索按钮
- (UIButton *)createTextSearchBtnWithSelector:(SEL)selector;

/// 创建顶部搜索框
- (void)createTopSearchBarViewWithTextSearchBtn:(UIButton *)textSearchBtn
                                    andRightBtn:(UIButton *)rightBtn
                                 andPlaceholder:(NSString *)placeholder;


//- (void)handleError:(Error *)error;

/// 检查网络请求错误后调用
- (void)dealData:(id)data andClass:(id)modelClass;

/// 结束列表刷新
- (void)endRefreshWithTableView:(UITableView *)tableView;

/// MBProgressHUD
- (void)showLoadingView:(NSString *)message;
- (void)hiddenLoadingView;


/// 创建搜索框中的语音按钮
- (UIButton *)createVoiceOrDeleteBtnWithImageName:(NSString *)btnImage
                                      andSelector:(SEL)selector;

/// 创建公用的textfield
- (UITextField *)createTextfieldWithPlaceholder:(NSString *)placeHolderStr
                                andHaveRightBtn:(BOOL)haveRightBtn;

/// 创建顶部搜索框
- (void)createTopSearchBarViewWithTextField:(UITextField*)textfield
                                andRightBtn:(UIButton *)rightBtn;

#pragma mark - SendSharePropDetail

/// 分享房源详情
- (void)sendSharePropDetailWithKeyId:(NSString *)keyId
                           andImgUrl:(NSString *)imgUrl
                          andEstName:(NSString *)estName;

- (void)sendTakeGetEstates:(NSString *)imgUrl
                   andName:(NSString *)name;

/// 分享资讯
- (void)sendShareInformation:(NSString *)infoUrl InforTitle:(NSString *)title InforImage:(NSString *)imageUrl;

/// 我的2017分享
- (void)sendMy2017:(NSString *)infoUrl InforTitle:(NSString *)title InforImage:(NSString *)imageUrl Content:(NSString *)shareContent;

#pragma mark - ShareAppMethod

/// 分享APP
- (void)shareAppMethod;

/// 判断该页面是否有权限查看
- (BOOL)checkShowViewPermission:(NSString *)permission
         andHavePermissionBlock:(HaveMenuPermissionBlock)block;

@end
