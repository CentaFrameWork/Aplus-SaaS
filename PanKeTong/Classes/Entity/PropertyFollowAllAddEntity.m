//
//  PropertyFollowAllAddEntity.m
//  PanKeTong
//
//  Created by TailC on 16/4/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PropertyFollowAllAddEntity.h"

@implementation PropertyFollowAllAddEntity


-(instancetype)init
{
	self = [super init];
	if (self) {
		self.PropertyKeyId = @"";
//		self.FollowType = -1;
		self.ContactsName = [NSArray new];
		self.InformDepartsName = [NSArray new];
		self.FollowContent = @"";
		self.Mobile = @"";
		self.TrustorName = @"";
//		self.TrustorTypeKeyId = @"";
//		self.TrustorGenderKeyId = @"";
		self.TrustorRemark = @"";
		self.telphone1 = @"";
		self.telphone2 = @"";
		self.telphone3 = @"";
		self.TrustType = @"";
		self.OpeningType = @"";
		self.OpeningPersonName = @"";
		self.OpeningDepName = @"";
		self.RentPrice = @"";
		self.RentPer = @"";
		self.SalePrice = @"";
		self.SalePer = @"";
		self.OpeningPersonKeyId = @"";
		self.OpeningDepKeyId = @"";
		self.TargetDepartmentKeyId = @"";
		self.TargetUserKeyId = @"";
		self.MsgUserKeyIds = [NSArray new];
		self.MsgDeptKeyIds = [NSArray new];
		self.MsgTime = @"";
		self.KeyId = @"";
		self.IsMobileRequest = @"true";
        self.MobileAttribution = @"";
	}
	return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
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
			 @"PropertyKeyId":@"PropertyKeyId",
			 @"FollowType":@"FollowType",
			 @"ContactsName":@"ContactsName",
			 @"InformDepartsName":@"InformDepartsName",
			 @"FollowContent":@"FollowContent",
			 @"Mobile":@"Mobile",
			 @"TrustorName":@"TrustorName",
			 @"TrustorTypeKeyId":@"TrustorTypeKeyId",
			 @"TrustorGenderKeyId":@"TrustorGenderKeyId",
			 @"TrustorRemark":@"TrustorRemark",
			 @"telphone1":telPhone1,
			 @"telphone2":telPhone2,
			 @"telphone3":telPhone3,
			 @"TrustType":@"TrustType",
			 @"OpeningType":@"OpeningType",
			 @"OpeningPersonName":@"OpeningPersonName",
			 @"OpeningDepName":@"OpeningDepName",
			 @"RentPrice":@"RentPrice",
			 @"RentPer":@"RentPer",
			 @"SalePrice":@"SalePrice",
			 @"SalePer":@"SalePer",
			 @"OpeningPersonKeyId":@"OpeningPersonKeyId",
			 @"OpeningDepKeyId":@"OpeningDepKeyId",
			 @"TargetDepartmentKeyId":@"TargetDepartmentKeyId",
			 @"TargetUserKeyId":@"TargetUserKeyId",
			 @"MsgUserKeyIds":@"MsgUserKeyIds",
			 @"MsgDeptKeyIds":@"MsgDeptKeyIds",
			 @"MsgTime":@"MsgTime",
			 @"KeyId":@"KeyId",
			 @"IsMobileRequest":@"IsMobileRequest",
             @"MobileAttribution":@"MobileAttribution"
    };
	
}

@end
