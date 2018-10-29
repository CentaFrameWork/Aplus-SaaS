//
//  WJContactViewController.m
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "WJContactViewController.h"
#import "NewContactViewController.h"    // 新增，编辑
#import "WJContactCell.h"
#import "WJContactListModel.h"
#import "TheEditorCell.h"

#import "ContactListPropertiesCell.h"
#import "ContactListContactInformationCell.h"
#import "ContactListForCommentsCell.h"
#import "ContactListNotesCell.h"

//判断字段时候为空的情况
#define IfNullToString(x)  ([(x) isEqual:[NSNull null]]||(x)==nil||[(x) isEqualToString:@"(null)"])?@"":TEXTString(x)
#define TEXTString(x) [NSString stringWithFormat:@"%@",x]  //转换为字符串
@interface WJContactViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_mainTableView;
    NSMutableArray * _dataSource;
    NSMutableDictionary *SexDic;//联系人称谓
    NSMutableDictionary *LianxirenDic;//联系人称谓
    NSMutableDictionary *hunyinDic;//婚姻

}

/**
 *  没有数据的情况下遮罩View
 */
@property (nonatomic, weak) UIView * noDataMaskView;

/**
 *  没有数据的情况下label
 */
@property (nonatomic, weak) UILabel * noDataLabel;

/**
 *  是否有查看有效盘电话数量
 */
@property (nonatomic, assign) BOOL isHasBrowseCount;

@end

@implementation WJContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self authorityToJudge];
    [self initView];
    [self initData];
}


- (void)initData {
    SysParamItemEntity *regionSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_GENDER];
    SysParamItemEntity *lianxirenleixing = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUTOMER_TYPE];

    SysParamItemEntity *hunyin = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_MARRIAGE_STATUS];
    
    NSMutableArray *propTagValueArray = [NSMutableArray arrayWithArray:regionSysParamItemEntity.itemList];
    NSMutableArray *lianxirenleixingArr = [NSMutableArray arrayWithArray:lianxirenleixing.itemList];
    NSMutableArray *hunyinArray = [NSMutableArray arrayWithArray:hunyin.itemList];

    
    SelectItemDtoEntity *entity = [SelectItemDtoEntity new];
     SexDic= [[NSMutableDictionary alloc] init];
     LianxirenDic= [[NSMutableDictionary alloc] init];
    hunyinDic = [[NSMutableDictionary alloc] init];
    
    for (entity in propTagValueArray) {
        [SexDic setObject:entity.itemText forKey:entity.itemValue];
    }

    for (entity in lianxirenleixingArr) {
        [LianxirenDic setObject:entity.itemText forKey:entity.itemValue];
    }
    for (entity in hunyinArray) {
        [hunyinDic setObject:entity.itemText forKey:entity.itemValue];
    }

    _dataSource = [[NSMutableArray alloc] init];
    [self headerRefreshMethod];
    NSLog(@"性别：%@ 联系人类型：%@ 婚姻情况：%@",SexDic,LianxirenDic,hunyinDic);
}

- (void)authorityToJudge {
    
    // 新增联系人 权限判断
    if([AgencyUserPermisstionUtil hasRight:PROPERTY_PROPERTY_MODIFY_ALL] && [AgencyUserPermisstionUtil hasRight:PROPERTY_CONTACTINFORMATION_ADD_ALL]){
//       && self.isHasBrowseCount == true) {
       
        [self setNavTitle:@"联系人" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:[self customBarItemButton:@"新增" backgroundImage:nil foreground:nil sel:@selector(addContact)]];
        
    }else {
        [self setNavTitle:@"联系人" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:nil];
    }
}

#pragma mark - 建立视图
- (void)initView
{
    self.view.backgroundColor = APP_BACKGROUND_COLOR;

    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(12*NewRatio, 0, APP_SCREEN_WIDTH-24*NewRatio, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT)
                                                  style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = [UIColor clearColor];
//    _mainTableView.contentInset = {0, 0, 0, 0};

    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
//
//    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
    [self.view addSubview:_mainTableView];
    

}
- (void)headerRefreshMethod
{
    [_dataSource removeAllObjects];
    [_mainTableView reloadData];
    [self requestData];
    [self showLoadingView:nil];
}

