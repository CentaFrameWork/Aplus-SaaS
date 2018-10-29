//
//  QueryPhoneAddressUtil.h
//  PanKeTong
//
//  Created by 燕文强 on 16/2/14.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneAddressEntity.h"
#import "ChannelCallEntity.h"
#import "SinglePhoneAddressEntity.h"
#import "CommonMethod.h"
#import "RequestManager.h"

@protocol QueryResult <NSObject>

- (void)queryPhoneAddressResult:(NSArray *)result;

@end


@interface QueryPhoneAddressUtil : NSObject<ResponseDelegate>

@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,assign) id <QueryResult> delegate;


#pragma mark - QueryPhoneAddressUrl(获取手机号码归属地)
+ (QueryPhoneAddressUtil *)shareQueryPhoneAddressUtil;

/**
 *  根据电话查询电话地址
 */
- (void)requestQueryPhoneAddressWithPhones:(NSString *)phones;

/**
 *  获取渠道来电的电话
 */
+ (NSString *)extractPhoneFromChannelCall:(ChannelCallEntity *)entity;


@end
