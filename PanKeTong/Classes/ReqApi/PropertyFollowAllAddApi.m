//
//  PropertyFollowAllAddApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PropertyFollowAllAddApi.h"

@implementation PropertyFollowAllAddApi

- (NSDictionary *)getBody
{
    if (self.propertyFollowAllAddType == AddContact)
    {
        //新增联系人
        NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:_entity];
        return dic;
    }
    else if (self.propertyFollowAllAddType == AddBidding)
    {
        //新增叫价
        NSMutableDictionary *dict = @{
                                      @"PropertyKeyId":_entity.PropertyKeyId,
                                      @"FollowType":@(_entity.FollowType),
                                      @"TrustType":_entity.TrustType,
                                      @"IsMobileRequest":@"true",
                                      @"FollowContent":_entity.FollowContent
                                      }.mutableCopy;

        if (_entity.ContactsName.count > 0)
        {
            [dict setObject:_entity.ContactsName forKey:@"ContactsName"];
            [dict setObject:_entity.MsgUserKeyIds forKey:@"MsgUserKeyIds"];
        }
        else
        {
            NSArray *arr = [NSArray new];
            [dict setObject:arr forKey:@"ContactsName"];
            [dict setObject:arr forKey:@"MsgUserKeyIds"];
        }

        if (_entity.InformDepartsName.count > 0 )
        {
            [dict setObject:_entity.InformDepartsName forKey:@"InformDepartsName"];
            [dict setObject:_entity.MsgDeptKeyIds forKey:@"MsgDeptKeyIds"];
        }
        else
        {
            NSArray *arr = [NSArray new];
            [dict setObject:arr forKey:@"InformDepartsName"];
            [dict setObject:arr forKey:@"MsgDeptKeyIds"];
        }


        if (_entity.RentPrice)
        {
            [dict setObject:_entity.RentPrice forKey:@"RentPrice"];
            if (!_entity.RentPer)
            {
                [dict setObject:@"" forKey:@"RentPer"];
            }
            else
            {
                [dict setObject:_entity.RentPer forKey:@"RentPer"];
            }
        }
        
        if (_entity.SalePrice)
        {
            [dict setObject:_entity.SalePrice forKey:@"SalePrice"];
            if (!_entity.SalePer)
            {
                [dict setObject:@"" forKey:@"SalePer"];
            }
            else
            {
                [dict setObject:_entity.SalePer forKey:@"SalePer"];
            }
        }
        
        if (_entity.MsgTime)
        {
            [dict setObject:_entity.MsgTime forKey:@"MsgTime"];
        }

        return dict;
    }
    
    _entity.MsgTime = _entity.MsgTime ? _entity.MsgTime : @"";
    _addTrustorSortNum = _addTrustorSortNum ? _addTrustorSortNum : [NSArray array];
    _trustorKeyIdList = _trustorKeyIdList ? _trustorKeyIdList : [NSArray array];
    
    NSString *telPhone1 = @"telphone1";
    NSString *telPhone2 = @"telphone2";
    NSString *telPhone3 = @"telphone3";
    
    if ([CommonMethod isRequestFinalApiAddress])
    {
        telPhone1 = @"Telphone1";
        telPhone2 = @"Telphone2";
        telPhone3 = @"Telphone3";
    }
    
    return @{
             @"propertyKeyId":_entity.PropertyKeyId,
             @"FollowType":[NSString stringWithFormat:@"%ld",_entity.FollowType],
             @"ContactsName":_entity.ContactsName,
             @"InformDepartsName":_entity.InformDepartsName,
             @"FollowContent":_entity.FollowContent,
             @"Mobile":_entity.Mobile,
             @"TrustorName":_entity.TrustorName,
             @"TrustorTypeKeyId":_entity.TrustorTypeKeyId,
             @"TrustorGenderKeyId":_entity.TrustorGenderKeyId,
             @"TrustorRemark":_entity.TrustorRemark,
             telPhone1:_entity.telphone1,
             telPhone2:_entity.telphone2,
             telPhone3:_entity.telphone3,
             @"TrustType":_entity.TrustType,
             @"OpeningType":_entity.OpeningType,
             @"OpeningPersonName":_entity.OpeningPersonName,
             @"OpeningDepName":_entity.OpeningDepName,
             @"RentPrice":_entity.RentPrice,
             @"RentPer":_entity.RentPer,
             @"SalePrice":_entity.SalePrice,
             @"SalePer":_entity.SalePer,
             @"OpeningPersonKeyId":_entity.OpeningPersonKeyId,
             @"OpeningDepKeyId":_entity.OpeningDepKeyId,
             @"TargetDepartmentKeyId":_entity.TargetDepartmentKeyId,
             @"TargetUserKeyId":_entity.TargetUserKeyId,
             @"MsgUserKeyIds":_entity.MsgUserKeyIds,
             @"MsgDeptKeyIds":_entity.MsgDeptKeyIds,
             @"MsgTime":_entity.MsgTime,
             @"KeyId":_entity.KeyId,
             @"NewAddTrustorSortNum":_addTrustorSortNum,
             @"TrustorKeyIdList":_trustorKeyIdList
             };
}


//添加跟进(洗盘，新开盘,新增联系人,信息补充,叫价)
- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"property/add-follow";
    }
    return @"WebApiProperty/property-follow-all-add";

}


- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}

@end
