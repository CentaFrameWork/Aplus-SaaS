//
//  NewAddtakingCell.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/1.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

///新增约看
@interface NewAddtakingCell : UITableViewCell{
    
    __weak IBOutlet UILabel *_contentLabel;
}

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UILabel *theName;

@property (nonatomic,copy)NSString *content;

@property (nonatomic,assign)NSInteger section;




@end
