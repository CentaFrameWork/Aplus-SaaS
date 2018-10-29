//
//  SearchVC.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/16.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "NewSearchVC.h"
#import "SelectBtnView.h"
#import "SearchListCell.h"
#import "AllRoundVC.h"

#import "SearchPropApi.h"
#import "SearchPropertyManager.h"
#import <iflyMSC/iflyMSC.h>


#define SearchEstateTF_Tag  1000
#define SearchHouseNum_Tag  2000
#define HeadView_Height  200*NewRatio

typedef enum : NSUInteger {
    EstateSearch,   // 按楼盘栋座进行搜索
    PropNOSearch,   // 按房源编号进行搜索
} SearchType;

@interface NewSearchVC ()<SelectBtnDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,IFlyRecognizerViewDelegate>
{
    IBOutlet UIView *_headerView;                   // 头视图
    __weak IBOutlet SelectBtnView *_selectView;     // 选择视图

    __weak IBOutlet UITextField *_searchEstateTF;   // 搜索楼盘栋座/房源编号TextField
    __weak IBOutlet UITextField *_searchHouseNumTF; // 搜索房号TextField
    IFlyRecognizerView  *_iflyRecognizerView;
    UITableView *_mainTableView;

    SearchPropApi *_searchPropApi;
    DataBaseOperation *_dataBaseOperation;          // 数据库操作类
    SearchPropDetailEntity *_searchEntity;          // 选中的某条搜索记录
    SearchPropertyManager *_searchPropManager;
    NSArray *_historyArray;                         // 搜索历史记录
    NSArray *_dataArr;

    BOOL _isSearchNow;                              // 是否要进行搜索
    BOOL _isHistoryData;                            // 显示数据是否为搜索的历史记录

    NSString *_searchPropText;                      // 搜索内容
    SearchType _searchType;                         // 按什么方式进行搜索
    CGFloat _headerHeight;
}

@end

@implementation NewSearchVC

- (void)viewDidLoad {
    _isNewVC = YES;
    [super viewDidLoad];

  

    _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
    _estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
    _searchType = EstateSearch;

    [self initView];

    //获取搜索历史记录
    [self getSearchHistoryData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setNavTitle:@"搜索"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"back"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    // 设置电池条为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isOpenVoice)
    {
        [self voiceSearchAction:nil];
    }
}


- (void)initView
{
    // 头视图
    _headerHeight = HeadView_Height;
    _selectView.titleArr = @[@"楼盘地址",@"房源编号"];
    _selectView.selectBtnDelegate = self;
    [self setHeaderViewFrameWithHiddenHouseNumTF:YES];

    UIView *searchView = [_headerView viewWithTag:1111];
    searchView.layer.shadowOffset = CGSizeMake(0, 0);
    searchView.layer.shadowColor = [UIColor blackColor].CGColor;
    searchView.layer.shadowRadius = 10*NewRatio;
    searchView.layer.shadowOpacity = 0.05;
    _searchEstateTF.delegate = self;
    _searchHouseNumTF.delegate = self;
    [self.view addSubview:_headerView];
    
    
    // 表视图
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headerHeight-65*NewRatio, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - (_headerHeight-65*NewRatio)) style:UITableViewStylePlain];
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
    
    
}


- (void)getSearchHistoryData
{
    NSArray *history = [[NSArray alloc] initWithArray:[[_dataBaseOperation selectSearchResultType:PropListSearchType]
                                                   objectForKey:PropListSearchType]];

    NSMutableArray *mArr = [NSMutableArray array];
    for (NSString *jsonStr in history)
    {
        NSDictionary *dic = [jsonStr jsonDictionaryFromJsonString];
        SearchPropDetailEntity *entity = [DataConvert convertDic:dic
                                                        toEntity:[SearchPropDetailEntity class]];

        [mArr addObject:entity];
    }
    _historyArray = mArr;
    mArr = nil;

    if (_historyArray.count == 0)
    {
        _mainTableView.hidden = YES;
        _isHistoryData = NO;
    }
    else
    {
        _isHistoryData = YES;
    }
}

