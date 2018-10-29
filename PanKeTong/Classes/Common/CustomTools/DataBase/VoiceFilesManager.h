//
//  VoiceFilesManager.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseManager.h"

/// 保存录音文件名称和时长
@interface VoiceFilesManager : BaseManager

- (void)insertVoiceRecordFileName:(NSString *)fileName
                    andRecordTime:(NSString *)recordTime
                        andPropId:(NSString *)propId
                   andVoiceLength:(NSString *)voiceLength;

- (NSMutableArray *)selectVoiceRecordFilesWithPropId:(NSString *)propId;

- (BOOL)updateVoiceRecordFilesWithFileName:(NSString *)fileName toPropId:(NSString *)propId;

- (void)deleteVoiceRecordWithFileName:(NSString *)fileName;

@end
