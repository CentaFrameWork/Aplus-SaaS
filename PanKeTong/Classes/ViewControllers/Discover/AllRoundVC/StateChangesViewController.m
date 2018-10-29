//
//  stateChangesViewController.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/3.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "StateChangesViewController.h"
#import "StateChangesStateTableViewCell.h"
#import "StateChangesclearInformationCell.h"
#import "OpeningPersonCell.h"                   // 提醒人
#import "FollowUpContentCell.h"                 // 输入
#import "AppendInfoBasePresenter.h"
#import <iflyMSC/iflyMSC.h>
#import "SearchRemindPersonViewController.h"
#import "ApplyRemindPersonCollectionCell.h"
#import "DateTimePickerDialog.h"
#import "MoreFilterTableViewCell.h"
#import "StateChangesModel.h"

#define AddRemindPersonActionTag        1000
#define DeleteRemindPersonBtnTag        2000

#define CellViewTag             1000001
#define Padding                 15*NewRatio
#define ButtonTagBasic          10000

@interface StateChangesViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,
UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SearchRemindPersonDelegate,UITextViewDelegate,IFlyRecognizerViewDelegate
,DateTimeSelected>
{
//    BOOL _isNowSubmit;      //现在是否正在上传（防止多次点击）
    AppendInfoBasePresenter *_appendInfoPresenter;
    IFlyRecognizerView  *_iflyRecognizerView;       //语音输入
    NSString *_appendContent;                           // 信息补充内容
    UICollectionView *_remindPersonCollectionView;  //显示提醒人collectionView
    NSMutableArray *_remindPersonsArr;              //提醒人、部门数组
    
    NSDate *_selectedDate;//记录上次选择时间
    NSDate *_oldTime;
    
    DateTimePickerDialog *dateTimePickerDialog;
    
    NSString *_msgTime;     //提醒时间
    NSArray *_celltitleArr;
    
//    UIView *_shadowView;    // 遮罩层view
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *selectedArray;
@property (nonatomic, strong)NSMutableString *clearInformationStr;

@property (nonatomic, assign)CGFloat viewHeight;

@end

@implementation StateChangesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self setNavTitle:@"房源状态修改"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(commitNewOpening)]];
    
    
    /*
     *添加textView监听
     *
     */
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewChangeInput:)
                                                name:UITextViewTextDidChangeNotification
                                              object:nil];
    
    
    _viewHeight = 0;
    
    [self TableView];
