//
//  BaseApiDomainUtil.m
//  PanKeTong
//
//  Created by 中原管家 on 2016/12/14.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseApiDomainUtil.h"

#import "AppDelegate.h"

static NSString *HelpUrl;
static NSString *VirtualCallUrl;
static NSString *APlusDomain;
static NSString *DascomUrl;
static NSString *ImageServerUrl;
static NSString *OfficialMessageUrl;
static NSString *HKH5HomeDomain;
static NSString *StaffPhotoUrl;
static NSString *DascomNumber;

@implementation BaseApiDomainUtil


static id apiDomain = nil;


+ (void)shareApiDomain:(Class)cls
{
    @synchronized (self) {
        if (apiDomain == nil) {
            apiDomain = [[cls alloc] init];
        }
    }
}

+ (id)getApiDomain
{
    return apiDomain;
}

#pragma mark - 后台可配置Url
// A＋ url
+ (NSString *)getAPlusDomainUrl
{    
    APlusDomain = [CommonMethod getUserdefaultWithKey:@"APlusDomain"];
    if ([APlusDomain endWith:@"/api/"])
    {
        APlusDomain = [APlusDomain substringToIndex:APlusDomain.length -5];
        [CommonMethod setUserdefaultWithValue:APlusDomain forKey:@"APlusDomain"];
    }
    
    NSLog(@"A+名＝＝＝＝＝＝%@",APlusDomain);
    return APlusDomain;

}

// A+图片服务地址
- (NSString *)getImageServerUrl
{
    ImageServerUrl = [CommonMethod getUserdefaultWithKey:@"ImageServerUrl"];
//    ImageServerUrl = @"http://10.1.30.115:9000/image/upload2";
    NSLog(@"A+房源实勘图片服务＝＝＝＝＝＝%@",ImageServerUrl);
    NSString *corporationKeyId = [NSString stringWithFormat:@"?CorporationKeyId=%@",FINAL_CORPORATION_KEY_ID];
    
    
    return [ImageServerUrl stringByAppendingString:corporationKeyId];
}

// A+客服帮助
- (NSString *)getHelpUrl
{
    HelpUrl = [CommonMethod getUserdefaultWithKey:@"HelpUrl"];

    NSLog(@"A+客服帮助＝＝＝＝＝＝%@",HelpUrl);
    return HelpUrl;
}

// A+虚拟号开关配置url
- (NSString *)getVirtualCallUrl
{
    VirtualCallUrl = [CommonMethod getUserdefaultWithKey:@"VirtualCallUrl"];
    
    NSLog(@"A+虚拟号开关配置url＝＝＝＝＝＝%@",VirtualCallUrl);
    return VirtualCallUrl;
}

// A+拨打/获取/修改 虚拟商url
- (NSString *)getDascomUrl
{
    DascomUrl = [CommonMethod getUserdefaultWithKey:@"DascomUrl"];

    NSLog(@"A+拨打/获取/修改 虚拟商url＝＝＝＝＝＝%@",DascomUrl);
    return DascomUrl;
}

// 获取接入码
- (NSString *)getDascomNumber
{
    DascomNumber = [CommonMethod getUserdefaultWithKey:@"DascomNumber"];

    NSLog(@"虚拟号接入码＝＝＝＝＝＝%@",DascomNumber);
    return DascomNumber;
}

// 官方消息详情
- (NSString *)getMessageUrlWithInfoId:(NSString *)infoId
{
    OfficialMessageUrl = [NSString stringWithFormat:@"%@?infoid=%@",[CommonMethod getUserdefaultWithKey:@"OfficialMessageUrl"],infoId];
    NSLog(@"A+官方消息详情＝＝＝＝＝＝%@",OfficialMessageUrl);
    return OfficialMessageUrl;
}

//  管家首页h5域名
- (NSString *)getHKH5HomeDomain
{
    HKH5HomeDomain = [CommonMethod getUserdefaultWithKey:@"HKH5HomeDomain"];
    
    if (![CommonMethod content:HKH5HomeDomain containsWith:@"common"]) {
        HKH5HomeDomain = [NSString stringWithFormat:@"%@/common/",HKH5HomeDomain];
    }
    
    NSLog(@"管家首页h5域名＝＝＝＝＝＝%@",HKH5HomeDomain);
    
    return HKH5HomeDomain;
}

