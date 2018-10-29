//
//  MessageContentCell.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/5.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

///短信内容Cell
@interface MessageContentCell : UITableViewCell{

    __weak IBOutlet UITextView *_textView;

    __weak IBOutlet UIButton *_mobanBtn;

    __weak IBOutlet UILabel *_sumLabel;

}
@end
