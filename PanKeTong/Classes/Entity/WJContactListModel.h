//
//  WJContactListModel.h
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/14.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJContactListModel : NSObject
@property (nonatomic, copy) NSString *KeyId;//对象kid
@property (nonatomic, copy) NSString *TrustorName;//委托人姓名
@property (nonatomic, strong) NSString *MaritalStatusKeyId;//婚姻情况
@property (nonatomic, strong) NSString *Mobile;//联系方式
@property (nonatomic, strong) NSString *TrustorTypeKeyId;//委托人类型
@property (nonatomic, strong) NSString *TrustorGenderKeyId;//委托人性别
@property (nonatomic, strong) NSString *Remark;     // 备注
@property (nonatomic, strong) NSString *Tel;//联系方
@property (nonatomic, strong) NSString *telphone1;
@property (nonatomic, strong) NSString *telphone2;
@property (nonatomic, strong) NSString *telphone3;

@property (nonatomic, assign) BOOL isEnable;    // 是否查看备注

-(WJContactListModel *)initDic:(NSDictionary *)dic;



@end
