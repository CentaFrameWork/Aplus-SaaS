//
//  CheckFaceUtils.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/12/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CheckFaceUtils.h"
#import "FaceSearchApi.h"
#import "Error.h"
#import "CheckHttpErrorUtil.h"
#import "JDStatusBarNotification.h"

static CheckFaceUtils *_sharedFaceUtils;

@implementation CheckFaceUtils

+ (CheckFaceUtils *)sharedFaceUtils {
    if (!_sharedFaceUtils) {
        _sharedFaceUtils = [[self alloc] init];
    }
    return _sharedFaceUtils;
}

- (void)hasManager {
    if (!_sharedFaceUtils.manager)
    {
        _sharedFaceUtils.manager = [RequestManager initManagerWithDelegate:self];
    }
}

- (void)checkFaceExists {
    [_sharedFaceUtils hasManager];
        
    NSString *userCityCode = [[NSUserDefaults standardUserDefaults]stringForKey:CityCode];
    NSString *staffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
    //时间戳
    NSDate *nowDate = [NSDate date];
    NSString *nowTime = [CommonMethod dateStringWithDate:nowDate DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@%@", userCityCode, staffNo, AppCode, nowTime, AppSecrect];
    
     FaceSearchApi *faceSearchApi = [FaceSearchApi new];
    faceSearchApi.companyCode = userCityCode;
    faceSearchApi.staffCode = staffNo;
    faceSearchApi.appCode = AppCode;
    faceSearchApi.callOn = nowTime;
    faceSearchApi.sign = [sign md5];
    [_manager sendRequest:faceSearchApi];
}


#pragma mark - <ResponseDelegate>

/// 响应成功
- (void)respSuc:(id)data andRespClass:(id)cls {
    if ([cls isEqual:[FaceUploadEntity class]])
    {
        // 查询是否上传过
         FaceUploadEntity *faceEntity = [DataConvert convertDic:data toEntity:cls];
        NSLog(@"%@", faceEntity.rMessage);
        if (faceEntity.rCode == 0)
        {
            [CommonMethod setUserdefaultWithValue:faceEntity.result forKey:FaceCollectUrl];
        }
    }
}

/// 响应失败
- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    NSString *errorMsg = @"";
    if ([error isKindOfClass:[Error class]]) {
        Error *failError = (Error *)error;
        errorMsg = [CheckHttpErrorUtil handleError:failError];
    }else{
        Error *failError = [[Error alloc]init];
        
        failError.rDescription = error.localizedDescription;
        errorMsg = [CheckHttpErrorUtil handleError:failError];
    }
    
    if (![NSString isNilOrEmpty:errorMsg])
    {
        showJDStatusStyleErrorMsg(errorMsg);
    }
}


//- (void)handleError:(Error *)error {

    //    [self hiddenLoadingView];
    
//    if ([@"A connection failure occurred" isEqualToString:error.rDescription]) {
//        
//        showMsg(@"无法连接服务器，请稍后再试!");
//    } else if ([@"The request timed out" isEqualToString:error.rDescription]) {
//        
//        showMsg(@"网络不给力，请稍后再试!");
//    } else if ([error.rDescription rangeOfString:@"SSL"].location != NSNotFound){
//        //连接到需要认证的wifi环境
//        showMsg(@"网络不给力，请稍后再试!");
//    }
//}

@end
