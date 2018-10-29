//
//  NewTakeLookRecordViewController.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "NewTakeLookRecordViewController.h"
#import "TakeLookViewController.h"
#import "SearchRemindPersonViewController.h"
#import "SelectCustomerVC.h"
#import "SearchViewController.h"
#import "TZImagePickerController.h"
#import "SelectPropertyVC.h"

#import "NewTakeLookFirstCell.h"
#import "NewTakeLookSecondCell.h"
#import "NewTakeLookThirdCell.h"
#import "NewTakeLookFourthCell.h"
#import "UploadSeeEstateListCell.h"
#import "ApplyRemindPersonCollectionCell.h"
#import "CustomerFedCell.h"
#import "TakingToTakedCell.h"
#import "JMRemindTimeCell.h"


#import "TakeSeeAddApi.h"
#import "PropPageDetailEntity.h"
#import "CustomerEntity.h"
#import "PropertysModelEntty.h"
#import "SelectPropertyEntity.h"
#import "TCPickView.h"
#import "CustomActionSheet.h"

#import "ZYCodeName.h"

#import "NSString+Extension.h"
#import "UITableView+Category.h"

#import "NewAddtakingCell.h"

#import "FollowUpContentCell.h"
#import <iflyMSC/iflyMSC.h>
#import "OpeningPersonCell.h"


#define DeleteRemindPersonBtnTag        2002

@interface NewTakeLookRecordViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,
    UICollectionViewDataSource,SearchRemindPersonDelegate,SearchResultDelegate,UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,TCPickViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,doneSelect,
    TZImagePickerControllerDelegate,CustomerFedCellDelegate,UITextViewDelegate,IFlyRecognizerViewDelegate>
{
    
    __weak IBOutlet UITableView *_mainTableView;
    
    UICollectionView *_remindPersonCollectionView;  //显示提醒人collectionView
    UIImagePickerController *_imagePickerController;
    
    
    
    NSInteger _remindPersonHeight;                  //提醒人高度
    
    
    UIImage *_uploadSeeImg;                         //上传看房单图片
    NSString *_uploadSeeStr;                        //上传看房单的路径
    
    BOOL _isSelectLookWithPeopleId;                 //点击选择陪看人还是提醒人
    
//    BOOL _hasPickView;         //是否页面上存在时间选择器
    NSString *_price;//输入的租价或者售价
//    NSInteger _selectTextViewIndex;
    
    NSInteger _sectionSum;                      // 表视图总组数

//    NSMutableDictionary *_selectPropertyDic;    // 选择的约看房源字典集合
    
    IFlyRecognizerView  *_iflyRecognizerView; // 语音输入
    
    SearchRemindType _selectRemindType;          // 选择的提醒人类型（部门／人员）
    
    
    
    
    
    
    CustomerEntity *_selectCustomerEntity;      //选择客户实体
    NSDictionary *_takeLookTypeDict;    // 选项
    NSString *_optionsStr;              // 值
    
    NSMutableArray *_fangyuanhebeizhu;      // 数组里面是字典，房源实体，房源备注
//    PropertysModelEntty *_selectProrertyEntity;  //选择房源实体
    NSString *_lookWithPeopleId;                    //陪看人id
    NSString *_lookWithPeopleName;                   //陪看人名字
    NSString * _takeSeeTime;                        //带看时间
    NSString * _TakeSeeWeekTime;                    //带星期的带看时间
    NSMutableArray *_remindPersonsArr;              //提醒人、部门数组
    NSMutableArray *_remindPersons;             // 提醒人数组
    NSMutableArray *_remindDepts;               // 提醒部门数组
    NSString *_remindTime;                          // 提醒时间
    
    CGFloat _viewHeight;                        // 提醒人高度
    NSInteger _dijizu;                                 // 添加的是第几组的房源
    NSInteger _tagValue;                  // 用来判断是哪个cell的语音输入
    NSString *_appendContent;                       // 信息补充内容
}

@end

@implementation NewTakeLookRecordViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _takeLookTypeDict = @{@"看售":@"20",@"看租":@"10"};
    _optionsStr = [[NSString alloc] init];  _optionsStr = nil;
    _fangyuanhebeizhu = [[NSMutableArray alloc] init];
    [_fangyuanhebeizhu addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"房源跟进", nil]];
    
    _remindPersonsArr = [NSMutableArray array]; // 提醒人显示总数组
    _remindPersons = [NSMutableArray array];    // 提醒人员数组
    _remindDepts = [NSMutableArray array];      // 提醒部门数组
    _viewHeight = 0;
    
    [self initView];
    [self initData];
    
}


