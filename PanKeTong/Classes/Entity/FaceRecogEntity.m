//
//  FaceRecogEntity.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/12/9.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FaceRecogEntity.h"

@implementation FaceRecogEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [self getBaseFieldWithOthers:@{@"result":@"Result"}];
}

@end
