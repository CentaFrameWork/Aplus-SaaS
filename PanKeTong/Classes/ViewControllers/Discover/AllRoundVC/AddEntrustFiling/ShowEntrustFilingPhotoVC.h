//
//  ShowEntrustFilingPhotoVC.h
//  PanKeTong
//
//  Created by 张旺 on 2017/7/21.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ DeletePhotoBlock)(void);

@interface ShowEntrustFilingPhotoVC : BaseViewController

@property (nonatomic, copy) DeletePhotoBlock deletePhotoBlock;

@property (nonatomic, copy) NSString * photoType;
@property (nonatomic, strong) NSMutableArray *photoImageArray;          // 手动添加的照片
@property (nonatomic, strong) NSMutableArray *serverPhotoArray;         // 从接口拿到的照片
@property (nonatomic, strong) NSMutableArray *uploadPhotoDetailArray;   // 从接口拿到的照片信息
@property (nonatomic,assign) BOOL isOnlyViewPermission;                 // 是否只有查看权限
@end
