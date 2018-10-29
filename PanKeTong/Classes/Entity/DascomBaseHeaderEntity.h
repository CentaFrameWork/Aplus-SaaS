//
//  DascomBaseHeaderEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@interface DascomBaseHeaderEntity : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString  *mResultCode;
@property (nonatomic, strong) NSString  *mDiagnostic;

@end