//// 当键盘出现或改变时调用
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    if (_selectTextViewIndex >= 0) {
//        if (_selectTextViewIndex == 0)
//        {
//            _mainTableView.bottom = APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - 100;
//        }
//        else
//        {
//            _mainTableView.bottom = APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - 100;
//        }
//    }
//}
//
//// 当键盘退出时调用
//- (void)keyboardWillHide:(NSNotification *)notification{
//    if (_selectTextViewIndex >= 0)
//    {
//        _mainTableView.bottom = APP_SCREEN_HEIGHT - APP_NAV_HEIGHT;
//    }
//    _selectTextViewIndex = -1;
//}

-(void)initView
{
    // 隐藏cell分割线
    _mainTableView.separatorStyle = NO;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    [self setNavTitle:@"新增带看"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(submitGoOutMethod)]];
    
    /**
     * 初始化相机对象
     */
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = NO;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
}

-(void)initData
{
    _lookWithPeopleName = [[NSString alloc] init]; _lookWithPeopleName = nil;
    _takeSeeTime = [CommonMethod getSysDateStrWithFormat:YearToMinFormat];
    _TakeSeeWeekTime = [CommonMethod getSystemTime];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCustomerNotification:) name:@"SelectCustomer" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPropertyNotification:) name:@"SelectProperty" object:nil];
    _sectionSum = 5;

}



#pragma mark-  提交方法
-(void)submitGoOutMethod
{
    
    [self.view endEditing:YES];
    [CommonMethod resignFirstResponder];

    //判断客源是否为空
    if (_selectCustomerEntity == nil) {
        showMsg(@"请输入带看客户！");
        return;
    }
    
    if (_optionsStr == nil) {
        showMsg(@"请选择带看类型！");
        return;
    }
    
    
    // 判断房源和房源跟进是否为空
    for (int i=0; i<_fangyuanhebeizhu.count; i++) {
        NSMutableDictionary *muDict = _fangyuanhebeizhu[i];
        if (muDict[@"房源实体"] == nil) {
            showMsg(@"必须选择带看房源！");
            return;
        }
        //判断输入内容是否全是空格
        BOOL isEmpty = [NSString isEmptyWithLineSpace:muDict[@"房源跟进"]];
        if ( muDict[@"房源跟进"] == nil || [NSString isEmptyWithLineSpace:muDict[@"房源跟进"]]  || isEmpty){
            showMsg(@"请输入带看客户反馈！");
            return;
        }
    }
    
    if (_remindTime.length > 0)
    {
        if([CommonMethod compareCurrentTime:_remindTime andFormat:YearToMinFormat] < 0)
        {
            showMsg(@"提醒不得早于或等于当前时间！");
            return;
        }
    }
    
//    [self showLoadingView:@"正在提交"];
    showLoading(@"正在提交");
    
    //有看房单上传图片
    if (_uploadSeeImg) {
        //网络请求管理器
        AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
        //JSON
        sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [sessionManager POST:[[BaseApiDomainUtil getApiDomain] getImageServerUrl] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
            // 上传图片
            UIImage *image = _uploadSeeImg;
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = CompleteNoFormat;
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/png"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //图片上传成功
            NSString *imageUrl = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString * imageName = @"";
            NSArray *strArr = [imageUrl componentsSeparatedByString:@"/"];
            imageName = [strArr lastObject];
        
            // 图片上传成功之后上传数据
            [self submitTakeSeeToServer:imageName andImageUrl:imageUrl];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            hiddenLoading();
//            [self hiddenLoadingView];
            showMsg(@"网络连接已中断");
            NSLog(@"error ===== %@",error);
        }];
    }else{
        
        // 没有图片的直接上传数据
        [self submitTakeSeeToServer:@"" andImageUrl:@""];
    }
}