//    [self initView];
    [self initData];
}
// 解决tableView分割线不到头的问题
-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];    }         if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
}
- (void)back
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否放弃本次提交?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *value) {
        if (value.integerValue == 0)
        {
            
            
        }
        else if(value.integerValue == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (void)initView {
//    // 新增事件按钮
//    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
//    _shadowView.hidden = YES;
//    _shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [_shadowView addGestureRecognizer:tap];
////    [self.view addSubview:_shadowView];
//    [[[UIApplication sharedApplication] delegate].window addSubview:_shadowView];
    
    
//    // 按钮
//    UIView *view = [[UIView alloc] init];
//    view.userInteractionEnabled = YES;
//    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateViewClick)];
//    [view addGestureRecognizer:dateTap];
//    view.backgroundColor = [UIColor whiteColor];
//    view.tag = CellViewTag;
//
//    CGFloat pointX = 10;
//    CGFloat pointY = 10;
//    CGFloat padding = Padding;
//    CGFloat btnHeight = 30.0;
//    CGFloat allWidth = _shadowView.bounds.size.width - 200*ratio2;
//    NSArray *StateChanges = @[@"委托经纪人",@"钥匙",@"跟进"];
//
//    UILabel *labelstr = [[UILabel alloc] initWithFrame:CGRectMake(0, -40, allWidth, 40)];
//    labelstr.backgroundColor = [UIColor whiteColor];
//    labelstr.text = @"请选择清空信息:";
//    [view addSubview:labelstr];
//
//    _selectedArray = [[NSMutableArray alloc] init];
//    _clearInformationStr = [[NSMutableString alloc] init];
//
//    for (int i = 0; i < 3; i++) {
//
//        NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName size:14.0]};
//        CGSize size = [StateChanges[i] boundingRectWithSize:CGSizeMake(MAXFLOAT,26) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//
//        CGFloat btnWidth = size.width + 20;
//
//        if (pointX + btnWidth > allWidth)
//        {
//            // 换行
//            pointX = 10;
//            pointY += (btnHeight + padding);
//        }
//
//        // 背景button
//        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        bgButton.frame = CGRectMake(pointX, pointY, btnWidth, btnHeight);
//        bgButton.tag = (1 * ButtonTagBasic) + i + 100;
//        bgButton.layer.masksToBounds = YES;
//        bgButton.layer.cornerRadius = 5.0;
//        bgButton.layer.borderWidth = 1.0;
//        bgButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        [bgButton addTarget:self action:@selector(theRoomTypeClick:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:bgButton];
//
//        bgButton.titleLabel.font = [UIFont fontWithName:FontName size:14.0];
//
//        [bgButton setTitleColor:LITTLE_GRAY_COLOR forState:UIControlStateNormal];
//        [bgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//
//        NSString *textStr = StateChanges[i];
//        [bgButton setTitle:textStr forState:UIControlStateNormal];
//
//        [bgButton setBackgroundImage:[UIImage imageNamed:@"button_select_Img.png"] forState:UIControlStateSelected];
//        pointX += (btnWidth + padding);
//
//        view.frame = CGRectMake(100*ratio2, 400*ratio2, allWidth, pointY+btnHeight+40);
//
//        [_shadowView addSubview:view];
//
//        // 无效默认选中 委托经纪人
//        if (_propertyStatus == 0 && i == 0) {
//            [self theRoomTypeClick:bgButton];
//        }
//    }
//
//    UIButton *determineButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(view.frame)-60, CGRectGetHeight(view.frame)-40, 40, 30)];
//    determineButton.backgroundColor = [UIColor lightGrayColor];
//    [determineButton setTitle:@"确定" forState:UIControlStateNormal];
//    [determineButton addTarget:self action:@selector(determineButtonEvent) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:determineButton];
//
//
}

//- (void)dateViewClick {
//
//}
//
//- (void)determineButtonEvent {
//    _shadowView.hidden = YES;
//}

- (void)theRoomTypeClick:(UIButton *)button {
    button.selected =! button.selected;
    
    // 房型
    if (button.selected)
    {
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        [muArray addObject:[NSString stringWithFormat:@"%@",button.titleLabel.text]];
        [muArray addObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
        [_selectedArray addObject:muArray];
        [_clearInformationStr appendFormat:@"%@，",button.titleLabel.text];
        // 背景颜色  边框颜色
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = UICOLOR_RGB_Alpha(0xe9ab28, 1.0).CGColor;
        // 显示对号
        UIImageView *imageView = (UIImageView *)[button viewWithTag:360];
        imageView.hidden = NO;
    }
    else
    {
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        [muArray addObject:[NSString stringWithFormat:@"%@",button.titleLabel.text]];
        [muArray addObject:[NSString stringWithFormat:@"%ld",button.tag]];
        [_selectedArray removeObject:muArray];
        _clearInformationStr = (NSMutableString *)[_clearInformationStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@，",button.titleLabel.text] withString:@""];
        // 背景颜色  边框颜色
        button.backgroundColor = UICOLOR_RGB_Alpha(0xf9faff, 1.0);
        button.layer.borderColor = UICOLOR_RGB_Alpha(0xf9faff, 1.0).CGColor;
        // 显示对号
        UIImageView *imageView = (UIImageView *)[button viewWithTag:360];
        imageView.hidden = YES;
    }
    NSLog(@"_selectedArray:%@",_selectedArray);
    [_tableView reloadData];
}

//- (void)tapAction:(UITapGestureRecognizer *)tap{
//    _shadowView.hidden = YES;
//}

- (void)initData
{
    _remindPersonsArr = [[NSMutableArray alloc]init];
//    _isNowSubmit = NO;
}

- (void)TableView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        StateChangesStateTableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if (!cell0) {
            cell0 = [[StateChangesStateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
            cell0.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell0.propertyStatus = _propertyStatus;
        cell0.indexPath = indexPath;
        return cell0;
    }
    
    if (_propertyStatus == 0) {
        if (indexPath.row == 1) {
            StateChangesclearInformationCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell1) {
                cell1 = [[StateChangesclearInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                
                // 按钮
                UIView *view = [[UIView alloc] init];
                view.userInteractionEnabled = YES;
                view.backgroundColor = [UIColor clearColor];
                view.tag = CellViewTag;
                view.frame = CGRectMake(75*NewRatio, 0, 288*NewRatio, 52*NewRatio);
                [cell1.contentView addSubview:view];
                
                CGFloat pointX = 10*NewRatio;
                CGFloat pointY = 10*NewRatio;
                CGFloat padding = Padding;
                CGFloat btnHeight = 32*NewRatio;
//                CGFloat allWidth = CGRectGetWidth(view.frame);
                NSArray *StateChanges = @[@"委托经纪人",@"钥匙",@"跟进"];
                
                _selectedArray = [[NSMutableArray alloc] init];
                _clearInformationStr = [[NSMutableString alloc] init];
                
                for (int i = 0; i < 3; i++) {
                    
                    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName size:14*NewRatio]};
                    CGSize size = [StateChanges[i] boundingRectWithSize:CGSizeMake(MAXFLOAT,26*NewRatio) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                    
                    CGFloat btnWidth = size.width + 30*NewRatio;
                    
//                    if (pointX + btnWidth > allWidth)
//                    {
//                        // 换行
//                        pointX = 6*NewRatio;
//                        pointY += (btnHeight + padding);
//                    }
                    
                    // 背景button
                    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    bgButton.frame = CGRectMake(pointX, pointY, btnWidth, btnHeight);
                    bgButton.tag = (1 * ButtonTagBasic) + i + 100;
                    bgButton.layer.masksToBounds = YES;
                    bgButton.layer.cornerRadius = 5.0*NewRatio;
                    bgButton.layer.borderWidth = 1.0;
                    bgButton.layer.borderColor = UICOLOR_RGB_Alpha(0xf9faff, 1.0).CGColor;
                    bgButton.backgroundColor = UICOLOR_RGB_Alpha(0xf9faff, 1.0);
                    [bgButton addTarget:self action:@selector(theRoomTypeClick:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:bgButton];
                    bgButton.titleLabel.font = [UIFont fontWithName:FontName size:14*NewRatio];
                    [bgButton setTitleColor:YCTextColorBlack forState:UIControlStateNormal];
                    [bgButton setTitleColor:UICOLOR_RGB_Alpha(0xe9ab28, 1.0) forState:UIControlStateSelected];
                    NSString *textStr = StateChanges[i];
                    [bgButton setTitle:textStr forState:UIControlStateNormal];
                    pointX += (btnWidth + padding);
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgButton.frame)-20*NewRatio, CGRectGetHeight(bgButton.frame)-20*NewRatio, 20*NewRatio, 20*NewRatio)];
                    imageView.image = [UIImage imageNamed:@"勾选对勾"];
                    [bgButton addSubview:imageView];
                    imageView.tag = 360;
                    imageView.hidden = YES;
                    
//                    view.frame = CGRectMake(75*NewRatio, 0, allWidth, pointY+btnHeight);
//                    [cell1.contentView addSubview:view];
                    
                    // 无效默认选中 委托经纪人
                    if (_propertyStatus == 0 && i == 0) {
                        [self theRoomTypeClick:bgButton];
                    }
                }
                
            }

            return cell1;
        }
        else if (indexPath.row == 2) {
            FollowUpContentCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell2) {
                [tableView registerNib:[UINib nibWithNibName:@"FollowUpContentCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
                cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
                cell2.selectionStyle = UITableViewCellSelectionStyleNone;
                cell2.lineView.hidden = YES;
            }
            
            cell2.rightInputTextView.text = _appendContent;
            cell2.rightInputTextView.delegate = self;
            [cell2.voiceInputBtn addTarget:self action:@selector(voiceInputMethod) forControlEvents:UIControlEventTouchUpInside];
            return  cell2;
            
        }
        else if (indexPath.row == 3) {
            //提醒人
            OpeningPersonCell * openingPersonCell = [tableView dequeueReusableCellWithIdentifier:@"openingPersonCell"];
            if (!openingPersonCell) {
                [tableView registerNib:[UINib nibWithNibName:@"OpeningPersonCell" bundle:nil] forCellReuseIdentifier:@"openingPersonCell"];
                openingPersonCell = [tableView dequeueReusableCellWithIdentifier:@"openingPersonCell"];
                openingPersonCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [openingPersonCell.addOpeningPersonBtn addTarget:self action:@selector(clickAddRemindPersonMethod) forControlEvents:UIControlEventTouchUpInside];
                openingPersonCell.leftPersonLabel.text = @"提醒人";
                
                _remindPersonCollectionView = openingPersonCell.showRemindListCollectionView;
                [_remindPersonCollectionView registerNib:[UINib nibWithNibName:@"ApplyRemindPersonCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"applyRemindPersonCollectionCell"];
                _remindPersonCollectionView.delegate = self;
                _remindPersonCollectionView.dataSource = self;
            }
            return openingPersonCell;
        }

    }else {
        if (indexPath.row == 1) {
            FollowUpContentCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell2) {
                [tableView registerNib:[UINib nibWithNibName:@"FollowUpContentCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
                cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
                cell2.selectionStyle = UITableViewCellSelectionStyleNone;
                cell2.lineView.hidden = YES;
            }


            cell2.rightInputTextView.text = _appendContent;
            cell2.rightInputTextView.delegate = self;
            [cell2.voiceInputBtn addTarget:self action:@selector(voiceInputMethod) forControlEvents:UIControlEventTouchUpInside];
            return  cell2;

        }
        else if (indexPath.row == 2) {
            //提醒人
            OpeningPersonCell * openingPersonCell = [tableView dequeueReusableCellWithIdentifier:@"openingPersonCell"];
            if (!openingPersonCell) {
                [tableView registerNib:[UINib nibWithNibName:@"OpeningPersonCell" bundle:nil] forCellReuseIdentifier:@"openingPersonCell"];
                openingPersonCell = [tableView dequeueReusableCellWithIdentifier:@"openingPersonCell"];
                openingPersonCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [openingPersonCell.addOpeningPersonBtn addTarget:self action:@selector(clickAddRemindPersonMethod) forControlEvents:UIControlEventTouchUpInside];
                openingPersonCell.leftPersonLabel.text = @"提醒人";
                
                _remindPersonCollectionView = openingPersonCell.showRemindListCollectionView;
                [_remindPersonCollectionView registerNib:[UINib nibWithNibName:@"ApplyRemindPersonCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"applyRemindPersonCollectionCell"];
                _remindPersonCollectionView.delegate = self;
                _remindPersonCollectionView.dataSource = self;
            }
            return openingPersonCell;
        }
        

    }
    
    
    
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


// 返回每组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSInteger cellNumber = 4;
    NSMutableArray *mArr  = [NSMutableArray arrayWithObjects:@"跟进内容",@"提醒人", nil];
    
    _celltitleArr = mArr;
    mArr = nil;
    
    if (_propertyStatus == 0) {
        return 4;
    }else {
        return 3;
    }
    
}

// cell的行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_propertyStatus == 0) {
        if (indexPath.row <=1) {
            return 52*NewRatio;
        }
        else if (indexPath.row == 2) {
            return 283*NewRatio;
        }
        else {
            //添加提醒人
            CGFloat remindPersonHeight = _remindPersonCollectionView.contentSize.height;
            
            if (remindPersonHeight != 0) {
                _viewHeight = remindPersonHeight;
            }
            
            if (_viewHeight > 50*NewRatio) {
                return _viewHeight+20*NewRatio;
            }
            
            return 70*NewRatio;
        }
    }else {
        if (indexPath.row == 0) {
            return 52*NewRatio;
        }
        else if (indexPath.row == 1) {
            return 283*NewRatio;
        }
        else {
            //添加提醒人
            CGFloat remindPersonHeight = _remindPersonCollectionView.contentSize.height;
            
            if (remindPersonHeight != 0) {
                _viewHeight = remindPersonHeight;
            }
            
            if (_viewHeight > 50*NewRatio) {
                return _viewHeight+20*NewRatio;
            }
            
            return 70*NewRatio;
        }
    }


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (indexPath.row == 3) {
        if (!_selectedDate) {
            
            _selectedDate = [NSDate dateWithTimeIntervalSinceNow:0];
        }
        
        dateTimePickerDialog = [DateTimePickerDialog initWithParentView:self.view
                                                            andDelegate:self
                                                                 andTag:@"start"];
        [dateTimePickerDialog showWithDate:_selectedDate andTipTitle:@"选择提醒时间"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
}
/**
 *  提交信息补充
 */
- (void)commitNewOpening {
    /**
//     *  正在提交中，不再重复提交
//     */
//    if (_isNowSubmit) {
//        return;
//    }
    
    [self.view endEditing:YES];
    
    //去掉两端的空格
    NSString *trimedString = [_appendContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //判断输入内容是否全是空格
    BOOL isEmpty = [NSString isEmptyWithLineSpace:_appendContent];
    if (!_appendContent || [_appendContent isEqualToString:@""] || isEmpty) {
        showMsg(@"请输入内容!");
        return;
    }
    
//    _isNowSubmit = YES;
    
    StateChangesModel *scModel = [[StateChangesModel alloc] init];
    scModel.isClearTrust = NO;
    scModel.isClearKey = NO;
    scModel.isClearFollw = NO;
    for (int i = 0; i<_selectedArray.count; i++) {
        if ([_selectedArray[i][1] isEqualToString:@"10100"]) {
            scModel.isClearTrust = YES;
        }
        if ([_selectedArray[i][1] isEqualToString:@"10101"]) {
            scModel.isClearKey = YES;
        }
        if ([_selectedArray[i][1] isEqualToString:@"10102"]) {
            scModel.isClearFollw = YES;
        }
    }
    
    scModel.followType = 3;
    scModel.keyId = _propKeyId;
    if (_propertyStatus == 0) {
        scModel.targetPropertyStatusKeyId = @"238871cd-786e-4aea-b0a1-fa8c69a19b10";
    }else {
        scModel.targetPropertyStatusKeyId = @"43d15344-a09d-48c9-af93-b244a68b8247";
    }
    scModel.followContent = trimedString;       // 跟进内容
    
    NSMutableArray *msgDeptKeyIdsArray = [[NSMutableArray alloc] init];
    NSMutableArray *informDepartsNameArray = [[NSMutableArray alloc] init];
    NSMutableArray *msgUserKeyIdsArray = [[NSMutableArray alloc] init];
    NSMutableArray *contactsNameArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<_remindPersonsArr.count; i++) {
        RemindPersonDetailEntity *rpde = _remindPersonsArr[i];
        if ([rpde.type isEqualToString:@"2"]) {
            [msgDeptKeyIdsArray addObject:rpde.resultKeyId];
            [informDepartsNameArray addObject:rpde.resultName];
        }
        else if ([rpde.type isEqualToString:@"1"]) {
            [msgUserKeyIdsArray addObject:rpde.resultKeyId];
            [contactsNameArray addObject:rpde.resultName];
        }
    }
    
    scModel.msgDeptKeyIds = msgDeptKeyIdsArray;
    scModel.informDepartsName = informDepartsNameArray;
    scModel.msgUserKeyIds = msgUserKeyIdsArray;
    scModel.contactsName = contactsNameArray;
    
    
    [AFUtils POST:AipPropertyAddFollow parameters:[StateChangesModel dictWithModel:scModel] controller:self successfulDict:^(NSDictionary *successfuldict) {
        // 请求成功返回成功
        self.refreshData();
        [self.navigationController popViewControllerAnimated:YES];
        showMsg(@"提交成功")
    } failureDict:^(NSDictionary *failuredict) {
        // 请求成功返回失败
    } failureError:^(NSError *failureerror) {
        // 请求失败
    }];
    
}

#pragma mark - <VoiceInputMethod>
- (void)voiceInputMethod
{
    [self.view endEditing:YES];
    
    __weak typeof (self) weakSelf = self;
    
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
        
        [_tableView reloadData];
    }
    
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.length == 0 && range.location>=200)
    {
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}



#pragma mark - <UICollectionViewDelegate/DataSource>
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//
//    return _remindPersonsArr.count;
//}
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout*)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    RemindPersonDetailEntity *remindPersonEntity = [_remindPersonsArr objectAtIndex:indexPath.row];
//
//    CGFloat collectionViewWidth = (202.0/320.0)*APP_SCREEN_WIDTH;
//
//    CGFloat resultStrWidth = [remindPersonEntity.resultName getStringWidth:[UIFont fontWithName:FontName
//                                                                                           size:14.0]
//                                                                    Height:25.0
//                                                                      size:14.0];
//
//    resultStrWidth += 20;
//
//    if (resultStrWidth > collectionViewWidth) {
//
//        resultStrWidth = collectionViewWidth;
//    }
//
//
//    return CGSizeMake(resultStrWidth, 25);
//
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
//                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    static NSString *collectionCellId = @"applyRemindPersonCollectionCell";
//
//    ApplyRemindPersonCollectionCell *remindPersonCollectionCell = (ApplyRemindPersonCollectionCell *)[_remindPersonCollectionView dequeueReusableCellWithReuseIdentifier:collectionCellId
//                                                                                                                                                            forIndexPath:indexPath];
//
//    remindPersonCollectionCell.rightDeleteBtn.tag = DeleteRemindPersonBtnTag+indexPath.row;
//    [remindPersonCollectionCell.rightDeleteBtn addTarget:self
//                                                  action:@selector(deleteRemindPersonMethod:)
//                                        forControlEvents:UIControlEventTouchUpInside];
//
//    RemindPersonDetailEntity *curRemindPersonEntity = [_remindPersonsArr objectAtIndex:indexPath.row];
//    remindPersonCollectionCell.leftValueLabel.text = curRemindPersonEntity.resultName;
//
//    return remindPersonCollectionCell;
//
//}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _remindPersonsArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RemindPersonDetailEntity *remindPersonEntity = [_remindPersonsArr objectAtIndex:indexPath.row];
    
    CGFloat collectionViewWidth = (202.0/320.0)*APP_SCREEN_WIDTH;
    
    CGFloat resultStrWidth = [remindPersonEntity.resultName getStringWidth:[UIFont fontWithName:FontName size:14.0] Height:25.0 size:14.0];
    
    //陈行修改，由原来20改为28，其他未动
    resultStrWidth += 28;
    
    if (resultStrWidth > collectionViewWidth) {
        
        resultStrWidth = collectionViewWidth;
    }
    
    
    return CGSizeMake(resultStrWidth, 25);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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

//#pragma mark - <BYActionSheetViewDelegate>
//- (void)actionSheetView:(BYActionSheetView *)alertView
//   clickedButtonAtIndex:(NSInteger)buttonIndex andButtonTitle:(NSString *)buttonTitle
//{
//
//    switch (alertView.tag) {
//        case AddRemindPersonActionTag:
//        {
//            //添加提醒人
//            SearchRemindType selectRemindType;
//            NSString *selectRemindTypeStr;
//
//            switch (buttonIndex) {
//                case 0:
//                {
//                    //部门
//                    selectRemindType = DeparmentType;
//                    selectRemindTypeStr = DeparmentRemindType;
//                }
//                    break;
//                case 1:
//                {
//                    //人员
//                    selectRemindType = PersonType;
//                    selectRemindTypeStr = PersonRemindType;
//                }
//                    break;
//
//                default:
//                {
//                    return;
//                }
//                    break;
//            }
//
//            SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc] initWithNibName:@"SearchRemindPersonViewController" bundle:nil];
//            searchRemindPersonVC.selectRemindType = selectRemindType;
//            searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
//            searchRemindPersonVC.isExceptMe = [_appendInfoPresenter isExceptMe];
//            searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
//            searchRemindPersonVC.delegate = self;
//            [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
//        }
//            break;
//
//        default:
//            break;
//    }
//}

#pragma mark - <SearchRemindPersonDelegate>
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem
{
    
    [_remindPersonsArr addObject:selectRemindItem];
    [_remindPersonCollectionView reloadData];
    
    [self performSelector:@selector(reloadRemindCellHeight)
               withObject:nil
               afterDelay:0.1];
}

/**
 *  添加提醒人
 */
- (void)clickAddRemindPersonMethod
{
    
//    [self.view endEditing:YES];
//
//    BYActionSheetView *byActionSheetView = [[BYActionSheetView alloc]initWithTitle:nil
//                                                                          delegate:self
//                                                                 cancelButtonTitle:@"取消"
//                                                                 otherButtonTitles:@"部门",@"人员", nil];
//    byActionSheetView.tag = AddRemindPersonActionTag;
//    [byActionSheetView show];
    
    [NewUtils popoverSelectorTitle:@"请选择" listArray:@[@"部门",@"人员"] theOption:^(NSInteger optionValue) {
        
        //添加提醒人
        SearchRemindType selectRemindType;
        NSString *selectRemindTypeStr;
        
        if (optionValue == 0) {
            //部门
            selectRemindType = DeparmentType;
            selectRemindTypeStr = DeparmentRemindType;
        }
        else {
            //人员
            selectRemindType = PersonType;
            selectRemindTypeStr = PersonRemindType;
        }
        
        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc] initWithNibName:@"SearchRemindPersonViewController" bundle:nil];
        searchRemindPersonVC.selectRemindType = selectRemindType;
        searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
        searchRemindPersonVC.isExceptMe = [_appendInfoPresenter isExceptMe];
        searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
        searchRemindPersonVC.delegate = self;
        [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
        
    }];
    
}

/**
 *  删除提醒人
 */
- (void)deleteRemindPersonMethod:(UIButton *)button
{
    
    NSInteger deleteItemIndex = button.tag-DeleteRemindPersonBtnTag;
    
    [_remindPersonsArr removeObjectAtIndex:deleteItemIndex];
    
    [_remindPersonCollectionView reloadData];
    
    [self performSelector:@selector(reloadRemindCellHeight)
               withObject:nil
               afterDelay:0.1];
}


#pragma mark - <DateTimeSelectedDelegate>
- (void)selectedResultWithSender:(NSObject *)sender andDate:(NSDate *)dateTime
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *now = [date  dateByAddingTimeInterval: interval];//当前时间
    NSDate *selectTime = [DateTimePickerDialog ConversionTimeZone:dateTime];
    
    NSTimeInterval secondsInterval= [selectTime timeIntervalSinceDate:now];
    
    //不是之前的日期
    if (secondsInterval > 0) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];
        
        _msgTime = [dateFormatter stringFromDate:dateTime];
        
        _selectedDate = dateTime;
        
    }else{
        showMsg(@"请选择有效日期");
    }
}

///确定
- (void)clickDone{
    if (_msgTime == nil) {
        //没有滑动
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];
        _msgTime = [dateFormatter stringFromDate:_selectedDate];
    }
    
    _oldTime = _selectedDate;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_celltitleArr.count - 1) inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
    
}

///取消
- (void)clickCancle{
    
    if (!_oldTime) {
        
        _msgTime = nil;
        _selectedDate = nil;
    }else{
        
        _selectedDate = _oldTime;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];
        
        _msgTime = [dateFormatter stringFromDate:_oldTime];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_celltitleArr.count - 1) inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

// 滑动调用
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//}

- (void)reloadRemindCellHeight
{
    [_tableView reloadData];
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[AgencyBaseEntity class]])
    {
        
        [self hiddenLoadingView];
        
        AgencyBaseEntity *agencyBaseEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (agencyBaseEntity.flag)
        {
            showMsg(@"已提交成功");
            // 获取到 语音按钮
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            FollowUpContentCell *nextCell = [_tableView cellForRowAtIndexPath:indexPath];
            nextCell.voiceInputBtn.userInteractionEnabled = NO;
            
            [self performSelector:@selector(back) withObject:nil afterDelay:1.5f];
            
            if ([_delegate respondsToSelector:@selector(transferEstSuccess)])
            {
                [_delegate performSelector:@selector(transferEstSuccess)];
            }
        }
        else
        {
            showMsg(@"提交失败，请重试!");
            
//            _isNowSubmit = NO;
        }
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    [super respFail:error andRespClass:cls];
//    _isNowSubmit = NO;
}






@end
