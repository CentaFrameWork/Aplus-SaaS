//
//  AllRoundFilterCustomView.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/19.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AllRoundFilterCustomViewDelegate <NSObject>
@optional
-(void)getBtnTag:(NSInteger)tag FilterName:(NSString *)name SettingSwitch:(BOOL)ison andSearchName:(NSString *)searchName;

@end


@interface AllRoundFilterCustomView : UIView<AllRoundFilterCustomViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIWindow * _window;
}
@property (nonatomic,assign)id<AllRoundFilterCustomViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *filterNameTextfield;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *TheDefaultButton;

@property (copy, nonatomic) NSString *searchName;

//获取展示文字
-(void)getTableViewArray:(NSArray *)array;
//创建view
-(void)creatView;
@end