#pragma mark - ***提交***
-(void)submitTakeSeeToServer:(NSString *)imageName andImageUrl:(NSString *)imageUrl {
    hiddenLoading();
    
    NSMutableArray *muArray = [[NSMutableArray alloc] init];
    for (int i=0; i<_fangyuanhebeizhu.count; i++) {
        NSMutableDictionary *muDict = _fangyuanhebeizhu[i];
        PropertysModelEntty* selectProrertyEntity = (PropertysModelEntty *)muDict[@"房源实体"];
        NSMutableDictionary *muDict2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:muDict[@"房源跟进"],@"Content",selectProrertyEntity.keyId,@"PropertyKeyId", nil];
        [muArray addObject:muDict2];
    }
    
    NSDictionary *dict = @{@"InquiryKeyId":_selectCustomerEntity.customerKeyId==nil?@"":_selectCustomerEntity.customerKeyId,
                           @"SeePropertyType":_takeLookTypeDict[_optionsStr]==nil?@"":_takeLookTypeDict[_optionsStr],
                           @"LookWithKeyId":_lookWithPeopleId==nil?@"":_lookWithPeopleId,
                           @"LookWithUserName":_lookWithPeopleName==nil?@"":_lookWithPeopleName,
                           @"TakeSeeTime":_takeSeeTime==nil?@"":_takeSeeTime,
                           @"MsgDeptKeyIds":_remindDepts==nil?@"":_remindDepts,
                           @"MsgUserKeyIds":_remindPersons==nil?@"":_remindPersons,
                           @"MsgTime":_remindTime==nil?@"":_remindTime,
                           @"AttachmentName":imageName==nil?@"":imageName,
                           @"AttachmentPath":imageUrl==nil?@"":imageUrl,
                           @"TakeSeeContent":muArray==nil?@"":muArray
                           };
    
    //陈行新增
    NSArray * arr = @[dict];
    
    dict = @{@"TakeSees" : arr};
    
    [AFUtils POST:ApiInquiryAddTakeseeFollow parameters:dict controller:self successfulDict:^(NSDictionary *successfuldict) {
        [CustomAlertMessage showAlertMessage:@"新增带看成功" andButtomHeight:(APP_SCREEN_HEIGHT- 64)/2];
        
        if (self.isFromHomePage) {
            // 跳转到带看列表
            TakeLookViewController *vc = [[TakeLookViewController alloc] init];
            vc.isPopToRoot = self.isFromHomePage;
            // 取消所有通知
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            // 取消所有通知
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self .navigationController popViewControllerAnimated:YES];
        }
        
        if ([_delegate respondsToSelector:@selector(addTakeSeeSuccess)]) {
            [_delegate performSelector:@selector(addTakeSeeSuccess)];
        }
        
    } failureDict:^(NSDictionary *failuredict) {
        showMsg(@"提交失败，请重试!");
    } failureError:^(NSError *failureerror) {
        showMsg(@"提交失败，请重试!");
    }];
   
}

