//
//  NewContactLandlineCell.h
//  
//
//  Created by 连京帅 on 2018/3/8.
//

#import <UIKit/UIKit.h>
#import "NewContactAreaCodeTextField.h"
#import "NewContactPhoneTextField.h"
#import "NewContactExtensionTextField.h"
#import "NewContactModel.h"

@interface NewContactLandlineCell : UITableViewCell

@property (nonatomic, strong)UILabel *landlineLabel;            // 座机
@property (nonatomic, strong)NewContactAreaCodeTextField *areaCodeTextField;    // 区号
@property (nonatomic, strong)NewContactPhoneTextField *phoneTextField;       // 电话
@property (nonatomic, strong)NewContactExtensionTextField *extensionTextField;       // 分机

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)NewContactModel *model;
@property (nonatomic, assign)BOOL isEditor;                 // 是编辑  否添加
@property (nonatomic, assign)BOOL editLineNumber;           // 是否编辑过座机号

@end
