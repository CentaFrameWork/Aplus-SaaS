//
//  EditorModuleView.h
//  APlus
//
//  Created by 李慧娟 on 2017/10/20.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomGrid.h"
#import "APPConfigEntity.h"

#define MAX_COUNT   12  // 最大模块个数(加上占位模块)
#define MIN_COUNT   4   // 最大模块个数（加上占位模块）
#define EMPTY_ID    0   // 空格的ID

@protocol EditorModuleProtocal<NSObject>

- (void)finishedRemoveWithGrid:(NSInteger)gridId;
- (void)finishedAddGridWithEntity:(APPLocationEntity *)entity;
- (void)finishedMoveGridWithDataArr:(NSArray *)dataArr;;

@end

@interface EditModuleView : UIView<CustomGridDelegate>

@property (nonatomic, weak) id <EditorModuleProtocal> delegate;

- (void)createViewWithDataArr:(NSMutableArray *)dataArr;


- (void)addBoxActionWithIsEmpty:(BOOL)isEmpty //是否为最后一个占位格子
                     WithEntity:(APPLocationEntity *)entity;
@end