- (void)back {
    // 取消所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self .navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加提醒人
/**
 *  添加提醒人
 */
- (void)clickAddRemindPersonMethod
{
    
    [NewUtils popoverSelectorTitle:@"请选择" listArray:@[@"部门",@"人员"] theOption:^(NSInteger optionValue) {
        //添加提醒人
        NSString *selectRemindTypeStr;
        
        switch (optionValue) {
            case 0:
            {
                //部门
                _selectRemindType = DeparmentType;
                selectRemindTypeStr = DeparmentRemindType;
            }
                break;
            case 1:
            {
                //人员
                _selectRemindType = PersonType;
                selectRemindTypeStr = PersonRemindType;
            }
                break;
                
            default:
            {
                return;
            }
                break;
        }
        
        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
                                                                  initWithNibName:@"SearchRemindPersonViewController"
                                                                  bundle:nil];
        searchRemindPersonVC.selectRemindType = _selectRemindType;
        searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
        searchRemindPersonVC.isExceptMe = NO;
        searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
        searchRemindPersonVC.delegate = self;
        [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
    }];
    
}


#pragma mark - 删除提醒人
- (void)deleteRemindPersonMethod:(UIButton *)btn {
    NSInteger deleteItemIndex = btn.tag - DeleteRemindPersonBtnTag;
    
    RemindPersonDetailEntity *entity = [_remindPersonsArr objectAtIndex:deleteItemIndex];
    [_remindDepts removeObject:entity.resultKeyId];             // 删除部门数据
    [_remindPersons removeObject:entity.resultKeyId];           // 删除人员数据
    [_remindPersonsArr removeObjectAtIndex:deleteItemIndex];    // 删除数据
    [_remindPersonCollectionView reloadData];                   // 刷新CollectionView
    [_mainTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];   // 刷新TableView
}

#pragma mark-选择的客户完成后
- (void)selectCustomerNotification:(NSNotification *)notifi{
    _selectCustomerEntity = (CustomerEntity *)notifi.object;
    [_mainTableView reloadData];
    
}

#pragma mark-选择房源完成后
- (void)selectPropertyNotification:(NSNotification *)notifi{
    PropertysModelEntty* selectProrertyEntity = (PropertysModelEntty *)notifi.object;
    
    int abcd = 0;
    for (int i=0; i<_fangyuanhebeizhu.count; i++) {
        PropertysModelEntty* selectProrertyEntity123 = (PropertysModelEntty *)(_fangyuanhebeizhu[i][@"房源实体"]);
        if (selectProrertyEntity123) {
            if ([selectProrertyEntity123.keyId isEqualToString:selectProrertyEntity.keyId]) {
                showMsg(@"不可添加重复房源！");
                abcd = 1;
                break;
            }
        }
    }
    
    if (abcd == 0) {
        NSMutableDictionary *mudict = _fangyuanhebeizhu[_dijizu];
        [mudict setObject:selectProrertyEntity forKey:@"房源实体"];
        [_mainTableView reloadData];
    }    
}


#pragma mark - ImgPickerControlDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    _uploadSeeImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData * imageData=UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.3);
    _uploadSeeStr = [imageData base64EncodedStringWithOptions:0];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_mainTableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <SearchRemindPersonDelegate>
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem {
    
    // 配看人员
    if (_isSelectLookWithPeopleId) {
        _lookWithPeopleId = selectRemindItem.resultKeyId;
        _lookWithPeopleName = selectRemindItem.resultName;
        [_mainTableView reloadData];
        _isSelectLookWithPeopleId = NO;
        return;
    }
    
    if (_selectRemindType == DeparmentType) {
        //部门 如果是部门添加到部门数组
        [_remindDepts addObject:selectRemindItem.resultKeyId];
    } else {
        //人员 如果输入人员添加到人员数组
        [_remindPersons addObject:selectRemindItem.resultKeyId];
    }
    [_remindPersonsArr addObject:selectRemindItem]; // 添加到显示总数组
    [_remindPersonCollectionView reloadData];       // 刷新CollectionView
    [_mainTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1]; // 刷新TableView
}

- (void)returnText:(NSString *)text{
    _lookWithPeopleId = @"";
    _lookWithPeopleName = text;
    [_mainTableView reloadData];
//    NSIndexPath *indexPth = [NSIndexPath indexPathForRow:0 inSection:_sectionSum - 2];
//    [_mainTableView reloadRowsAtIndexPaths:@[indexPth] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark-<SearchResultDelegate>
- (void)searchResultWithKeyword:(NSString *)keyword andExtendAttr:(NSString *)extendAttr andItemValue:(NSString *)itemvalue andHouseNum:(NSString *)houseNum
{
    SelectPropertyVC *vc = [[SelectPropertyVC alloc] init];
    vc.searchText = keyword;
    vc.extendAttr = extendAttr;
    vc.itemvalue = itemvalue;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - <UITableViewDelegate/DataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionSum;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == _sectionSum - 2){
        return 4;
    }else if (section == _sectionSum - 1){
        return 1;
    }else {
        if (_sectionSum > 5)
        {
            return 3;
        }
        return 2;
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NewAddtakingCell *firstCell = [[[NSBundle mainBundle] loadNibNamed:@"NewAddtakingCell" owner:nil options:nil] lastObject];
    NewTakeLookSecondCell *secondCell = [NewTakeLookSecondCell cellWithTableView:tableView];
    secondCell.lineView.hidden = NO;
    UploadSeeEstateListCell *fifthCell = [UploadSeeEstateListCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        
        firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
        firstCell.section = indexPath.section;
        firstCell.content = _selectCustomerEntity.customerName;
        firstCell.theName.text = @"带看客户";
        [[firstCell.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            SelectCustomerVC *vc = [[SelectCustomerVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [[firstCell.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            //删除客源
            _selectCustomerEntity = nil;
            [_mainTableView reloadData];
        }];
        
        return firstCell;

        
    }
    else if (indexPath.section == 1){
        switch (indexPath.row) {
                
            case 0:
            {
                secondCell.leftTitle.text = @"带看类型";
                if (_optionsStr == nil) {
                    secondCell.rightTitle.text = @"请选择带看类型";
                }else {
                    secondCell.rightTitle.text = _optionsStr;
                }
                return secondCell;
            }
                break;
            case 1:
            {
                // 新增约看
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH-164*NewRatio, 12*NewRatio, 152*NewRatio, 36*NewRatio)];
                view.layer.cornerRadius = 5*NewRatio;
                view.clipsToBounds = YES;
                view.backgroundColor = YCButtonColorGreen;
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(21*NewRatio, 11*NewRatio, 14*NewRatio, 14*NewRatio)];
                imageView.image = [UIImage imageNamed:@"新增"];
                [view addSubview:imageView];
                
                UILabel *labelStr = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+13*NewRatio, 0, 100*NewRatio, 36*NewRatio)];
                labelStr.text = @"新增带看房源";
                labelStr.textColor = [UIColor whiteColor];
                labelStr.font = [UIFont systemFontOfSize:14*NewRatio];
                [view addSubview:labelStr];
                
              
                    [cell.contentView addSubview:view];
                
                return cell;
            }
                break;
                
            default:
                break;
        }
    }
   
    else if (indexPath.section == _sectionSum - 2){
        if (indexPath.row == 0) {
            secondCell.leftTitle.text = @"陪看人员";
            secondCell.rightTitle.text = _lookWithPeopleName ? : @"请输入陪看人姓名";
            return secondCell;
        }else if (indexPath.row == 1){
            secondCell.leftTitle.text = @"带看时间";
            secondCell.rightTitle.text = _TakeSeeWeekTime ? : @"请选择带看时间";
            secondCell.lineView.hidden = YES;
            return secondCell;
        }else if (indexPath.row == 2){
            //提醒人
            NSString *identifier = @"openingPersonCell";
            OpeningPersonCell * openingPersonCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!openingPersonCell) {
                [tableView registerNib:[UINib nibWithNibName:@"OpeningPersonCell" bundle:nil] forCellReuseIdentifier:identifier];
                openingPersonCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
            }
            
            [openingPersonCell.addOpeningPersonBtn addTarget:self action:@selector(clickAddRemindPersonMethod) forControlEvents:UIControlEventTouchUpInside];
            openingPersonCell.leftPersonLabel.text = @"提醒人";
            _remindPersonCollectionView = openingPersonCell.showRemindListCollectionView;
            [_remindPersonCollectionView registerNib:[UINib nibWithNibName:@"ApplyRemindPersonCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"applyRemindPersonCollectionCell"];
            _remindPersonCollectionView.delegate = self;
            _remindPersonCollectionView.dataSource = self;
            
            return openingPersonCell;
            
        }else if (indexPath.row == 3){
            //提醒时间
            secondCell.leftTitle.text = @"提醒时间";
            secondCell.rightTitle.text = _remindTime ? : @"请选择提醒时间";
            return secondCell;
        }
        
    }else if (indexPath.section == _sectionSum - 1) {
        // 上传看房单
        fifthCell.uploadSeeImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *dateTapgg = [[UITapGestureRecognizer alloc] init];
        [[dateTapgg rac_gestureSignal]subscribeNext:^(id x) {}];
        [fifthCell addGestureRecognizer:dateTapgg];
        fifthCell.uploadSeeEstateBtn.layer.borderColor = YCThemeColorBackground.CGColor;
        fifthCell.uploadSeeEstateBtn.layer.borderWidth = 1;
        [fifthCell.uploadSeeEstateBtn addTarget:self action:@selector(uploadSeeEstateClick) forControlEvents:UIControlEventTouchUpInside];
        fifthCell.uploadSeeImage.image = _uploadSeeImg;
        fifthCell.uploadSeeImage.contentMode = UIViewContentModeScaleAspectFill; // 图片填充方式
        [fifthCell.cancelBtn addTarget: self action:@selector(cancelUploadSeeClick) forControlEvents:UIControlEventTouchUpInside];
        if (_uploadSeeImg) {
            fifthCell.uploadSeeImage.hidden = NO;
            fifthCell.cancelBtn.hidden = NO;
            
        }else{
            fifthCell.uploadSeeImage.hidden = YES;
            fifthCell.cancelBtn.hidden = YES;
        }
        return fifthCell;
    }else {
        
        if (indexPath.row == 0) {
            firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
            firstCell.section = indexPath.section;
            firstCell.theName.text = @"房源名称";
            NSMutableDictionary *muDict = _fangyuanhebeizhu[indexPath.section-2];
            PropertysModelEntty* selectProrertyEntity = (PropertysModelEntty *)muDict[@"房源实体"];
            if (selectProrertyEntity.estateName) {
                firstCell.content = [NSString stringWithFormat:@"%@%@%@",selectProrertyEntity.estateName,selectProrertyEntity.buildingName,selectProrertyEntity.houseNo];
            }else {
                firstCell.content = nil;
            }
            
            [[firstCell.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                _dijizu = indexPath.section-2;  // 记录给哪组添加房源
                SearchViewController *vc = [[SearchViewController alloc] init];
                vc.searchType = TopTextSearchType;
                vc.isFromMainPage = NO;
                vc.delegate = self;
                vc.fromModuleStr = From_Calendar;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [[firstCell.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                // 删除房源
                NSMutableDictionary *mudict = _fangyuanhebeizhu[indexPath.section-2];
                mudict[@"房源实体"] = nil;  // 把房源视图置空
                [_mainTableView reloadData];
            }];
            
            return firstCell;

            
        }else if (indexPath.row == 1){
            FollowUpContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"FollowUpContentCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lineView.hidden = YES;
            }
            cell.contentDescriptionLabel.text = @"看房反馈";
            NSMutableDictionary *muDict = _fangyuanhebeizhu[indexPath.section-2];
            cell.voiceInputBtn.tag = indexPath.section-2;
            cell.rightInputTextView.tag = indexPath.section-2;
            cell.rightInputTextView.text = muDict[@"房源跟进"];
            cell.rightInputTextView.delegate = self;
            [cell.voiceInputBtn addTarget:self action:@selector(voiceInputMethod:) forControlEvents:UIControlEventTouchUpInside];
            return  cell;
            
            
        }else if (indexPath.row == 2){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - 52*NewRatio, 18*NewRatio, 40*NewRatio, 14*NewRatio)];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = YCButtonColorRed;
            label.font = [UIFont systemFontOfSize:14*NewRatio];
            label.text = @"删除";
            [cell.contentView addSubview:label];
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 1)];
            lineView.backgroundColor = YCThemeColorBackground;
            [cell.contentView addSubview:lineView];
            return cell;
        }
    }
    return [[UITableViewCell alloc]init];
}