- (void)setHeaderViewFrameWithHiddenHouseNumTF:(BOOL)isHidden
{
    
    _headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, _headerHeight);
    _searchHouseNumTF.hidden = isHidden;
    _mainTableView.top = _headerHeight;
    _mainTableView.height = APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - _headerHeight;
    if (isHidden) {
        _mainTableView.frame = CGRectMake(0, _headerHeight-65*NewRatio, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - (_headerHeight-65*NewRatio));
    }else {
        _mainTableView.frame = CGRectMake(0, _headerHeight, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - _headerHeight);
    }

}

#pragma mark - BtnClick

/// 清空搜索记录
- (void)clearHistoryDataAction:(UIButton *)btn
{
    [_dataBaseOperation deleteSearchResultWithType:PropListSearchType];
    _historyArray = nil;
    [_mainTableView reloadData];
}


#pragma mark - RequestData

- (void)requestData
{
    _searchPropApi = [[SearchPropApi alloc] init];
    _searchPropApi.name = _searchPropText;
    _searchPropApi.topCount = @"50";
    _searchPropApi.estateSelectType = _estateSelectType;
    _searchPropApi.buildName = @"";
    [_manager sendRequest:_searchPropApi];

    [self showLoadingView:nil];
}

#pragma mark - <IFlyRecognizerViewDelegate>

/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSDictionary *vcnJson = [[NSDictionary alloc]initWithDictionary:[resultArray objectAtIndex:0]];

    if (resultArray.count == 0)
    {
        return;
    }

    /**
     *  语音输入后返回的内容格式...
     *
     *  {
     bg = 0;
     ed = 0;
     ls = 0;
     sn = 1;
     ws =     (
     {
     bg = 0;
     cw =
     (
     {
     sc = "-101.93";
     w = "\U5582";
     }
     );
     },
     );
     }
     */

    NSString *vcnValue = [[vcnJson allKeys] objectAtIndex:0];
    NSData *vcnData = [vcnValue dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error = nil;
    NSDictionary *vcnDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:vcnData
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:&error];

    NSMutableString *vcnMutlResultValue = [[NSMutableString alloc]init];

    // 语音结果最外层的数组
    NSArray *vcnWSArray = [[NSArray alloc]initWithArray:[vcnDic objectForKey:@"ws"]];

    for (int i = 0; i < vcnWSArray.count; i ++)
    {
        NSMutableDictionary *vcnWSDic = [vcnWSArray objectAtIndex:i];
        NSArray *vcnCWArray = [vcnWSDic objectForKey:@"cw"];
        NSDictionary *vcnCWDic = [vcnCWArray objectAtIndex:0];

        [vcnMutlResultValue appendFormat:@"%@",[vcnCWDic objectForKey:@"w"]];
    }

    if (![vcnMutlResultValue isEqualToString:@""] && vcnMutlResultValue)
    {
        if (_searchPropText)
        {
            _searchPropText = [_searchPropText stringByAppendingString:vcnMutlResultValue];
        }
        else
        {
            _searchPropText = vcnMutlResultValue;
        }

        _searchEstateTF.text = _searchPropText;

        if (_searchType == EstateSearch)
        {
            [self requestData];
        }
        else
        {
            [_searchEstateTF becomeFirstResponder];
        }
    }
}

/// 识别会话错误
- (void)onError: (IFlySpeechError *) error
{

}


#pragma mark - <SelectBtnDelegate>

- (void)didSelectWithBtnIndex:(NSInteger)selectBtnIndex
{
    _searchEntity = nil;
    _searchPropText = nil;
    _dataArr = nil;
    _searchEstateTF.text = nil;
    _searchHouseNumTF.text = nil;
    _searchHouseNumTF.hidden = YES;
    _isHistoryData = NO;
    [_searchEstateTF resignFirstResponder];
    [_searchHouseNumTF resignFirstResponder];
    _headerHeight = HeadView_Height;

    [self setHeaderViewFrameWithHiddenHouseNumTF:YES];

    if (selectBtnIndex == 0)
    {
        // 搜索楼盘栋座
        _searchType = EstateSearch;
        _searchEstateTF.placeholder = @"输入城区、片区、楼盘名";
    }
    else
    {
        // 搜索房源编号
        _searchType = PropNOSearch;
        _searchEstateTF.placeholder = @"输入房源编号";
    }

    [_mainTableView reloadData];
}

