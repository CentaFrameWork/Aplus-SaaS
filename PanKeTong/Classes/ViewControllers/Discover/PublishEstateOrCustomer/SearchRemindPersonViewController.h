//

//  PanKeTong
//
//  Created by 苏军朋 on 15/10/29.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "RemindPersonListEntity.h"

/**
 *  搜索人员：1、搜索部门：2
 */
typedef enum
{
    PersonType = 1,
    DeparmentType,
    
}SearchRemindType;

@protocol SearchRemindPersonDelegate <NSObject>

- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem;

// 非必须
@optional
- (void)returnText:(NSString *)text;

@end

@interface SearchRemindPersonViewController : BaseViewController

@property (nonatomic, assign) SearchRemindType selectRemindType;        // 提醒人类型
@property (nonatomic, copy) NSString *selectRemindTypeStr;              // 提醒人类型字符串
@property (nonatomic, copy) NSMutableArray *selectedRemindPerson;       // 已经添加的提醒人
@property (nonatomic, weak) id <SearchRemindPersonDelegate> delegate;

@property (nonatomic, assign) BOOL isFromOtherModule;                   // 是否是从日历／委托审核跳转过来的
@property (nonatomic, assign) BOOL isExceptMe;                          // 是否排除自己
@property (nonatomic, copy) NSString *departmentKeyId;                  // 部门

//是否是编辑钥匙界面，修改
@property (nonatomic, assign) BOOL isPropKeyVC;

@end
