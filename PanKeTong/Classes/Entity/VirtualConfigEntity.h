//
//  VirtualConfigEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MTLModel.h"

@interface VirtualConfigEntity : MTLModel<MTLJSONSerializing>

@property (nonatomic,assign) NSInteger virtualCall;
@property (nonatomic,assign) NSInteger callLimit;

@end
