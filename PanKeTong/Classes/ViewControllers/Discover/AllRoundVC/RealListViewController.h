//
//  RealListViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "RealSurveyListEntity.h"
#import "RealListTableViewCell.h"
//#import "DascomService.h"
#import "PhotoDownLoadImageViewController.h"

@interface RealListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString *keyId;
@property (nonatomic, strong) NSString *estateName;

@end
