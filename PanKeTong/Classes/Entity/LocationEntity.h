//
//  LocationEntity.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/25.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseEntity.h"
#import "CLLocation+YCLocation.h"

@interface LocationEntity : BaseEntity

@property(nonatomic,copy)NSString *addressName;

@property(nonatomic,copy)NSString *addressDetail;

@property(nonatomic,assign)CLLocationCoordinate2D location;
@end
