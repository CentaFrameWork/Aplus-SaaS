//
//  PropKeyViewController.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/15.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

@interface PropKeyViewController : BaseViewController

@property (nonatomic,strong) NSString *keyId;
@property (nonatomic, copy) void(^theRefreshata)(void);

@end

