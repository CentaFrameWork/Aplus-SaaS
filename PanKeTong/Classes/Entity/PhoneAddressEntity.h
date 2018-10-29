//
//  PhoneAddressEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 16/2/14.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneAddressInfo.h"

@interface PhoneAddressEntity : SubBaseEntity

@property (nonatomic,assign) NSInteger error;
@property (nonatomic,strong) NSString *msg;
@property (nonatomic,strong) NSArray *data;

@end
