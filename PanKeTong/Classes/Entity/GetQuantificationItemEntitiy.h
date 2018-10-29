//
//  getQuantificationItemEntitiy.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/5/6.
//  Copyright © 2016年 苏军朋. All rights reserved.


#import "SubBaseEntity.h"

///深圳二级实体
@interface GetQuantificationItemEntitiy : SubBaseEntity

@property (nonatomic,strong) NSString *propertysCountSaleSum;   //售房
@property (nonatomic,strong) NSString *propertysCountRentSum;   //租房
@property (nonatomic,strong) NSString *inquirysCountSaleSum;    //授客
@property (nonatomic,strong) NSString *inquirysCountRentSum;    //租客
@property (nonatomic,strong) NSString *propertyFllow;           //房跟
@property (nonatomic,strong) NSString *inquiryFllow;            //客跟
@property (nonatomic,strong) NSString *takeSeeSale;             //售带
@property (nonatomic,strong) NSString *takeSeeRent;             //租带
@property (nonatomic,strong) NSString *keysRent;                //钥匙
@property (nonatomic,strong) NSString *exclusiveEntrustCount;   //压房
@property (nonatomic,strong) NSString *exclusive;               //签约
@property (nonatomic,strong) NSString *realSurvey;              //实勘
@property (nonatomic,strong) NSString *changeCount;             //叫价次数
@property (nonatomic,strong) NSString *browsePhoneCount;        //看业主
@property (nonatomic,strong) NSString *dragInquirysCountSale;   //公转私售客
@property (nonatomic,strong) NSString *dragInquirysCountRent;   //公转私租客
@property (nonatomic,strong) NSString *virtualNumberCount;      //拨通
@property (nonatomic,strong) NSString *channelInquiryCount;     //400
@property (nonatomic,strong) NSString *deptKeyId;               //员工部门KEYID
@property (nonatomic,strong) NSString *departmentName;          //部门名称
@property (nonatomic,strong) NSString *level;                   //等级
@property (nonatomic,strong) NSString *departmentNo;            //部门编号
@property (nonatomic,strong) NSString *shortName;               //短名

@end
