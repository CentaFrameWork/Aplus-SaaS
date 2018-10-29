//
//  SinglePhoneAddressEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 16/2/15.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"
#import "PhoneAddressInfo.h"

@interface SinglePhoneAddressEntity : SubBaseEntity

@property (nonatomic,assign) NSInteger error;
@property (nonatomic,strong) NSString *msg;
@property (nonatomic,strong) PhoneAddressInfo *data;

@end
