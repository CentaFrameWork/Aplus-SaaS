//
//  PhoneAddressInfo.h
//  PanKeTong
//
//  Created by 燕文强 on 16/2/14.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface PhoneAddressInfo : SubBaseEntity

//"areacode": "0571",
//"city": "杭州",
//"operator": "中国移动",
//"phone": "13588857364",
//"postcode": "310000",
//"province": "浙江"

@property (nonatomic,strong) NSString *areacode;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *operator;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *postcode;
@property (nonatomic,strong) NSString *province;

@end
