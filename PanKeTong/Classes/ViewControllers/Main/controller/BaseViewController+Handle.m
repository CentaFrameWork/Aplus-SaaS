//
//  BaseViewController+Handle.m
//  PanKeTong
//
//  Created by 李慧娟 on 2018/2/7.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "BaseViewController+Handle.h"
#import "EstateListVC.h"
#import "MyClientVC.h"
#import "PropertyDetailVC.h"
#import "CommonEstateOrCustomerVC.h"
#import "ChannelCallVC.h"
#import "ChannelCustomerVC.h"
#import "FollowListVC.h"
#import "EstatePublishManageVC.h"
#import "RealSurveyAuditingVC.h"
#import "CalendarStrokeVC.h"
#import "TrustAuditingVC.h"
#import "CustomHelpVC.h"
#import "JMWebViewController.h"

#import "AbsWebViewFilter.h"
#import "WebViewFilterUtil.h"
#import "DealController.h"
typedef NS_ENUM(NSInteger, HomePageHTMLToNativeJumpType)
{
    HomePageToNativeJumpTypeCall = 281,                 // 渠道来电
    HomePageToNativeJumpTypePublicEstate = 280,         // 渠道公盘池
    HomePageToNativeJumpTypeMyFavorite = 400,           // 我的收藏
    HomePageToNativeJumpTypePublishCustomer = 220,      // 抢公客
    HomePageToNativeJumpTypePublishEstate = 210,        // 抢公盘
    HomePageToNativeJumpTypeAllRoundEstate = 200,       // 通盘房源
    HomePageToNativeJumpTypeNewEstateNews = 100,        // 新盘资讯
    HomePageToNativeJumpTypeNewEstate = 110,            // 新盘
    HomePageToNativeJumpTypeCustomHelp = 999,           // 帮助快捷入口
    HomePageToNativeJumpTypeMessage = 800,              // 消息快捷入口
    HomePageToNativeJumpTypeSigned = 282,               // 签到入口
    HomePageToNativeJumpTypeLeftFollow = 283,           // 左导跟进记录
    HomePageToNativeJumpTypeMyContribution = 240,       // 房源贡献
    HomePageToNativeJumpTypeADM = 300,                  // 放盘管理
    HomePageToNativeJumpTypeMyClient = 250,             // 我的客户
    HomePageToNativeJumpTypeMyQuantification = 270,     // 我的量化
    HomePageToNativeJumpTypeRealSurveyAuditing = 261,   // 实勘审核（实勘管理）
    HomePageToNativeJumpTypeCalendarStroke = 290,       // 日历行程
    HomePageToNativeJumpTypeTrustAuditing = 310,        // 委托审核
    HomePageToNativeJumpTypeMyBorrowKeys = 320,          // 我的借钥
    HomePageToNativeJumpTypeMYSeal = 500,               // 我的成交
    HomePageToNativeJumpTypeALLSeal = 501             // 全部成交
};

@implementation BaseViewController (Handle)

#pragma mark - 模块跳转

