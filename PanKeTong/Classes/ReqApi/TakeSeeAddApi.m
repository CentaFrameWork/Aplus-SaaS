//
//  TakeSeeAddApi.m
//  PanKeTong
//
//  Created by 张旺 on 16/12/15.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "TakeSeeAddApi.h"
#import "SelectPropertyEntity.h"
@implementation TakeSeeAddApi

- (NSDictionary *)getBody
{
    NSDictionary *paramaDic;
    NSDictionary *dic;
    //    if ([CommonMethod isRequestNewApiAddress]) {
    
    NSMutableArray *mArr = [NSMutableArray array];
    //陈行修改138bug，注释掉
    //NSMutableDictionary *muDic = [[NSMutableDictionary alloc] init];
    for (SelectPropertyEntity *entity in _selectPropertyArr) {
        NSString *content = entity.content;
        NSString *idStr = entity.propertyEntity.keyId;
        //陈行修改138bug，新增
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc] init];
        
        [muDic setValue:content forKey:@"Content"];
        [muDic setValue:idStr forKey:@"PropertyKeyId"];
        [mArr addObject:muDic];
    }
    
    SysParamItemEntity *genderSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUSTOMER_CONTACT_TYPE];
    NSString *followCode;
    NSString *followKeyId;
    for (SelectItemDtoEntity *entity in genderSysParamItemEntity.itemList) {
        if ([entity.itemText isEqualToString:@"录入带看"]) {
            followCode = entity.itemCode;
            followKeyId = entity.itemValue;
        }
    }
    NSLog(@"mArr===%@==_msgUserKeyIds=== %@   _msgDeptKeyIds===%@  ",mArr,_msgUserKeyIds,_msgDeptKeyIds);
    dic = @{
            @"AgreementNo":_agreementNo == nil?@"":_agreementNo,
            @"RentPrice":_rentPrice == nil?@"":_rentPrice,
            @"ReserveKeyId":_reserveKeyId == nil?@"":_reserveKeyId,
            @"SalePrice":_salePrice== nil?@"":_salePrice,
            @"SeePropertyType":_seePropertyType==nil?@"":_seePropertyType,
            @"TakeSeeTime":_takeSeeTime==nil?@"":_takeSeeTime,
            @"LookWithKeyId":_lookWithKeyId == nil?@"":_lookWithKeyId,
            @"AttachmentName":_attachmentName == nil?@"":_attachmentName,
            @"AttachmentPath":_attachmentPath == nil?@"":_attachmentPath,
            @"Content":_content == nil?@"":_content,
            @"ContentNext":_contentNext?_contentNext:@"",
            @"CustumerKeyId":_custumerKeyId == nil?@"":_custumerKeyId,
            @"InquiryKeyId":_inquiryKeyId==nil?@"":_inquiryKeyId,
            @"PropertyKeyId":_propertyKeyId==nil?@"":_propertyKeyId,
            @"MsgUserKeyIds":_msgUserKeyIds == nil?@[]:_msgUserKeyIds,
            @"MsgDeptKeyIds":_msgDeptKeyIds == nil?@[]:_msgDeptKeyIds,
            @"MsgTime":_msgTime == nil?@"":_msgTime,
            @"FollowTypeKeyId":followKeyId==nil?@"":followKeyId,
            @"FollowTypeCode":followCode==nil?@"":followCode,
            @"TakeSeeContent":mArr==nil?@"":mArr,
            @"LookWithUserName" : _lookWithUserName ? : @"",
            };
    NSLog(@"dic===%@",dic);
    
    paramaDic = @{
                  @"TakeSees":@[dic]
                  };
    
    //    }
    
    //    else
    //    {
    //        dic = @{
    //                @"AgreementNo":_agreementNo == nil?@"":_agreementNo,
    //                @"RentPrice":_rentPrice,
    //                @"ReserveKeyId":_reserveKeyId == nil?@"":_reserveKeyId,
    //                @"SalePrice":_salePrice,
    //                @"SeePropertyType":_seePropertyType,
    //                @"TakeSeeTime":_takeSeeTime,
    //                @"LookWithKeyId":_lookWithKeyId == nil?@"":_lookWithKeyId,
    //                @"AttachmentName":_attachmentName == nil?@"":_attachmentName,
    //                @"AttachmentPath":_attachmentPath == nil?@"":_attachmentPath,
    //                @"Content":_content == nil?@"":_content,
    //                @"CustumerKeyId":_custumerKeyId == nil?@"":_custumerKeyId,
    //                @"InquiryKeyId":_inquiryKeyId,
    //                @"PropertyKeyId":_propertyKeyId,
    //                @"MsgUserKeyIds":_msgUserKeyIds == nil?@[]:_msgUserKeyIds,
    //                @"MsgDeptKeyIds":_msgDeptKeyIds == nil?@[]:_msgDeptKeyIds,
    //                @"MsgTime":_msgTime == nil?@"":_msgTime
    ////                @"TakeSeeContent":mArr
    //                };
    //        paramaDic = @{
    //                      @"InquiryTakeSeeFollows":@[dic]
    //                      };
    //
    //    }
    
    return paramaDic;
    
}

- (NSString *)getPath {
    
    
    return @"Inquiry/add-takesee-follow";
    
}

- (Class)getRespClass {
    return [AgencyBaseEntity class];
}



@end
