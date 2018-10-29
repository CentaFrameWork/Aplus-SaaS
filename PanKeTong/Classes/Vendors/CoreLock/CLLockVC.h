//
//  CLLockVC.h
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    //设置密码
    CoreLockTypeSetPwd=0,
    
    //输入并验证密码
    CoreLockTypeVeryfiPwd,
    
    //修改密码
    CoreLockTypeModifyPwd,
    
}CoreLockType;

@interface CLLockVC : UIViewController

@property (nonatomic,assign) CoreLockType type;
@property (nonatomic,assign) NSInteger errorLimit;
@property (nonatomic,assign) NSInteger errorCount;

/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+(BOOL)hasPwd;

/*
 *  展示设置密码控制器
 */
+(instancetype)showSettingLockVCInVC:(UIViewController *)vc
                        successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock
                      isShowNavClose:(BOOL)isShowNavClose;

/*
 *  展示验证密码输入框
 */
+(instancetype)showVerifyLockVCInVC:(UIViewController *)vc
                     forgetPwdBlock:(void(^)(CLLockVC *lockVC))forgetPwdBlock
                       successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock
                      errorLimit:(NSInteger)errorLimit
                      achieveErrorLimitBlock:(void(^)(CLLockVC *lockVC))achieveErrorLimitBlock;

/*
 *  展示验证密码输入框
 */
+(instancetype)showModifyLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;

/*
 *  消失
 */
-(void)dismiss:(NSTimeInterval)interval;

/*
 *  立即消失
 */
- (void)dismissNow;

/*
 *  重置校验密码界面
 */
-(void)resetValidPwd;

-(void)userInteractionDisEnabled;

/*
 *  清空手势密码
 */
+ (void)clearCoreLockPWDKey;

@end
