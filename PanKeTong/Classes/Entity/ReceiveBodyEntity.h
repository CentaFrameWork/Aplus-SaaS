//
//  ReceiveBodyEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MTLModel.h"

#import "MTLJSONAdapter.h"

@interface ReceiveBodyEntity : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) NSString *mysisdn;

@end