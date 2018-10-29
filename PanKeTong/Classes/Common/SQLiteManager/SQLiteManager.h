//
//  SQLiteManager.h
//  比颜值
//
//  Created by 陈行 on 15-12-1.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingSystem.h"
#import "FMDatabase.h"
#import "VersionConst.h"

#import "NSObject+SQLiteManagerKeyValue.h"

#define DATABASE_PATH @"/Documents/database.sqlite3"

//另外一个微信使用的数据库->wcdb

@interface SQLiteManager : NSObject

/**
 *  数据库位置
 */
@property (nonatomic, copy) NSString * databasePath;
/**
 *  FMDatabase
 */
@property (nonatomic, strong) FMDatabase * db;
/**
 *  单例获取一个数据库
 */
+ (SQLiteManager *)shareSQLiteManager;
+ (SQLiteManager *)shareSQLiteManagerWithDatabasePath:(NSString *)databasePath;
/**
 *  检查数据库版本，不相符则更新
 */
+ (void)checkAndUpdateDatabaseVersion;
/**
 *  创建一张表，如果不存在的情况下
 *
 *  @param sql sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)createTableWithSQL:(NSString *)sql;
/**
 *  插入一条数据
 *
 *  @param sql  sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)insertWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array;
/**
 *  若存在则替换，不存在则插入
 *
 *  @param sql sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)insertOrReplaceWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array;
/**
 *  修改数据
 *
 *  @param sql sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)updateWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array;
/**
 *  删除数据
 *
 *  @param sql sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)deleteWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array;
/**
 *  查询,记得使用完成之后[rs close]下
 *
 *  @param sql sql语句
 *
 *  @return 数组
 */
- (FMResultSet *)queryWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array;

/**
 *  插入一条数据
 *
 *  @param tableName 表名
 *  @param object 对象
 *  @return 成功与否
 */
+ (BOOL)insertToTableName:(NSString *)tableName andObject:(id)object;
/**
 *  插入或替换一条数据
 */
+ (BOOL)insertOrReplaceToTableName:(NSString *)tableName andObject:(id)object;
/**
 *  插入一组数据，事务添加
 */
+ (BOOL)insertToTableWithDataArray:(NSArray<NSArray *> *)dataArray andSQL:(NSString *)sql;
/**
 *  插入一组数据，事务添加，根据对象进行插入，tableName表名
 *
 *  @return 成功or失败
 */
+ (BOOL)insertToTableWithDataArray:(NSArray<NSObject *> *)dataArray andTableName:(NSString *)tableName;
/**
 *  执行查询一条数据
 *
 *  @param tableName 数据库表名
 *  @param clazz     转为数据库表名
 *
 *  @return 成功或者失败
 */
+ (id)queryOneWithTableName:(NSString *)tableName andClass:(Class)clazz;
/**
 *  执行查询所有
 *
 *  @param tableName 数据库表名
 *  @param clazz     转为数据库表名
 *
 *  @return 成功或者失败
 */
+ (NSMutableArray *)queryAllWithTableName:(NSString *)tableName andClass:(Class)clazz;
/**
 *  执行查询操作
 *
 *  @param tableName 数据库表名
 *  @param clazz     转为数据库表名
 *  @param params    查询的条件
 *
 *  @return 成功或者失败
 */
+ (NSMutableArray *)queryByParamsWithTableName:(NSString *)tableName andClass:(Class)clazz andParams:(NSDictionary *)params;
/**
 *  执行删除
 *
 *  @param tableName 数据库表名
 *  @param clazz     转为数据库表名
 *  @param params    删除的事后的条件
 *
 *  @return 成功或者失败
 */
+ (BOOL)deleteWithTableName:(NSString *)tableName andClass:(Class)clazz andParams:(NSDictionary *)params;
/**
 *  删除一组数据，事务删除
 *
 *  @return 成功or失败
 */
+ (BOOL)deleteToTableWithSQL:(NSString *)sql andParams:(NSArray<NSArray *> *)params;
/**
 *  执行修改
 *
 *  @param tableName   数据库表名
 *  @param clazz       对象class，转为数据库表名
 *  @param params      设置“属性”=“值”
 *  @param whereParams sql的where条件
 *
 *  @return 成功或者失败
 */
+ (BOOL)updateWithTableName:(NSString *)tableName andClass:(Class)clazz andParams:(NSDictionary *)params andWhereParams:(NSDictionary *)whereParams;
/**
 *  获取属性列表
 *
 *  @param clazz 类对象
 *
 *  @return 属性列表
 */
+ (NSMutableArray *)propertyArrayWithClass:(Class)clazz;

@end
