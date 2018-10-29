//
//  BaseManager.h
//  AlPus
//
//  Created by 李慧娟 on 17/7/20.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseManager.h"
#import "FMDatabase.h"
#import "TableName.h"

@interface DataBaseManager : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;

/// 单例创建数据库管理对象
+ (DataBaseManager *)shareDataBaseManager;

/// 加载数据库
- (void)createDataBaseMethod;
@end


@interface BaseManager : NSObject{
    DataBaseManager *_dbManager;
}

/// 检查表是否已存在
- (BOOL)isExistTable:(NSString *)tableName;

@end