/// 经纪人头像
- (NSString *)getStaffPhotoUrlWithStaffNo:(NSString *)staffNo
{
    StaffPhotoUrl = [CommonMethod getUserdefaultWithKey:@"StaffPhotoUrl"];
    
    if(!StaffPhotoUrl || [StaffPhotoUrl isEqualToString:@""])
    {
        if ([CityCodeVersion isNanJing])
        {
            StaffPhotoUrl = @"http://pic.centanet.com/nanjing/pic/agent/";
        }
        else
        {
            StaffPhotoUrl = @"http://pic.centanet.com/beijing/pic/agent/";
        }
    }

    NSString *staffPhoto = [NSString stringWithFormat:@"%@%@.jpg",StaffPhotoUrl,staffNo];
    
    NSLog(@"经纪人头像＝＝＝＝＝＝%@",staffPhoto);
    return staffPhoto;
}

// 获取发布房源url
- (NSString *)getPulishPropertyUrl
{
    return [CommonMethod getUserdefaultWithKey:@"PublishPropertyUrl"];
}

#pragma mark - 非后台可配置Url

//  SSO Url
- (NSString *)getSSOUrl
{
    NSString *cityCode = [[NSUserDefaults standardUserDefaults] objectForKey:CityCode];
    NSString *url = [NSString stringWithFormat:@"http://sso.centanet.com/ssoservice/json/reply/PasswordRequest?CompanyCode=%@",cityCode];
    return url;
}

//  登录页面 帮助url
- (NSString *)getCommonHelpURL{
    return @"http://zygj.centanet.com/hkindex/common/help.html";
}

//APP启动页面url
- (NSString *)getAPPLaunchUrl{
    //A+url
    NSString *aplusUrl = NewBaseUrl;
    //拼接启动页URL
    NSString *appLaunchUrl = [NSString stringWithFormat:@"%@/home/ApplaunchPage",aplusUrl];
    return appLaunchUrl;
}

/// 获得北京TQtoken
- (NSString *)getTQTOKEN
{
    return TQ_TOKEN;
}

#pragma mark - 保存／清除 Url

// 保存域名Url
- (void)saveApiDomainInfo:(CityConfigEntity *)cityConfig
{
    if(cityConfig.result.count > 0)
    {
        NSInteger count = cityConfig.result.count;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.infoUrl = @"";
        appDelegate.hideTitle = @"";
        appDelegate.hideDescription = @"";
        
        for (int i = 0; i<count; i++) {
            AppConfigResponseEntity *item = cityConfig.result[i];
            NSString *title = item.title;
            
            //切割url
            NSInteger length = item.jumpContent.length;
            int keyAndOtherLength = 10;
            NSRange range = NSMakeRange(keyAndOtherLength, length-(keyAndOtherLength+2));
            NSString *result = [item.jumpContent substringWithRange: range];
            
            NSLog(@"%@(%@)------%@",item.mdescription,title,result);
           
            if ([title isEqualToString:BeijingInfoKey])
            {
                appDelegate.infoUrl = result;
                appDelegate.hideDescription = item.mdescription;
                appDelegate.hideTitle = title;
            }
            [CommonMethod setUserdefaultWithValue:result forKey:title];
        }
    }
    else
    {
        NSLog(@"没有获取到任何域名配置信息");
    }
}

/// 人脸识别Url
- (NSString *)faceRecogUrl
{
    return @"";
}

//  清除所有域名url
- (void)clearAllDomain
{
    APlusDomain = nil;
    VirtualCallUrl = nil;
    DascomUrl = nil;
    ImageServerUrl = nil;
    OfficialMessageUrl = nil;
    HKH5HomeDomain = nil;
    StaffPhotoUrl = nil;
    HelpUrl = nil;
    DascomNumber = nil;
    
    [CommonMethod setUserdefaultWithValue:nil forKey:@"APlusDomain"];
    [CommonMethod setUserdefaultWithValue:nil forKey:@"VirtualCallUrl"];
    [CommonMethod setUserdefaultWithValue:nil forKey:@"DascomUrl"];
    [CommonMethod setUserdefaultWithValue:nil forKey:@"ImageServerUrl"];
    [CommonMethod setUserdefaultWithValue:nil forKey:@"OfficialMessageUrl"];
    [CommonMethod setUserdefaultWithValue:nil forKey:@"HKH5HomeDomain"];
    [CommonMethod setUserdefaultWithValue:nil forKey:@"StaffPhotoUrl"];
    [CommonMethod setUserdefaultWithValue:nil forKey:@"HelpUrl"];
    [CommonMethod setUserdefaultWithValue:nil forKey:@"DascomNumber"];
    [CommonMethod setUserdefaultWithValue:nil forKey:@"PublishPropertyUrl"];
}

@end
