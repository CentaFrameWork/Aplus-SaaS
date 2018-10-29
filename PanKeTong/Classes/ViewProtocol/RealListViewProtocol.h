//
//  RealListViewProtocol.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AplusBaseViewProtocol.h"

@protocol RealListViewProtocol <AplusBaseViewProtocol>

- (UITableViewCell *)setTableViewCell:(NSIndexPath *)indexPath;

@end