#pragma mark - <VoiceInputMethod>
- (void)voiceInputMethod:(UIButton *)button {
    [self.view endEditing:YES];
    
    __weak typeof (self) weakSelf = self;
    
    _tagValue = button.tag;
    NSMutableDictionary *muDict = _fangyuanhebeizhu[_tagValue];
    _appendContent = muDict[@"房源跟进"];
    
    
    //检测麦克风功能是否打开
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        
        if (granted) {
            //初始化语音识别控件
            if (!_iflyRecognizerView) {
                
                _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
                
                [_iflyRecognizerView setParameter:@"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
                
                //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
                
                [_iflyRecognizerView setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
                
                //设置有标点符号
                [_iflyRecognizerView setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
                [_iflyRecognizerView setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT_HAVEDOT]];
            }
            
            _iflyRecognizerView.delegate = weakSelf;
            
            [_iflyRecognizerView start];
            
        }else{
            
            showMsg(SettingMicrophone);
        }
    }];
    
}

#pragma mark - <IFlyRecognizerViewDelegate>
/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
    
    NSDictionary *vcnJson = [[NSDictionary alloc]initWithDictionary:[resultArray objectAtIndex:0]];
    
    if (resultArray.count == 0) {
        return;
    }
    
    NSString *vcnValue = [[vcnJson allKeys] objectAtIndex:0];
    NSData *vcnData = [vcnValue dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *vcnDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:vcnData options:NSJSONReadingAllowFragments error:&error];
    
    NSMutableString *vcnMutlResultValue = [[NSMutableString alloc]init];
    
    /**
     语音结果最外层的数组
     */
    NSArray *vcnWSArray = [[NSArray alloc]initWithArray:[vcnDic objectForKey:@"ws"]];
    
    for (int i = 0; i<vcnWSArray.count; i++) {
        
        NSMutableDictionary *vcnWSDic = [vcnWSArray objectAtIndex:i];
        NSArray *vcnCWArray = [vcnWSDic objectForKey:@"cw"];
        NSDictionary *vcnCWDic = [vcnCWArray objectAtIndex:0];
        
        [vcnMutlResultValue appendFormat:@"%@",[vcnCWDic objectForKey:@"w"]];
    }
    
    if (![vcnMutlResultValue isEqualToString:@""] &&
        vcnMutlResultValue) {
        
        _appendContent = [NSString stringWithFormat:@"%@%@",
                          _appendContent?_appendContent:@"",
                          vcnMutlResultValue];
        
        if (_appendContent.length > 200) {
            
            _appendContent = [_appendContent substringToIndex:200];
            
        }
    }
    
    NSMutableDictionary *muDict = _fangyuanhebeizhu[_tagValue];
    muDict[@"房源跟进"] = _appendContent;
    [_mainTableView reloadData];
}

