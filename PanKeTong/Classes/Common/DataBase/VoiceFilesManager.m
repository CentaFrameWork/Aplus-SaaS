//
//  VoiceFilesManager.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "VoiceFilesManager.h"

@implementation VoiceFilesManager

- (void)insertVoiceRecordFileName:(NSString *)fileName
                    andRecordTime:(NSString *)recordTime
                        andPropId:(NSString *)propId
                   andVoiceLength:(NSString *)voiceLength
{
    if (![_dbManager.dataBase open])
    {
        return;
    }

    NSString *sqlStr;
    if (![self isExistTable:VoiceRecordFiles])
    {
        sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@ (fileName TEXT,recordTime TEXT,propId TEXT,voiceLength TEXT)",VoiceRecordFiles];
        [_dbManager.dataBase executeUpdate:sqlStr];
    }

    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?,?,?)",VoiceRecordFiles];
    [_dbManager.dataBase executeUpdate:sqlStr,fileName,recordTime,propId,voiceLength];

    [_dbManager.dataBase close];

}

- (NSMutableArray *)selectVoiceRecordFilesWithPropId:(NSString *)propId
{
    if (![_dbManager.dataBase open] || ![self isExistTable:VoiceRecordFiles])
    {
        return nil;
    }

    NSMutableArray *voiceRecordFilesArray = [[NSMutableArray alloc] init];

    // 返回全部查询结果
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ where propId = ?",VoiceRecordFiles];
    FMResultSet *resultSet = [_dbManager.dataBase executeQuery:sqlStr,propId];

    // 所有保存的录音文件
    NSString *voiceRecordFileName;
    NSString *voiceRecordLength;
    NSString *voiceRecordTime;

    while ([resultSet next])
    {
        voiceRecordFileName = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"fileName"]];
        voiceRecordLength = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"voiceLength"]];
        voiceRecordTime = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"recordTime"]];

        NSDictionary *voiceRecordFileDic = [[NSDictionary alloc] initWithObjectsAndKeys:voiceRecordFileName,@"fileName",
                                                                                        voiceRecordLength,@"voiceLength",
                                                                                        voiceRecordTime,@"recordTime",nil];
        [voiceRecordFilesArray addObject:voiceRecordFileDic];
    }

    [_dbManager.dataBase close];

    return voiceRecordFilesArray;
}

- (BOOL)updateVoiceRecordFilesWithFileName:(NSString *)fileName
                                  toPropId:(NSString *)propId
{
    if (![_dbManager.dataBase open] || ![self isExistTable:VoiceRecordFiles])
    {
        return NO;
    }

    // 绑定录音文件到指定房源ID
    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE %@ set propId = ? WHERE fileName = ?",VoiceRecordFiles];
    BOOL isSuccess = [_dbManager.dataBase executeUpdate:sqlStr,propId,fileName];
    [_dbManager.dataBase close];

    return isSuccess;
}

- (void)deleteVoiceRecordWithFileName:(NSString *)fileName
{
    if (![_dbManager.dataBase open] || ![self isExistTable:VoiceRecordFiles])
    {
        return;
    }

    // 删除保存的录音文件
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE fileName = ?",VoiceRecordFiles];
    [_dbManager.dataBase executeUpdate:sqlStr,fileName];

    [_dbManager.dataBase close];
}


@end
