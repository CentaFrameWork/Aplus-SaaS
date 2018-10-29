//
//  WebViewFilterUtil.m
//  PanKeTong
//
//  Created by 燕文强 on 16/12/20.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "WebViewFilterUtil.h"
#import "GetEstAgentQuotaApi.h"
#import "AgentQuotaEntity.h"

#import <MJExtension/MJExtension.h>

#import "NSString+MD5Additions.h"

@implementation WebViewFilterUtil

+ (AbsWebViewFilter *)instantiation;
{
    WebViewFilterUtil *webviewFilter = [[WebViewFilterUtil alloc]init];
    webviewFilter.WEBURL_ADVERT_MANAGER_FILTER = @"广告管理";           // 广告管理
    webviewFilter.WEBURL_PUBLISH_PROPERTY_FILTER = @"发布房源";         // 发布房源
    webviewFilter.WEBURL_EDIT_PROPERTY_FILTER = @"编辑房源";            // 编辑房源
    webviewFilter.WEBURL_TRANSACTION_RECORD_FILTER = @"成交进度查询";    // 成交进度查询
    webviewFilter.TITLE_OPERATION_DATA_CENTER = @"数据看板";            // 数据看板
    webviewFilter.WEBSITE_WITH_PROTOCOL = @"WebSiteWithProtocol";       // 拥有协议的网页
    webviewFilter.QRCODE = @"QRCODE";                                   // 广州二维码
    
    return webviewFilter;
}
///
- (BOOL)havePermissionWithDescription:(NSString *)description
{
    if ([description isEqualToString:self.WEBSITE_WITH_PROTOCOL])
    {
        // 我的量化
        return true;
    }
    else if ([description isEqualToString:self.WEBURL_ADVERT_MANAGER_FILTER])
    {
        // 广告管理
        return true;
    }
    else if ([description isEqualToString:self.WEBURL_PUBLISH_PROPERTY_FILTER])
    {
        // 发布房源
        return true;
    }
    else if ([description isEqualToString:self.WEBURL_EDIT_PROPERTY_FILTER])
    {
        // 编辑房源
        return true;
    }
    else if ([description isEqualToString:self.WEBURL_TRANSACTION_RECORD_FILTER])
    {
        // 成交进度查询
        return true;
    }
    else if ([description isEqualToString:self.QRCODE])
    {
        // 广州二维码
        return true;
    }
    return true;

}

///

- (BOOL)havePermissionAccess:(NSDictionary *)urlConfig
{
    NSString *mdescription = [urlConfig objectForKey:@"Description"];
    if ([mdescription isEqualToString:self.WEBSITE_WITH_PROTOCOL])
    {
        // 我的量化
        return true;
    }
    else if ([mdescription isEqualToString:self.WEBURL_ADVERT_MANAGER_FILTER])
    {
        // 广告管理
        return true;
    }
    else if ([mdescription isEqualToString:self.WEBURL_PUBLISH_PROPERTY_FILTER])
    {
        // 发布房源
        return true;
    }
    else if ([mdescription isEqualToString:self.WEBURL_EDIT_PROPERTY_FILTER])
    {
        // 编辑房源
        return true;
    }
    else if ([mdescription isEqualToString:self.WEBURL_TRANSACTION_RECORD_FILTER])
    {
        // 成交进度查询
        return true;
    }
    else if ([mdescription isEqualToString:self.QRCODE])
    {
        // 广州二维码
        return true;
    }
    return true;
}

- (NSString *)getFullUrl:(NSDictionary *)urlConfig;
{
    NSString *title = [urlConfig objectForKey:@"Title"];
    NSString *mdescription = [urlConfig objectForKey:@"Description"];
    NSString *httpUrl;
    
    if ([CommonMethod isLoadNewView])
    {
        httpUrl = [urlConfig objectForKey:@"JumpContent"];
    }
    else
    {
        NSString *jumpContent = [urlConfig objectForKey:@"JumpContent"];
        
        NSString *httpStr = [jumpContent stringByReplacingOccurrencesOfString:@"HttpUrl" withString:@"\"HttpUrl\""];
        NSDictionary *tmpDict = [httpStr jsonDictionaryFromJsonString] ? : [[NSDictionary alloc] init];
        
        httpUrl = [tmpDict objectForKey:@"HttpUrl"];
    }

    // 我的量化
    if([mdescription isEqualToString:self.WEBSITE_WITH_PROTOCOL])
    {
        NSString *userKeyId = [AgencyUserPermisstionUtil getIdentify].uId;
        NSString *userNo = [AgencyUserPermisstionUtil getIdentify].userNo;
        NSString *departmentKeyId = [AgencyUserPermisstionUtil getIdentify].departId;
        NSString *staffno = [CommonMethod getUserdefaultWithKey:UserStaffNumber] ? : @"";
        NSString * corPorationKeyId = FINAL_CORPORATION_KEY_ID;
        
        //时间戳
        NSDate *nowDate = [NSDate date];
        NSTimeInterval timestamp = [nowDate timeIntervalSince1970];
        long unixTimeLong = (long)timestamp;
        NSString *unixTimeStr = [NSString stringWithFormat:@"%@",@(unixTimeLong)];
        // md5加密
        NSString *md5Str = [NSString  stringWithFormat:@"ODC%@%ld",userKeyId,unixTimeLong - 555];
        md5Str = md5Str.md5;

        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:userKeyId forKey:@"userKeyId"];
        [dic setValue:userNo forKey:@"userNo"];
        [dic setValue:departmentKeyId forKey:@"departmentKeyId"];
        [dic setValue:unixTimeStr forKey:@"checkTime"];
        [dic setValue:md5Str forKey:@"secretKey"];
        [dic setValue:@2 forKey:@"sourceType"];
        [dic setValue:@"ios" forKey:@"platform"];
        [dic setValue:staffno forKey:@"staffno"];
        [dic setValue:corPorationKeyId forKey:@"CorPorationKeyId"];
        
        // 数据看板
        if ([title isEqualToString:self.TITLE_OPERATION_DATA_CENTER])
        {
            NSString *cityCode = [CityCodeVersion getCurrentCityCode];
            [dic setValue:cityCode forKey:@"cityCode"];
        }

        NSString *paramJson = [dic mj_JSONString];
        httpUrl = [NSString stringWithFormat:@"%@?urlParams=%@",httpUrl,paramJson];
        httpUrl = [httpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    // 广告管理
    if ([mdescription isEqualToString:self.WEBURL_ADVERT_MANAGER_FILTER])
    {
    }

    // 广州二维码
    if ([mdescription isEqualToString:self.QRCODE])
    {
        NSString *employeeNo = [AgencyUserPermisstionUtil getIdentify].userNo;
        NSString *employeeTel = [CommonMethod getUserdefaultWithKey:APlusUserMobile];
        NSString *employeeName = [AgencyUserPermisstionUtil getIdentify].uName;
        NSString *emoployeeDeptName = [AgencyUserPermisstionUtil getIdentify].departName;

        httpUrl = [NSString stringWithFormat:@"%@employeeno=%@&employeetel=%@&employeename=%@&deptname=%@",
                   httpUrl, employeeNo, employeeTel, employeeName, emoployeeDeptName];
        httpUrl = [httpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    return httpUrl;
}

@end
