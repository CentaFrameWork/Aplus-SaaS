//
//  PropetyRealSettingEntity.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface PropetyRealSettingEntity : AgencyBaseEntity

@property (nonatomic, copy) NSString *minUpdate;
@property (nonatomic, copy) NSString *maxUpdate;
@property (nonatomic, copy) NSString *maxRoomPhotoCount;
@property (nonatomic, assign) BOOL fictitiousNumberSwitch;  // 北京部门权限里的虚拟号开关
@property (nonatomic, copy) NSString  *virtualCall;         // AppSetting里的虚拟号总开关
@property (nonatomic, assign) BOOL centaBoxSwitch;          // 天津部门智能钥匙箱开关
@property (nonatomic, copy) NSString *boxRange;             // 钥匙箱半径

@property (nonatomic, copy) NSString *imageMinWidth;           // 实勘图片最小宽度
@property (nonatomic, copy) NSString *imageMinHeight;          // 实勘图片最小高度

@end
