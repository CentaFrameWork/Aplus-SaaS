//
//  AllListEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "SubGoOutListEntity.h"
#import "SubTakingSeeEntity.h"
#import "SubAlertEventEntity.h"


@interface AllListEntity : AgencyBaseEntity

@property (nonatomic,strong)NSArray *goOutMessages;//外出

@property (nonatomic,strong)NSArray *takingSees;//约看

@property (nonatomic,strong)NSArray *takeSees;//带看

//@property (nonatomic,strong)NSArray *alertEvents;//提醒

@end