- (void)turnToPropListVc
{
    // 默认全部
    NSInteger extendAttrNmuber = EstateSelectTypeEnum_ALLNAME;

    if ([_searchEntity.extendAttr isEqualToString:@"楼盘"])
    {
        extendAttrNmuber = EstateSelectTypeEnum_ESTATENAME;
    }
    else if ([_searchEntity.extendAttr isEqualToString:@"行政区"])
    {
        extendAttrNmuber = EstateSelectTypeEnum_DISTRICTNAME;
    }
    else if ([_searchEntity.extendAttr isEqualToString:@"地理片区"])
    {
        extendAttrNmuber = EstateSelectTypeEnum_REGIONNAME;
    }
    else if ([_searchEntity.extendAttr isEqualToString:@"楼栋"])
    {
        extendAttrNmuber = EstateSelectTypeEnum_BUILDINGBELONG;
    }
    
    NSString *extendAttrNmubeStr = [NSString stringWithFormat:@"%ld",(long)extendAttrNmuber];
    
    if (self.moduleSearchType == AllRoundSearch)
    {
        // 房源列表
        if (_block)
        {
            if (!_searchEntity)
            {
                _searchEntity = [[SearchPropDetailEntity alloc] init];
            }
            _searchEntity.extendAttr = extendAttrNmubeStr;
            if (_searchType == PropNOSearch && _searchPropText.length > 0)
            {
                // 房源编号搜索
                _searchEntity.itemText = _searchPropText;
                _block(_searchEntity,YES);
            }
            else
            {
                _block(_searchEntity,NO);
            }
        }
        [self back];
    
    }else{
        
        EstateListVC *vc = [[EstateListVC alloc] init];
        vc.isPropList = NO;
        vc.isFromSearchPage = YES;
        vc.propType = WARZONE;
        vc.estateSelectType = extendAttrNmubeStr;
        vc.moduleSearchType = self.moduleSearchType;

        NSString *searchStr = _searchEntity.itemText;
        if (_searchType == EstateSearch && _searchEntity.houseNo.length > 0)
        {
            // 楼盘栋座搜索
            searchStr = [NSString stringWithFormat:@"%@，%@",_searchEntity.itemText,_searchEntity.houseNo];
            vc.houseNo = _searchEntity.houseNo;
        }

        if (_searchType == PropNOSearch && _searchPropText.length > 0)
        {
            // 房源编号搜索
            searchStr = _searchPropText;
            vc.propNo = _searchPropText;
        }

        if (searchStr.length > 0)
        {
            vc.searchKeyWord = searchStr;
        }


        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - <UITextFieldDelegate>

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (_searchType == EstateSearch) {
        
        if (textField.tag == SearchEstateTF_Tag) {
            // 搜索楼盘、栋座等
            if (_searchHouseNumTF.hidden == NO)
            {
                _headerHeight = HeadView_Height;
                [self setHeaderViewFrameWithHiddenHouseNumTF:YES];
            }
            _searchPropText = inputString;
            [self requestData];
        }else{
            
            // 搜索房号(最多15位)
            if (range.length == 0 && range.location > 25){
                return NO;
            }

            _searchEntity.houseNo = inputString;
        }
    
        
        
    }else if (_searchType == PropNOSearch) {
        
        // 搜索房源编号(最多25位)
        if (range.length == 0 && range.location > 24)
        {
            return NO;
        }
        // 搜索房源编号
        _searchPropText = inputString;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_searchType == EstateSearch)
    {
        if (_searchEntity == nil)
        {
            showMsg(@"请在智能提示中选择!");
            return NO;
        }
        // 保存历史记录
        if (_searchHouseNumTF.hidden == NO)
        {
            // 跳转到房源列表，保存历史记录
            NSDictionary *dic = [DataConvert convertEntityToDic:_searchEntity];
            NSString *jsonStr = [dic JSONString];
            [_dataBaseOperation insertSearchResult:PropListSearchType andValue:jsonStr];

            [self turnToPropListVc];
            
        }
    }
    else if (_searchType == PropNOSearch)
    {
        // 搜索房源编号
        NSLog(@"%@",_searchPropText);

        // 判断输入内容是否全是空格
        BOOL isEmptyName = [NSString isEmptyWithLineSpace:_searchPropText];

        if (isEmptyName)
        {
            _searchPropText = nil;
        }
        [self turnToPropListVc];
    }

    return YES;
}


#pragma mark - 语音输入

- (IBAction)voiceSearchAction:(UIButton *)sender
{
    if ([_searchEstateTF isFirstResponder])
    {
        [_searchEstateTF resignFirstResponder];
    }

    __weak typeof (self) weakSelf = self;

    // 检测麦克风功能是否打开
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {

        if (granted)
        {
            // 初始化语音识别控件
            if (!_iflyRecognizerView)
            {
                _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
                [_iflyRecognizerView setParameter:@"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];

                // asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
                [_iflyRecognizerView setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];

                // 设置有标点符号
                [_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT]];
                [_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT_HAVEDOT]];
            }

            _iflyRecognizerView.delegate = weakSelf;
            [_iflyRecognizerView start];
        }
        else
        {
            showMsg(SettingMicrophone);
        }
    }];


}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isHistoryData && _historyArray)
    {
        return _historyArray.count;
    }
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_isHistoryData && _historyArray)
    {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_isHistoryData && _historyArray)
    {
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 50*NewRatio);
        [clearBtn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        clearBtn.titleLabel.font = [UIFont systemFontOfSize:14*NewRatio];
        [clearBtn addTarget: self
                     action:@selector(clearHistoryDataAction:)
           forControlEvents:UIControlEventTouchUpInside];

        return clearBtn;
    }

    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchListCell *cell = (SearchListCell *)[tableView cellFromXib:@"SearchListCell"];

    if (_isHistoryData)
    {
        if (_historyArray.count > 0)
        {
            cell.entity = _historyArray[indexPath.row];
        }
    }
    else
    {
        if (_dataArr.count > 0)
        {
            cell.entity = _dataArr[indexPath.row];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchPropDetailEntity *entity;
    
    if (_isHistoryData)
    {
        // 搜索历史数据
        entity = _historyArray[indexPath.row];
    }
    else
    {
        // 搜索结果
        entity = _dataArr[indexPath.row];
    }
    
    _searchEstateTF.text = entity.itemText;
    [_searchEstateTF resignFirstResponder];
    _searchEntity = entity;

    //是否是楼盘
    BOOL isBuilding = [entity.extendAttr isEqualToString:@"楼盘"];
    //是否含有房号
    BOOL isHasHouseNO = entity.houseNo.length > 0;
    
    if (isBuilding && isHasHouseNO == false) {//有楼盘无房号才继续提示显示房号
        // 可以查找房号
        _headerHeight = HeadView_Height;
        [self setHeaderViewFrameWithHiddenHouseNumTF:NO];
        [_searchHouseNumTF becomeFirstResponder];
    
    }else{
        
         // 不可以查找房号（历史记录搜索/城区片区）保存历史记录
        NSDictionary *dic = [DataConvert convertEntityToDic:_searchEntity];
        NSString *jsonStr = [dic JSONString];
        [_dataBaseOperation insertSearchResult:PropListSearchType andValue:jsonStr];
        [self turnToPropListVc];
    }
}

// 滑动调用
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
//}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    [super dealData:data andClass:modelClass];

    if ([modelClass isEqual:[SearchPropEntity class]])
    {
        _isHistoryData = NO;
        SearchPropEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        _dataArr = entity.propPrompts;
        if (_dataArr.count > 0)
        {
            _mainTableView.hidden = NO;
        }
        [_mainTableView reloadData];
    }


}

@end
