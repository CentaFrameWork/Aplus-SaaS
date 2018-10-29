//
//  PropertyTagEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface PropertyTagEntity : SubBaseEntity

@property (nonatomic,strong) NSString *tagName;
@property (nonatomic,strong) NSString *tagNo;
@property (nonatomic,strong) NSString *highLight;
@property (nonatomic,strong) NSString *styleColor;
@property (nonatomic,strong) NSString *extendAttr;
@property (nonatomic,strong) NSString *seq;

@end
