//
//  SearchBuildingVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/4/20.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SearchBuildingVC.h"
#import "JMSelectPropertyViewController.h"

#import "SearchViewCell.h"


#import "SearchPropApi.h"
#import "SearchPropEntity.h"
#import "SearchPropDetailEntity.h"

#import "UITableView+Category.h"

@interface SearchBuildingVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    UITableView *_tableView;
    UITextField *_searchTF;

    NSArray *_dataArr;
    NSString *_buildingName;    //栋座名
}

@end

@implementation SearchBuildingVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:nil
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];


    // 设置UI
    [self initUI];

    // 请求数据
    [self requestData];

}


#pragma mark - init

- (void)initUI {
    
    self.navigationItem.title = self.estateName;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

#pragma mark - RequestData

- (void)requestData {
    SearchPropApi *searchPropApi = [[SearchPropApi alloc] init];
    searchPropApi.name = _estateName;
    searchPropApi.buildName = _buildingName;
    searchPropApi.topCount = @"500";
    searchPropApi.estateSelectType = [NSString stringWithFormat:@"%d", EstateSelectTypeEnum_BUILDINGBELONG];
    [_manager sendRequest:searchPropApi];
    [self showLoadingView:nil];
}

#pragma mark - <UITextFieldDelegate>

- (void)tfDidChangeNotifi:(NSNotification *)notification {
    _buildingName = _searchTF.text;
    [self requestData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    _buildingName = textField.text;
    
    return YES;
}

#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellString = @"SearchViewCell";
    
    SearchViewCell * cell = [tableView tableViewCellByNibWithIdentifier:CellString];
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    SearchPropDetailEntity *entity = [_dataArr objectAtIndex:indexPath.row];
    
    cell.leftLabelTitle.text = entity.itemText;
    
    cell.rightLabelTitle.text = @"";
    
    cell.bracketsLabel.text = @"";

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchPropDetailEntity *entity = [_dataArr objectAtIndex:indexPath.row];
    NSString *extendAttr = entity.extendAttr;
    NSInteger extendAttrNmuber = 0;
    if ([extendAttr isEqualToString:@"楼盘"])
    {
        extendAttrNmuber = EstateSelectTypeEnum_ESTATENAME;
    }
    else if ([extendAttr isEqualToString:@"行政区"])
    {
        extendAttrNmuber = EstateSelectTypeEnum_DISTRICTNAME;
    }
    else if ([extendAttr isEqualToString:@"地理片区"])
    {
        extendAttrNmuber = EstateSelectTypeEnum_REGIONNAME;
    }
    else if ([extendAttr isEqualToString:@"楼栋"])
    {
        extendAttrNmuber = EstateSelectTypeEnum_BUILDINGBELONG;
    }

    NSString *extendAttrNmubeStr = [NSString stringWithFormat:@"%ld",(long)extendAttrNmuber];

    if (_isFromTrustAuditing)
    {
        [_searchTF resignFirstResponder];
        [self.searchBuildingNameDelagate searchBuildingWithBuildingName:entity.itemText
                                                        andBuidingKeyId:entity.itemValue];
        [self back];

    }
    else
    {
        JMSelectPropertyViewController *vc = [[JMSelectPropertyViewController alloc] init];
        vc.searchText = [NSString stringWithFormat:@"%@-%@",_estateName,entity.itemText]; // 楼盘名－栋座名
        vc.extendAttr = extendAttrNmubeStr; // 搜索类型
        vc.itemvalue = entity.itemValue;

        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([_searchTF isFirstResponder])
    {
        [_searchTF resignFirstResponder];
    }
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass {
    if ([modelClass isEqual:[SearchPropEntity class]])
    {
        SearchPropEntity *searchPropEntity = [DataConvert convertDic:data toEntity:modelClass];
        _dataArr = searchPropEntity.propPrompts;
        [_tableView reloadData];
    }
}

@end
