//
//  AbsWebViewFilter.h
//  PanKeTong
//
//  Created by 燕文强 on 16/12/20.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"

@interface AbsWebViewFilter : NSObject
// 描述关键字
@property (nonatomic,strong) NSString *WEBURL_ADVERT_MANAGER_FILTER;        // 广告管理
@property (nonatomic,strong) NSString *WEBURL_PUBLISH_PROPERTY_FILTER;      // 发布房源
@property (nonatomic,strong) NSString *WEBURL_EDIT_PROPERTY_FILTER;         // 编辑房源
@property (nonatomic,strong) NSString *WEBURL_TRANSACTION_RECORD_FILTER;    // 成交进度查询
@property (nonatomic, copy) NSString *WEBSITE_WITH_PROTOCOL;                // 有协议的网页
@property (nonatomic, copy) NSString *QRCODE;                               // 广州二维码

@property (nonatomic,strong) NSString *TITLE_OPERATION_DATA_CENTER;         // 数据看板
+ (AbsWebViewFilter *)instantiation;


/**
 * 该操作是否有权限
 *
 * @param urlConfig
 * @return
 */
- (BOOL)havePermissionWithDescription:(NSString *)description;

- (BOOL)havePermissionAccess:(NSDictionary *)urlConfig;

/**
 * 拼接后的完整Url地址
 *
 * @return
 */
- (NSString *)getFullUrl:(NSDictionary *)urlConfig;


@end
