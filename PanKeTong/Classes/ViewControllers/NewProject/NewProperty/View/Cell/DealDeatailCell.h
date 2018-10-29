//
//  DealDeatailCell.h
//  PanKeTong
//
//  Created by Admin on 2018/3/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Row_Height   33
#define Title_width   80
#define CellW (APP_SCREEN_WIDTH-Title_width-84)

#define Title_width_Two   100
#define CellW_Two (APP_SCREEN_WIDTH-Title_width_Two-84)

@protocol DealDeatailCell <NSObject>

- (void)didClickBtnSeeImage:(UIButton*)btn withArr:(NSArray*)arr;

@end
@interface DealDeatailCell : UITableViewCell
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,weak) id<DealDeatailCell>delegate;
@property (nonatomic,copy) NSString *DealType;
+ (instancetype)loadDealDetailWithTableView:(UITableView*)tableView;
+ (CGFloat)sizeWithString:(NSString*)string;
@end
