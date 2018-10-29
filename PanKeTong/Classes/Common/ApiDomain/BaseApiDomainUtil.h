//
//  BaseApiDomainUtil.h
//  PanKeTong
//
//  Created by 中原管家 on 2016/12/14.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TQ_TOKEN                         @"957f60181c76313c69558900258672a9";        // TQ虚拟号正式环境
#define TQ_TEST_TOKEN                    @"2a319372ac504d38ac0f0af39d581799"         // TQ虚拟号测试环境

@interface BaseApiDomainUtil : NSObject

+ (void)shareApiDomain:(Class)cls;

+ (id)getApiDomain;

/*
 * 管家url (决定环境)
 */
- (NSString *)getHouseKeeperUrl;

#pragma mark - 后台可配置Url

/*
 * A+ Url
 */
+ (NSString *)getAPlusDomainUrl;

/*
 * 虚拟号Url
 */
- (NSString *)getVirtualCallUrl;

/*
 * 拨打/获取/修改 虚拟商Url
 */
- (NSString *)getDascomUrl;

/*
 * A+图片服务地址
 */
- (NSString *)getImageServerUrl;

/*
 * 官方消息详情
 */
- (NSString *)getMessageUrlWithInfoId:(NSString *)infoId;

/**
 *  获取首页 & 客户帮助 Url
 */
- (NSString *)getHKH5HomeDomain;

/*
 *  获取经纪人头像url
 */
- (NSString *)getStaffPhotoUrlWithStaffNo:(NSString *)staffNo;

/**
 *  A+客服帮助
 *
 *  @return 客服帮助url
 */
- (NSString *)getHelpUrl;

//获取接入码
- (NSString *)getDascomNumber;



#pragma mark - 非后台可配置Url

/*
 * SSO Url
 */
- (NSString *)getSSOUrl;

/*
 *  登录页面 帮助url
 */
- (NSString *)getCommonHelpURL;


/*
 *  APP启动页面url
 */
- (NSString *)getAPPLaunchUrl;

#pragma mark - Function

/*
 *  设置是否为获取动态Url
 */
//- (void)setDynamic:(BOOL)dynamic;

/*
 *  保存域名url
 */
- (void)saveApiDomainInfo:(CityConfigEntity *)cityConfig;

/*
 *  清除所有域名url
 */
- (void)clearAllDomain;

/*
 *  获取发布房源url
 */
- (NSString *)getPulishPropertyUrl;

/// 北京获取TQTOKEN
- (NSString *)getTQTOKEN;

/// 人脸识别url
- (NSString *)faceRecogUrl;

@end
