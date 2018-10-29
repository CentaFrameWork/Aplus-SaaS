//
//  APP_Api.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#ifndef APP_Api_h
#define APP_Api_h


#ifdef DEBUG


//#define NewHousekeeperUrl    @"https://jmssoapi.yuan-cui.com/api/"
//#define NewBaseUrl    [BaseApiDomainUtil getAPlusDomainUrl]
#define NewHousekeeperUrl    @"http://10.1.30.118:32121/api/"
#define NewBaseUrl    @"http://10.1.30.118:32061"
#else


//#define NewHousekeeperUrl    @"https://jmssoapi.yuan-cui.com/api/"
//#define NewBaseUrl  [BaseApiDomainUtil getAPlusDomainUrl]

#define NewHousekeeperUrl    @"http://10.1.30.118:32121/api/"
#define NewBaseUrl    @"http://10.1.30.118:32061"


#endif





#pragma mark - 数据接口
#define AipPropertyWarZone              [NSString stringWithFormat:@"%@/api/property/war-zone",NewBaseUrl]                      // 通盘房源列表
#define AipPropertyAddFollow            [NSString stringWithFormat:@"%@/api/property/add-follow",NewBaseUrl]                    // 房源状态修改
#define AipPropertyKey                  [NSString stringWithFormat:@"%@/api/property/key",NewBaseUrl]                           // 查看钥匙
#define AipPropertykeyModify            [NSString stringWithFormat:@"%@/api/property/key-modify",NewBaseUrl]                    // 编辑钥匙
#define AipPropertyPriceModify          [NSString stringWithFormat:@"%@/api/property/price-modify",NewBaseUrl]                  // 调价
#define WJContactListAPI                [NSString stringWithFormat:@"%@/api/property/trustors",NewBaseUrl]                      // 联系人列表接口
#define AipPropertyFollowMarktop        [NSString stringWithFormat:@"%@/api/property/follow-marktop",NewBaseUrl]                // 置顶跟进
#define AipPropertyFollowMarktopCancel  [NSString stringWithFormat:@"%@/api/property/follow-marktop-cancel",NewBaseUrl]         // 取消置顶
#define AipPropertyFollows              [NSString stringWithFormat:@"%@/api/property/follows",NewBaseUrl]                       // 更多跟进
#define AipPropertyCreateTrustor        [NSString stringWithFormat:@"%@/api/property/create-trustor",NewBaseUrl]                // 新增联系人
#define WJDealListAPI                   [NSString stringWithFormat:@"%@/api/property/property-transaction-record",NewBaseUrl]   // 成交记录
#define WJAllDealAPI                    [NSString stringWithFormat:@"%@/api/property/property-transaction-list",NewBaseUrl]     // 我的成交和全部成交列表
#define AipPropertyTrustorDetail        [NSString stringWithFormat:@"%@/api/property/TrustorDetail",NewBaseUrl]                 // 根据联系人KeyId获取业主联系人信息
#define AipPropertyEditTrustor          [NSString stringWithFormat:@"%@/api/property/edit-trustor",NewBaseUrl]                  // 修改联系人
#define AipPropertyRemoveTrustor        [NSString stringWithFormat:@"%@/api/property/remove-trustor",NewBaseUrl]                // 删除联系人
#define AipPropertyDealDetail           [NSString stringWithFormat:@"%@/api/property/property-transaction-details",NewBaseUrl]  // 成交详情页
#define AipPropertyGetDealImage         [NSString stringWithFormat:@"%@/api/property/get-property-transaction-file",NewBaseUrl] // 获取图片
#define AipPropertyUploadDealImage      [NSString stringWithFormat:@"%@/api/property/add-property-transaction-file",NewBaseUrl] // 上传图片
#define ApiInquiryAddTakeseeFollow      [NSString stringWithFormat:@"%@/api/Inquiry/add-takesee-follow",NewBaseUrl]   // 新增带看

#define ApiGetPhotos      [NSString stringWithFormat:@"%@/api/property/real-survey-photos",NewBaseUrl] //获取图片
#define ApiInquiryAll      [NSString stringWithFormat:@"%@/api/inquiry/all",NewBaseUrl]  // 获取客户


#define QRCode_sacn      [NSString stringWithFormat:@"%@/api/permission/qrcode-scan",NewBaseUrl]
#define QRCode_login     [NSString stringWithFormat:@"%@/api/permission/confirm-login",NewBaseUrl]


#define Get_VerifyCode      [NSString stringWithFormat:@"%@sendmessage",NewHousekeeperUrl]
#define Login_VerifyCode     [NSString stringWithFormat:@"%@validmessagecode",NewHousekeeperUrl]
#endif /* APP_Api_h */






































