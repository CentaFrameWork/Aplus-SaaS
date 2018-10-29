//
//  WJDealListModel.h
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/20.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJDealListModel : NSObject

@property (nonatomic, copy) NSString *TransactionNode;//成交流程
@property (nonatomic, strong) NSString *KeyId;//成交标示
@property (nonatomic, strong) NSString *TrustorName;//业主姓名
@property (nonatomic, strong) NSString *TransactionNo;//成交编号
@property (nonatomic, strong) NSString *CustomerName;//买房客户名称
@property (nonatomic, strong) NSString *TransactionType;//成交类型
@property (nonatomic, strong) NSString *CreateTime;//事件
@property (nonatomic, strong) NSString *PropertyNo;//房源编号
@property (nonatomic, strong) NSString *EstateName;//物业地址
-(WJDealListModel *)initDic:(NSDictionary *)dic;

@end





























