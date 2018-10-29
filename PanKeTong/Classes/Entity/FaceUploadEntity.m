//
//  FaceUploadEntity.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/12/8.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FaceUploadEntity.h"

@implementation FaceUploadEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [self getBaseFieldWithOthers:@{@"result":@"Result"}];
}

@end
