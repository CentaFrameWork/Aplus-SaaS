//
//  RecordDetailView.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/23.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordDetailView : UIView<UITableViewDelegate,UITableViewDataSource>

-(void)createGoOutRecordViewWithRecordDetail:(NSArray *)recordDetail;

@end