/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    if (error.errorCode != 0) {
        
    }
}

#pragma mark - <TextViewDelegate>
- (void)textViewChangeInput:(NSNotification *)notification
{
    UITextView *inputTextView = (UITextView *)notification.object;
    if (inputTextView.text.length > 200)
    {
        if (_appendContent.length > 0)
        {
            inputTextView.text = _appendContent;
        }
        else
        {
            _appendContent = [inputTextView.text substringToIndex:199];
            inputTextView.text = _appendContent;
        }
    }
    else
    {
        _appendContent = inputTextView.text;
    }
}

//选中textView 或者输入内容的时候调用的方法
- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSMutableDictionary *muDict = _fangyuanhebeizhu[textView.tag];
    muDict[@"房源跟进"] = textView.text;
}
//从键盘上将要输入到textView的时候调用的方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.length == 0 && range.location>=200)
    {
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CommonMethod resignFirstResponder];


    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            //租售类型
            [NewUtils popoverSelectorTitle:nil listArray:_takeLookTypeDict.allKeys theOption:^(NSInteger optionValue) {
                NSArray *array = _takeLookTypeDict.allKeys;
                _optionsStr = array[optionValue];
                [_mainTableView reloadData];
            }];
        }else if (indexPath.row == 1) {
            
            // 新增约看--(增加一个分组)
            if (_sectionSum == 14)
            {
                showMsg(@"最多增加10条约看房源！");
                return;
            }
            _sectionSum += 1;
            [_fangyuanhebeizhu addObject: [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"房源跟进", nil]];  // 新加一组
            [_mainTableView reloadData];
            [self scrollTableToFoot];       // 滑到底部
        }

    }
    else if (indexPath.section == _sectionSum - 2){
        if (indexPath.row == 0) {
            //陪看人
            _isSelectLookWithPeopleId  = YES;
            SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc] init];
            
            //人员
            searchRemindPersonVC.isExceptMe = YES;
            searchRemindPersonVC.isFromOtherModule = YES;
            searchRemindPersonVC.selectRemindType = PersonType;
            searchRemindPersonVC.selectRemindTypeStr = PersonRemindType;
            searchRemindPersonVC.delegate = self;
            [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
        }else if (indexPath.row == 1){
            //带看时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:YearToMinFormat];
            NSDate *date = [formatter dateFromString:_takeSeeTime];
            TCPickView *pickView = [[TCPickView alloc] initDatePickViewWithDate:date mode:UIDatePickerModeTime];
            pickView.myDelegate = self;
            [self.view addSubview:pickView];
            [pickView showPickViewWithResultBlock:^(id result) {
                NSLog(@"%@",result);
                _takeSeeTime = result;
                //先把时间格式转为YYYY-MM-dd'T'HH:mm:ss  再转换成星期格式
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:YearToMinFormat];
                NSDate *date = [formatter dateFromString:_takeSeeTime];
                NSString * takeSeeTime =[CommonMethod dateStringWithDate:date DateFormat:DateAndTimeFormat];
                
                NewTakeLookSecondCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                _TakeSeeWeekTime = [CommonMethod getFormatWeekDateStrFromTime:takeSeeTime DateFormat:YearToMinFormat];
                cell.rightTitle.text = _TakeSeeWeekTime;
                
            }];
        }else {
            // 提醒时间
            [CommonMethod addLogEventWithEventId:@"New a_remind time_Click" andEventDesc:@"新增约看-提醒时间点击量"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:YearToMinFormat];
            NSDate *date = [formatter dateFromString:_remindTime];
            TCPickView *pickView = [[TCPickView alloc] initDatePickViewWithDate:date mode:UIDatePickerModeDateAndTime];
            [self.view addSubview:pickView];
            
            [pickView showPickViewWithResultBlock:^(id result) {
                
                if([CommonMethod compareCurrentTime:result andFormat:YearToMinFormat] < 0)
                {
                    showMsg(@"提醒不得早于或等于当前时间！");
                    return;
                }
                
                _remindTime = result;
                [_mainTableView reloadData];
            }];
        }
    }else {
        if (indexPath.row == 2) {
            // 删除-(删除当前分组)
            if (_sectionSum == 5)
            {
                showMsg(@"至少保留一个约看房源！");
                return;
            }
            [_fangyuanhebeizhu removeObjectAtIndex:indexPath.section-2];    // 删除指定组的数据
            _sectionSum -= 1;
            [_mainTableView reloadData];
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 50*NewRatio;
        }else {
            return 60*NewRatio;
        }
    }else if (indexPath.section == _sectionSum - 2) {
      
        if (indexPath.row == 2) {
            // 添加提醒人
            CGFloat remindPersonHeight = _remindPersonCollectionView.contentSize.height;
            
            if (remindPersonHeight != 0) {
                _viewHeight = remindPersonHeight;
            }
            
            if (_viewHeight > 50*NewRatio) {
                return _viewHeight+20*NewRatio;
            }
            
            return 70*NewRatio;
        }else {
           
            return 50*NewRatio;

        }
    }else if (indexPath.section == _sectionSum - 1) {
        return 244*NewRatio;
    }else {
        
        if (indexPath.row == 0|| indexPath.row == 2)
        {
            return 50*NewRatio;
        }else
        {
            return 283*NewRatio;
        }
    }

    
    return 50*NewRatio;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section >2) {
        return 12*NewRatio;
    }else {
        return 0.01;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
//}

#pragma mark  - 滑到最底部
- (void)scrollTableToFoot
{
    NSInteger s = [_mainTableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [_mainTableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [_mainTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES]; //滚动到最后一行
}

#pragma mark - [私有方法]
- (CustomActionSheet *)showPickView:(NSInteger)selectIndex
{

    UIPickerView *mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, APP_SCREEN_WIDTH, 180)];
    mPickerView.dataSource = self;
    mPickerView.delegate = self;
    [mPickerView selectRow:selectIndex inComponent:0 animated:YES];

    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:mPickerView AndHeight:300];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];

    return sheet;
}