- (void)requestData {
   
    NSString *string = [NSString stringWithFormat:@"%@?KeyId=%@&IsMobileRequest=%@",WJContactListAPI,_propertyKeyId,@(true)];
    
    
    [AFUtils GET:string controller:self successfulDict:^(NSDictionary *successfuldict) {
        
        NSInteger browseCount = [[NSString stringWithFormat:@"%@", successfuldict[@"TotalBrowseCount"]] integerValue];
        
        self.isHasBrowseCount = browseCount > 0;
        
        [self authorityToJudge];
        
        NSLog(@"successfuldict===%@",successfuldict);
        [self endRefreshWithTableView:_mainTableView];
        
        for (NSDictionary *mainDic in successfuldict[@"Trustors"]) {
            WJContactListModel * model = [[WJContactListModel alloc] initDic:mainDic];
            NSString *str = [SexDic objectForKey:model.TrustorGenderKeyId];
            NSLog(@"LianxirenDic==%@",LianxirenDic);
            NSString *LianxirenStr = [LianxirenDic objectForKey:model.TrustorTypeKeyId];
            NSString *hunyinStr = [hunyinDic objectForKey:model.MaritalStatusKeyId];
            
            model.TrustorGenderKeyId = str;
            model.TrustorTypeKeyId = LianxirenStr;
            model.MaritalStatusKeyId = hunyinStr;
            model.isEnable = 0;
            [_dataSource addObject:model];
            
        }
        
        NSString * msg = @"";
        
        if (self.isHasBrowseCount == true && _dataSource.count == 0) {
            
            msg = @"暂无联系人";
            
        }else if (self.isHasBrowseCount == false){
            
            msg = @"您的查看次数已用完，无法查看";
            
        }
        
        _noDataLabel.text = msg;
        
        [_mainTableView reloadData];

    } failureDict:^(NSDictionary *failuredict) {
         NSLog(@"failuredict===%@",failuredict);
    } failureError:^(NSError *failureerror) {
        NSLog(@"failureerror===%@",failureerror);
    }];
    
   
}



