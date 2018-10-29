//
//  CheckVersonUtils.m
//  PanKeTong
//
//  Created by 中原管家 on 2016/10/9.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "CheckVersonUtils.h"
#import "CheckAppVersonApi.h"
#import "CheckVersonEntity.h"
#import "ServiceHelper.h"
#import "CheckHttpErrorUtil.h"

#define ForceUpdateAlertTag         1000
#define NormalUpdateAlertTag        2000

@implementation CheckVersonUtils

static CheckVersonUtils *checkVersonUtils;


+ (CheckVersonUtils *)shareCheckVersonUtils
{
    if(checkVersonUtils)
    {
        return checkVersonUtils;
    }
    
    
    checkVersonUtils = [[self alloc]init];
    checkVersonUtils.isShowErrorAlert = NO;
    
    return checkVersonUtils;
}

/**
 *  检查服务端版本号，看是否需要更新版本
 */
- (void)checkAppVerson
{
    [checkVersonUtils hasManager];
    
    CheckAppVersonApi *checkAppVersonApi = [[CheckAppVersonApi alloc] init];
    [self.manager sendRequest:checkAppVersonApi];
    
}

- (void)hasManager
{
    if (!checkVersonUtils.manager) {
        checkVersonUtils.manager = [RequestManager initManagerWithDelegate:self];
    }
}



#pragma mark - <ResponseDelegate>

/// 响应成功
- (void)respSuc:(id)data andRespClass:(id)cls
{
    
    CheckVersonEntity *checkVersonEntity = [DataConvert convertDic:data toEntity:cls];

    
    if([checkVersonEntity isKindOfClass:[BaseEntity class]]){
        // 上海
        id checkData = [ServiceHelper checkHKData:data];
        
        if ([checkData isKindOfClass:[Error class]]) {
            
            // 统一处理错误的消息
            _error = (Error *)checkData;
            [self handleError:_error];
            
            return;
        }
        
    }

    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestSuccess)]) {
        [self.delegate requestSuccess];
    }
    
    // 获取服务端版本号成功，使用build verson更新
    CheckVersonResultEntity *versonDetailEntity = checkVersonEntity.result;
    // 保存更新地址、更新内容
    [CommonMethod setUserdefaultWithValue:versonDetailEntity.updateUrl
                                   forKey:UpdateVersionUrl];
    [CommonMethod setUserdefaultWithValue:versonDetailEntity.updateContent
                                   forKey:UpdateContent];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    if (versonDetailEntity.forceUpdate == 1) {
        
        
        if ([versonDetailEntity.clientVer integerValue] > [app_Version integerValue]) {
            UIAlertView *forceUpdateAlert = [[UIAlertView alloc]initWithTitle:@"有版本更新"
                                                                      message:versonDetailEntity.updateContent
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:@"更新", nil];
            forceUpdateAlert.tag = ForceUpdateAlertTag;
            [forceUpdateAlert show];
            
        }else{
            if (_isShowErrorAlert) {
                showMsg(@"当前已是最新版本！");
                _isShowErrorAlert = NO;
            }
        }
        
    }else{
        
        if ([versonDetailEntity.clientVer integerValue] > [app_Version integerValue]) {
            
            UIAlertView *normalAlertView = [[UIAlertView alloc]initWithTitle:@"有版本更新"
                                                                     message:versonDetailEntity.updateContent
                                                                    delegate:self
                                                           cancelButtonTitle:@"取消"
                                                           otherButtonTitles:@"更新", nil];
            normalAlertView.tag = NormalUpdateAlertTag;
            [normalAlertView show];
            
            
        }else{
            if (_isShowErrorAlert) {
                showMsg(@"当前已是最新版本！");
                _isShowErrorAlert = NO;
            }
        }
    }
    
    

}



/// 响应失败
- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    if ([error isKindOfClass:[Error class]]) {
        Error *failError = (Error *)error;
        [self handleError:failError];
        
    }else{
        Error *failError = [[Error alloc]init];
        
        failError.rDescription = error.localizedDescription;
        [self handleError:failError];
    }

    
}


- (void)handleError:(Error *)error {
    
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
//    else {
//
//        NSString *errorMsg = error.rDescription;
//
//        if (error.rDescription) {
//
//            if ([error.rDescription isEqualToString:@"数据为空"]) {
//
//                [CustomAlertMessage showAlertMessage:@"没有找到符合条件的信息\n\n"
//                                     andButtomHeight:APP_SCREEN_HEIGHT/2];
//
//            }else{
//
//                if (_isShowErrorAlert) {
//                    showMsg(errorMsg);
//                    _isShowErrorAlert = NO;
//                }else{
//
//                }
//
//                if (self.delegate && [self.delegate respondsToSelector:@selector(requestFeild:)]) {
//                    [self.delegate requestFeild:errorMsg];
//                }
//            }
//
//        }
//    }
    
    NSString *errorMsg = [CheckHttpErrorUtil handleError:error];
    
    if (![NSString isNilOrEmpty:errorMsg])
    {
        if (_isShowErrorAlert)
        {
            showMsg(errorMsg);
            _isShowErrorAlert = NO;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestFeild:)]) {
        [self.delegate requestFeild:errorMsg];
    }
}

- (void)setIsShowErrorAlert:(BOOL)isShowErrorAlert{
    if (_isShowErrorAlert != isShowErrorAlert) {
        _isShowErrorAlert = isShowErrorAlert;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *updateUrl = [[NSUserDefaults standardUserDefaults]stringForKey:UpdateVersionUrl];
    NSString *udpateContent = [[NSUserDefaults standardUserDefaults]stringForKey:UpdateContent];
    
    switch (alertView.tag) {
        case ForceUpdateAlertTag:
        {
            
            UIAlertView *forceUpdateAlert = [[UIAlertView alloc]initWithTitle:@"有版本更新"
                                                                      message:udpateContent
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:@"更新", nil];
            forceUpdateAlert.tag = ForceUpdateAlertTag;
            
            [forceUpdateAlert show];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
            
            exit(0);
        }
            break;
        case NormalUpdateAlertTag:
        {
            
            switch (buttonIndex) {
                case 1:
                {
                    // 去更新
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                    
                    exit(0);
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
}



@end