#pragma mark - <PickerViewDelegate>
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _takeLookTypeDict.allKeys.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{

    UILabel *cusPicLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 20.0f)];


    NSString * cusStr = _optionsStr;

    cusPicLabel.text = cusStr;
    [cusPicLabel setFont:[UIFont systemFontOfSize:18.0]];
    [cusPicLabel setTextAlignment:NSTextAlignmentCenter];
    cusPicLabel.backgroundColor = [UIColor clearColor];

    return cusPicLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {

    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}



#pragma mark - <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _remindPersonsArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RemindPersonDetailEntity *remindPersonEntity = [_remindPersonsArr objectAtIndex:indexPath.row];
    
    CGFloat collectionViewWidth = (202.0/320.0)*APP_SCREEN_WIDTH;
    
    CGFloat resultStrWidth = [remindPersonEntity.resultName getStringWidth:[UIFont fontWithName:FontName
                                                                                           size:14.0]
                                                                    Height:25.0
                                                                      size:14.0];
    
    resultStrWidth += 20;
    
    if (resultStrWidth > collectionViewWidth)
    {
        resultStrWidth = collectionViewWidth;
    }
    
    return CGSizeMake(resultStrWidth, 25);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *collectionCellId = @"applyRemindPersonCollectionCell";
    
    ApplyRemindPersonCollectionCell *remindPersonCollectionCell = (ApplyRemindPersonCollectionCell *)[_remindPersonCollectionView dequeueReusableCellWithReuseIdentifier:collectionCellId
                                                                                                                                                            forIndexPath:indexPath];
    
    remindPersonCollectionCell.rightDeleteBtn.tag = DeleteRemindPersonBtnTag+indexPath.row;
    [remindPersonCollectionCell.rightDeleteBtn addTarget:self
                                                  action:@selector(deleteRemindPersonMethod:)
                                        forControlEvents:UIControlEventTouchUpInside];
    
    RemindPersonDetailEntity *curRemindPersonEntity = [_remindPersonsArr objectAtIndex:indexPath.row];
    remindPersonCollectionCell.leftValueLabel.text = curRemindPersonEntity.resultName;
    
    return remindPersonCollectionCell;
}