#pragma mark - tableView代理事件
/**
 * tableView的分区数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (_dataSource.count == 0) {
        
        [self.noDataMaskView.superview bringSubviewToFront:self.noDataMaskView];
        
        self.noDataMaskView.hidden = NO;
        
    }else{
        
        _noDataMaskView.hidden = YES;
        
    }
    
    return _dataSource.count;
}


/**
 * tableView分区里的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    // 编辑权限
//    if([AgencyUserPermisstionUtil hasRight:PROPERTY_PROPERTY_MODIFY_ALL]) {
//        return 7;
//    }else {
//        return 6;
//    }
    
    return 4;
}

/**
 * tableViewCell的相关属性
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    kWeakSelf;
    if (indexPath.row == 0) {
        static NSString *reuseID = @"cell";
        ContactListPropertiesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[ContactListPropertiesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.indexPath = indexPath;
        cell.model = _dataSource[indexPath.section];
        cell.deleteClickEvent = ^(NSIndexPath *indexPath) {
            [weakSelf editorClick:indexPath.section];   // 删除
        };
        cell.editClickEvent = ^(NSIndexPath *indexPath) {
            
            [weakSelf deleateClick:indexPath.section];  // 编辑
        };
        // 没有编辑权限
        if (![AgencyUserPermisstionUtil hasRight:PROPERTY_PROPERTY_MODIFY_ALL]) {
            cell.deleteButton.hidden = YES;
            cell.editorButton.hidden = YES;
        }else {
            //
            if ([AgencyUserPermisstionUtil hasRight:PROPERTY_CONTACTINFORMATION_MODIFY_ALL]) {
                cell.deleteButton.hidden = NO;
                cell.editorButton.hidden = NO;
            }else {
                cell.deleteButton.hidden = YES;
                cell.editorButton.hidden = NO;
            }
        }
        
        return cell;
    }
    else if (indexPath.row == 1) {
        static NSString *reuseID = @"cell1";
        ContactListContactInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[ContactListContactInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.indexPath = indexPath;
        cell.model = _dataSource[indexPath.section];
        return cell;
    }
    else if (indexPath.row == 2) {
        static NSString *reuseID = @"cell2";
        ContactListNotesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[ContactListNotesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.indexPath = indexPath;
        cell.model = _dataSource[indexPath.section];
        return cell;
    }
    else if (indexPath.row == 3) {
        
        static NSString *reuseID = @"cell3";
        ContactListForCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[ContactListForCommentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.indexPath = indexPath;
        cell.model = _dataSource[indexPath.section];
        return cell;
    }

    return nil;
    
}
- (NSString *)hideWithString:(NSString *)string {
  
    if (string.length < 7) {
//        NSString *temp = [string stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
        return [string isEqualToString:@"(null)"]?@"":string;
    }else if (10 < string.length&&string.length <= 12) {
        //替换某一位置的字符
        NSString *temp = [string stringByReplacingCharactersInRange:NSMakeRange(3, string.length-7) withString:@"****"];
        return temp;
    }else if(string.length>12) {
        if ([string contains:@"-"]) {
          
            NSArray*array = [string componentsSeparatedByString:@"-"];
            NSString *firstStr = IfNullToString([array firstObject]);
            NSString *lastStr = IfNullToString([array lastObject]);
            NSString *subStr = IfNullToString(array[1]);
            if (subStr.length>5) {
                NSString *temp = [subStr stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"****"];
                string = [NSString stringWithFormat:@"%@-%@-%@",firstStr,temp,lastStr];
                return string;
            }
//            NSString *temp = [firstStr stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"****"];
//            string = [NSString stringWithFormat:@"%@",temp];
            string = [NSString stringWithFormat:@"%@",firstStr];
            return string;
        }
      
    }else {
        return string;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 10)];
    return label;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 0)];
    
    return label;
}
/**
 * tableViewCell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60*NewRatio;
    }
    else if (indexPath.row == 1) {
        return 75*NewRatio;
    }
    else if (indexPath.row == 2) {
        WJContactListModel *model = _dataSource[indexPath.section];
        if (model.isEnable) {
            if (model.Remark.length >0 || model.Remark != nil) {
                CGSize size = CGSizeMake(270*NewRatio, CGFLOAT_MAX);
                NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14*NewRatio]};
                CGSize titleh = [model.Remark boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                CGFloat titleH = titleh.height;
                return titleH + (2+14)*NewRatio;
            }else {
                return 30*NewRatio;
            }
        }else {
            return 1;
        }
    }
    else if (indexPath.row == 3) {
        return 37*NewRatio;;
    }
    return 0;
}

/**
 * 分区头的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12*NewRatio;
}

/**
 * 分区脚的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
/**
 * tableViewCell的点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        WJContactListModel *model = _dataSource[indexPath.section];
        model.isEnable = !model.isEnable;
        [_mainTableView reloadData];
    }
}




#pragma mark - 自定义方法

//删除事件
- (void)editorClick:(NSInteger )integer{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除该联系人?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *value) {
        if (value.integerValue == 0) {
        }
        else if(value.integerValue == 1) {
            NSDictionary *dict = @{
                                   @"PropertyKeyId":_propertyKeyId,
                                   @"KeyId":((WJContactListModel *)(_dataSource[integer])).KeyId,
                                   };
            
            
            
            [AFUtils DELETE:AipPropertyRemoveTrustor parameters:dict controller:self successfulDict:^(NSDictionary *successfuldict) {
               
                [self headerRefreshMethod];
                showMsg(@"删除成功！");
                
            } failureDict:^(NSDictionary *failuredict) {
                
            } failureError:^(NSError *failureerror) {
                
            }];
            

        }
    }];
}
// 编辑
- (void)deleateClick:(NSInteger )integer {
    NewContactViewController *newContactVC = [[NewContactViewController alloc] init];
    newContactVC.isEditor = YES;
    newContactVC.propertyKeyId = _propertyKeyId;
    newContactVC.keyId = ((WJContactListModel *)(_dataSource[integer])).KeyId;
    newContactVC.theRefresh = ^{
        [self headerRefreshMethod];
    };
    [self.navigationController pushViewController:newContactVC animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
//新增联系人
- (void)addContact{
    NewContactViewController *newContactVC = [[NewContactViewController alloc] init];
    newContactVC.propertyKeyId = _propertyKeyId;
    newContactVC.theRefresh = ^{
        [self headerRefreshMethod];
    };
    [self.navigationController pushViewController:newContactVC animated:YES];
}

#pragma mark - getter
- (UIView *)noDataMaskView{
    
    if (!_noDataMaskView) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, APP_SCREEN_WIDTH, 40)];
        
        label.text = @"暂无联系人";
        
        label.textAlignment = 1;
        
        [view addSubview:label];
        
        [self.view addSubview:view];
        
        _noDataLabel = label;
        
        _noDataMaskView = view;
        
    }
    
    return _noDataMaskView;
    
}


@end
