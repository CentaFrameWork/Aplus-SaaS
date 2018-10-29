//
//  PublishCusDetailViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/23.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"

@protocol PublishCusDetailDelegate <NSObject>

- (void)backToPublishEstateOrCusDetail:(NSString *)publishCusKeyId;

@end

@interface PublishCusDetailViewController : BaseViewController

@property (nonatomic,copy)NSString *publishCusKeyId;     // 客户keyId
@property (nonatomic,copy)NSString *tradeType;           // 客户类型
@property (nonatomic,copy)NSString *selectCusName;       // 选择的客户姓名

@property (nonatomic, assign)id<PublishCusDetailDelegate>delegate;
@end
