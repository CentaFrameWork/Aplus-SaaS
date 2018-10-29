//
//  EditEntrustFilingVC.h
//  PanKeTong
//
//  Created by 张旺 on 2017/7/28.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

@interface EditEntrustFilingVC : BaseViewController

@property (nonatomic, copy) NSString *signType;         // 签署类型

@property(nonatomic, copy) NSString *propertyKeyId;      // 房源id

//现在已经不要审核
//@property(nonatomic, copy) NSString *trustAuditState;    // 审批状态 -1 无委托信息 0 待审核 1 审核通过 2 审核拒绝

@property (nonatomic,assign) BOOL isPlaying;            // 是否正在播放

/**
 *  刷新房源详情block，
 */
@property (nonatomic, copy) void (^refreshPropertyDetailDataBlock)(void);

@end
