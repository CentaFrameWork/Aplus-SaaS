//
//  MyLiangHuaBasePresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/27.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "MyLiangHuaBasePresenter.h"


@interface MyLiangHuaBasePresenter ()
{
    MyQuantificationEntity *_infoEntity;
}

@end

@implementation MyLiangHuaBasePresenter

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        _selfView = delegate;
    }
    return self;
}

/// 获得数据源
- (void)getDataSource:(id)quantificationData
{
    _infoEntity = [DataConvert convertDic:quantificationData toEntity:[MyQuantificationEntity class]];
}

/// 新增房源
- (NSString *)getNewPropertysString
{
    return [NSString stringWithFormat:@"%@",@(_infoEntity.newPropertysCount)];
}

/// 新增独家
- (NSString *)getNewOnlyTrustsString
{
    return [NSString stringWithFormat:@"%@",@(_infoEntity.newOnlyTrustsCount)];
}

/// 新增实勘
- (NSString *)getNewRealsString
{
    return [NSString stringWithFormat:@"%@",@(_infoEntity.newRealsCount)];
}

/// 新增客源
- (NSString *)getNewInquirysString
{
    return  [NSString stringWithFormat:@"%@",@(_infoEntity.newInquirysCount)];
}

/// 新增客源跟进
- (NSString *)getNewInquiryFollowsString
{
    return [NSString stringWithFormat:@"%@",@(_infoEntity.newyInquiryFollowsCount)];
}

/// 新增钥匙
- (NSString *)getNewKeysString
{
    return [NSString stringWithFormat:@"%@",@(_infoEntity.newKeysCount)];
}

/// 新增房源跟进
- (NSString *)getNewPropertyFollowsString
{
    return [NSString stringWithFormat:@"%@",@(_infoEntity.newPropertyFollowsCount)];
}

/// 新增带看
- (NSString *)getNewTakeSeesString
{
    return [NSString stringWithFormat:@"%@",@(_infoEntity.newTakeSeesCount)];
}

/// 新增独家/新增签约
- (NSString *)getAddOnlyTrustName
{
    return @"新增独家";
}
@end
