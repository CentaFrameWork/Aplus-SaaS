//
//  GetTJQuantificationSubEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/9/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "SubBaseEntity.h"

///天津二级实体
@interface GetTJQuantificationSubEntity : SubBaseEntity

/*
 userKeyId - 用户keyId (String)
 employeeName - 用户名称 (String)
 departmentKeyId - 部门KeyId (String)
 departmentName - 部门名称 (String)
 departmentNo - 部门编号 (String)
 startDate - 开始日期 (String)
 endDate - 结束日期 (String)
 level - 部门层级 (String)
 dateType - 日期类型 (String)
 newInquirysCountRent - 新增租客 (String)
 newInquirysCountSale - 新增售客 (String)
 dragInquirysCountRent - 公客池捞租客 (String)
 dragInquirysCountSale - 公客池捞售客 (String)
 inquirysCountSaleSum - 售客 (String)
 inquirysCountRentSum - 租客 (String)
 newPropertysCountRent - 新增租房源 (String)
 TransferPropertysCountRent - 非有效转有效租房源 (String)
 PerformancePropertysCountRent - 业绩分成租房源 (String)
 newPropertysCountSale - 新增售房源 (String)
 TransferPropertysCountSale - 非有效转有效售房源 (String)
 PerformancePropertysCountSale - 业绩分成售房源 (String)
 propertysCountRentSum - 租房 (String)
 propertysCountSaleSum - 售房 (String)
 keysRent - 钥匙 (String)
 exclusive - 独家 (String)
 realSurvey - 实勘 (String)
 propertyFllow - 房源跟进 (String)
 takeSeeRent - 租带看 (String)
 takeSeeSale - 售带看 (String)
 takeSeeSum - 带看 (String)
 inquiryFllow - 客源跟进 (String)
 Commission - 佣金 (String)
 officialWebsite - 官网 (String)
 clone - 克隆 (String)
 changeCount - 叫价申请 (String)
 browsePhoneCount - 查看业主电话 (String)
 currentDay - 日期 (String)
  */
//@property (nonatomic,copy)NSString *userKeyId;//用户keyId
//@property (nonatomic,copy)NSString *employeeName;//用户名称
@property (nonatomic,copy)NSString *departmentKeyId;//部门KeyId
@property (nonatomic,copy)NSString *departmentName;//部门名称
@property (nonatomic,copy)NSString *departmentNo;//部门编号
//@property (nonatomic,copy)NSString *startDate;//开始日期
//@property (nonatomic,copy)NSString *endDate;//结束日期;
@property (nonatomic,copy)NSString *level;//部门层级;
@property (nonatomic,copy)NSString *dateType;//日期类型;
@property (nonatomic,copy)NSString *tjNewInquirysCountRent;//新增租客;
@property (nonatomic,copy)NSString *tjNewInquirysCountSale;//新增售客;
@property (nonatomic,copy)NSString *dragInquirysCountRent;//公客池捞租客;
@property (nonatomic,copy)NSString *dragInquirysCountSale;//公客池捞售客;
@property (nonatomic,copy)NSString *inquirysCountSaleSum;//售客;
@property (nonatomic,copy)NSString *inquirysCountRentSum;//租客;
@property (nonatomic,copy)NSString *tjNewPropertysCountRent;//新增租房源;
//@property (nonatomic,copy)NSString *transferPropertysCountRent;//非有效转有效租房源;
//@property (nonatomic,copy)NSString *performancePropertysCountRent;//业绩分成租房源;
@property (nonatomic,copy)NSString *tjNewPropertysCountSale;//新增售房源;
//@property (nonatomic,copy)NSString *transferPropertysCountSale;//非有效转有效售房源;
//@property (nonatomic,copy)NSString *performancePropertysCountSale;//业绩分成售房源;
@property (nonatomic,copy)NSString *propertysCountRentSum;//租房;
@property (nonatomic,copy)NSString *propertysCountSaleSum;//售房;
@property (nonatomic,copy)NSString *keysRent;//钥匙;
@property (nonatomic,copy)NSString *exclusive;//独家;
@property (nonatomic,copy)NSString *realSurvey;//实勘;
@property (nonatomic,copy)NSString *propertyFllow;//房源跟进;
@property (nonatomic,copy)NSString *takeSeeRent;//租带看;
@property (nonatomic,copy)NSString *takeSeeSale;//售带看;
@property (nonatomic,copy)NSString *takeSeeSum;//带看;
@property (nonatomic,copy)NSString *inquiryFllow;//客源跟进
@property (nonatomic,strong)NSNumber *commission;//佣金;
@property (nonatomic,copy)NSString *officialWebsite;//官网;
@property (nonatomic,copy)NSString *clone;//克隆;
@property (nonatomic,copy)NSString *changeCount;//叫价申请;
@property (nonatomic,copy)NSString *browsePhoneCount;//查看业主电话;
//@property (nonatomic,copy)NSString *currentDay;//日期;


@end
