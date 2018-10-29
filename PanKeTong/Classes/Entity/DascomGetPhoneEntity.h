//
//  DascomGetPhoneEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "DascomGetPhoneBodyEntity.h"
#import "DascomGetPhoneHeaderEntity.h"

@interface DascomGetPhoneEntity : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) DascomGetPhoneHeaderEntity *mHeader;
@property (nonatomic,strong) NSArray *mBody;
@property (nonatomic,assign) NSInteger tag;

@end
