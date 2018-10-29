//
//  SearchBuildingVC.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/4/20.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
@protocol searchBuildingNameDelagate <NSObject>

@optional
- (void)searchBuildingWithBuildingName:(NSString *)buidingName
                       andBuidingKeyId:(NSString *)buidingKeyId;

@end

/// 根据楼盘名搜索栋座
@interface SearchBuildingVC : BaseViewController

@property (nonatomic, copy) NSString *estateName;       // 楼盘名

@property (nonatomic, assign) BOOL isFromTrustAuditing; // 从委托审核进来

@property (nonatomic, assign) id <searchBuildingNameDelagate> searchBuildingNameDelagate;

@end
