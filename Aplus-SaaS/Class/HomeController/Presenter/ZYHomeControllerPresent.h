//
//  ZYShareVM.h
//  PanKeTong
//
//  Created by Admin on 2018/9/11.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYHomeControllerPresent : NSObject

@property (nonatomic,strong,nullable) NSArray<NSObject*> *array;

+ (void)request_loginWithArgument:(NSDictionary*)dict withSucess:(void(^)(ZYHomeControllerPresent * shareVM))block;

@end