- (void)reloadRemindCellHeight
{
    
    [_mainTableView reloadData];
}

#pragma mark 新增上传看房单
-(void)uploadSeeEstateClick
{
    if (_uploadSeeImg) {
        showMsg(@"只能上传一张看房单");
        return;
    }
    
    
    NSArray * listArr = @[@"相机",@"手机相册"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        switch (optionValue) {
            case 0:
            {
                //拍照获取
                UIImagePickerController *_imagePicker = [[UIImagePickerController alloc] init];
                _imagePicker.delegate = weakSelf;
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    
                    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [weakSelf presentViewController:_imagePicker animated:YES completion:^{
                        
                    }];
                }else{
                    showMsg(@"相机不可用!");
                }
            }
                break;
            case 1:
            {
                //相册获取
                
                
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:weakSelf pushPhotoPickerVc:YES];
                
                // 在内部显示拍照按钮
                imagePickerVc.allowTakePicture = NO;
                
                // 设置是否可以选择视频/图片/原图
                imagePickerVc.allowPickingVideo = NO;
                
                imagePickerVc.maxImagesCount = 1;
                
                ///单选模式,maxImagesCount为1时才生效
                imagePickerVc.showSelectBtn = NO;
                imagePickerVc.circleCropRadius = 1;
                
                // 你可以通过block或者代理，来得到用户选择的照片.
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    _uploadSeeImg = photos[0];
                    [_mainTableView reloadData];
                }];
                
                [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
                
            }
                break;
                
            default:
                break;
        }
        
    }];
    
}

#pragma mark 取消上传看房单
-(void)cancelUploadSeeClick
{
    _uploadSeeImg = nil;
    _uploadSeeStr = nil;
    [_mainTableView reloadData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - TCPickViewDelegate

- (void)pickViewRemove {
    
}


@end