- (void)popWithAPPConfigEntity:(APPLocationEntity *)entity
{
    // 跳转类型
    NSInteger jumpType = [entity.jumpType integerValue];
    // 模块名称
    NSString *modulenName = entity.title;
    // 跳转内容
    NSString *jumpContent;

    /*------------Native界面-----------*/
    if (jumpType == JumpToNative)
    {
        NSString *functionStr = [entity.jumpContent stringByReplacingOccurrencesOfString:@"Function" withString:@"\"Function\""];
        NSDictionary *dic = [functionStr jsonDictionaryFromJsonString];
        jumpContent = [dic objectForKey:@"Function"];

        switch ([jumpContent integerValue])
        {
                case HomePageToNativeJumpTypeAllRoundEstate:
            {
                // 通盘房源
                EstateListVC *estateListVC = [[EstateListVC alloc] initWithNibName:@"EstateListVC" bundle:nil];
                estateListVC.isPropList = YES;
                estateListVC.propType = WARZONE;
                [self.navigationController pushViewController:estateListVC
                                                     animated:YES];
            }
                break;

                case HomePageToNativeJumpTypeMyContribution:
            {
                // 房源贡献
                EstateListVC *allRoundListVC = [[EstateListVC alloc] initWithNibName:@"EstateListVC" bundle:nil];
                allRoundListVC.isPropList = NO;
                allRoundListVC.propType = CONTRIBUTION;

                [self.navigationController pushViewController:allRoundListVC animated:YES];
            }
                break;

                case HomePageToNativeJumpTypeMyFavorite:
            {
                // 我的收藏
                EstateListVC *myCollectVC = [[EstateListVC alloc] initWithNibName:@"EstateListVC"
                                                                           bundle:nil];
                myCollectVC.isPropList = NO;
                myCollectVC.propType = FAVORITE;
                [self.navigationController pushViewController:myCollectVC animated:YES];
            }
                break;

                case HomePageToNativeJumpTypeMyClient:
            {
                
                 MyClientVC *myClientVC = [[MyClientVC alloc] initWithNibName:@"MyClientVC" bundle:nil];
                [self.navigationController pushViewController:myClientVC animated:YES];
            }
                break;

                case HomePageToNativeJumpTypePublishCustomer:
            {
                // 抢公客
                CommonEstateOrCustomerVC *publishEstVC =  [[CommonEstateOrCustomerVC alloc] initWithNibName:@"CommonEstateOrCustomerVC"
                                                                                                     bundle:nil];
                publishEstVC.isPublishEstate = NO;

                [self.navigationController pushViewController:publishEstVC animated:YES];
            }
                break;

                case HomePageToNativeJumpTypePublishEstate:
            {
                // 抢公盘
                CommonEstateOrCustomerVC *publishEstVC = [[CommonEstateOrCustomerVC alloc] initWithNibName:@"CommonEstateOrCustomerVC"
                                                                                                    bundle:nil];
                publishEstVC.isPublishEstate = YES;

                [self.navigationController pushViewController:publishEstVC animated:YES];
            }
                break;

                case HomePageToNativeJumpTypeCall:
            {
                // 渠道来电
                ChannelCallVC *channelCallVC = [[ChannelCallVC alloc] init];
                [self.navigationController pushViewController:channelCallVC animated:YES];
            }
                break;

                case HomePageToNativeJumpTypePublicEstate:
            {
                // 渠道公客池
                ChannelCustomerVC *channelCustomerVC = [[ChannelCustomerVC alloc] initWithNibName:@"ChannelCustomerVC"
                                                                                           bundle:nil];
                [self.navigationController pushViewController:channelCustomerVC animated:YES];
            }
                break;

                case HomePageToNativeJumpTypeNewEstateNews:
            {
                // 新盘资讯

            }
                break;

                case HomePageToNativeJumpTypeNewEstate:
            {
                // 新盘

            }
                break;

                case HomePageToNativeJumpTypeLeftFollow:
            {
                // 跟进记录
                FollowListVC *followListVC = [[FollowListVC alloc] init];
                [self.navigationController pushViewController:followListVC animated:YES];
            }
                break;

                case HomePageToNativeJumpTypeADM:
            {
                // 放盘管理
                EstatePublishManageVC *releaseManageVC = [[EstatePublishManageVC alloc] initWithNibName:@"EstatePublishManageVC"
                                                                                                 bundle:nil];
                [self.navigationController pushViewController:releaseManageVC  animated:YES];
            }
                break;

                case HomePageToNativeJumpTypeMyQuantification:
            {
                // 我的量化
                JMWebViewController * con = [[JMWebViewController alloc] init];
                
                con.entity = entity;
                
                [self.navigationController pushViewController:con  animated:YES];
                
            }
                break;

                case HomePageToNativeJumpTypeRealSurveyAuditing:
            {
                // 实勘审核
                RealSurveyAuditingVC *realSurveyVC = [[RealSurveyAuditingVC alloc] initWithNibName:@"RealSurveyAuditingVC"
                                                                                            bundle:nil];
                realSurveyVC.titleName = modulenName;
                [self.navigationController pushViewController:realSurveyVC animated:YES];
            }
                break;

                case HomePageToNativeJumpTypeCalendarStroke:
            {
                // 日历行程
                [CommonMethod addLogEventWithEventId:@"C stroke_Click" andEventDesc:@"日历行程模块点击量"];

                CalendarStrokeVC *calendarStrokeVC = [[CalendarStrokeVC alloc] init];
                [self.navigationController pushViewController:calendarStrokeVC animated:YES];
            }
                break;

                case HomePageToNativeJumpTypeTrustAuditing:
            {
                // 委托审核
                [CommonMethod addLogEventWithEventId:@"A power of a_Function" andEventDesc:@"委托审核模块点击量"];

                if ([AgencyUserPermisstionUtil hasMenuPermisstion:MENU_PROPERTY_REGISTERTRUSTS])
                {
                    TrustAuditingVC *trustAuditingVC = [[TrustAuditingVC alloc] init];
                    [self.navigationController pushViewController:trustAuditingVC animated:YES];
                }
                else
                {
                    showMsg(@"您没有相关权限！");
                }
            }
                break;

          case HomePageToNativeJumpTypeMYSeal: {//我的成交
              
                DealController *vc = [[DealController alloc] init];
                vc.isMyDeal = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case HomePageToNativeJumpTypeALLSeal: { //全部成交
                
                DealController *vc = [[DealController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;

            default:
                break;
        }
    }
    
    /*------------Html界面-----------*/
    if (jumpType == JumpToHTML)
    {

        AbsWebViewFilter *webviewFilter = [WebViewFilterUtil instantiation];
        if(![webviewFilter havePermissionWithDescription:entity.mDescription])
        {
            // 提示没有权限
            showMsg(@"您没有相关权限");
            return;
        }
        
        JMWebViewController * con = [[JMWebViewController alloc] init];
        
        con.entity = entity;
        
        [self.navigationController pushViewController:con  animated:YES];

    }

    /*------------外部应用-----------*/
    if (jumpType == JumpToExternalApplication)
    {

    }
}


@end
