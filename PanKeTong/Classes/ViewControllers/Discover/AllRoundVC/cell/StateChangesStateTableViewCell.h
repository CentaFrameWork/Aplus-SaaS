//
//  StateChangesStateTableViewCell.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/5.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StateChangesStateTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *stateStrLab;
@property (nonatomic, strong)UILabel *stateResultsLab;
@property (nonatomic, assign)BOOL propertyStatus;      // 房源状态
@property (nonatomic, strong)NSIndexPath *indexPath;
@end
