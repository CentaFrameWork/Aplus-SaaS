//
//  CalendarStrokeCell.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/24.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TakingSeeEvent      @"约看"
#define TakeSeeEvent        @"带看"
#define GoOutEvent          @"外出"
#define AlertEvent          @"提醒"
#define HasComplentEvent    @"已完成"

/// 日历行程单元格
@interface CalendarStrokeCell : UITableViewCell<UIAlertViewDelegate>{
    __weak IBOutlet UILabel *_timeLabel;    // 时间
    __weak IBOutlet UILabel *_eventLabel;   // 事件
    __weak IBOutlet UILabel *_contenLabel;  // 内容
}

@property (nonatomic,copy)NSString *eventType;  // 事件类型
@property (nonatomic,strong)id dataEntity;      // 数据



@end
