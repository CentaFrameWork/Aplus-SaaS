//
//  CustomerInfoViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 15/9/29.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CustomerInfoViewController.h"
#import "CustomerDetailApi.h"
#import "CustomerFollowApi.h"
#import "MBProgressHUD.h"
#import "CustomerDetailEntity.h"
#import "CustomerFollowEntity.h"


#import "CustomerInfoZJPresenter.h"



#import "JMCustomMessageCell.h"
#import "JMCustomInfoCell.h"
#import "PDHeaderCell.h"
#import "JMDetailPresentView.h"
@interface CustomerInfoViewController ()<CustomerFollowBackDelegate,DetailPresentDelegate>
{
    
    CustomerDetailEntity *_customerDetailEntity;
    CustomerFollowEntity *_customerFollowEntity;
    NSArray *_titles;
    NSInteger _selectIndex;
    MBProgressHUD *_customerHUD;
    
    CustomerInfoBasePresenter *_customerInfoPresenter;
}

@property (nonatomic,strong) NSArray<NSArray*> *sourceArray;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) UIView *footView;

@end

@implementation CustomerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPresenter];
    [self initNavTitleView];
    
    
    NSArray* saleArr = @[
                 @[@"交易类型",@"紧迫程度"],
                 @[@"居住人口",@"信息来源"],
                 @[@"房       型",@"期望路线"],
                 @[@"朝       向",@"楼       层"],
                 @[@"装修状况",@"购房原因"],
                 @[@"房屋用途",@"建筑类型"],
                 @[@"付款方式",    @""],
                 @[@"面       积",@""],
                 @[@"心理购价",    @""]
                 
                  ];
    
  
     NSArray* rentArr = @[
                 @[@"交易类型",@"紧迫程度"],
                 @[@"居住人口",@"信息来源"],
                 @[@"房       型",@"期望路线"],
                 @[@"朝       向",@"楼       层"],
                 @[@"装修状况",@"建筑类型"],
                 @[@"付佣方式",    @""],
                 @[@"面       积",@""],
                 @[@"心理租价",    @""],
                 @[@"租赁期至",    @""]
                 
                 ];
    
    NSArray* bothArr = @[
                 @[@"交易类型",@"紧迫程度"],
                 @[@"居住人口",@"信息来源"],
                 @[@"房       型",@"期望路线"],
                 @[@"朝       向",@"楼       层"],
                 @[@"装修状况",@"购房原因"],
                 @[@"房屋用途",@"建筑类型"],
                 @[@"付佣方式",@"付款方式"],
                 
                 @[@"面       积",@""],
                 @[@"心理购价",    @""],
                 @[@"心理租价",    @""],
                 @[@"租赁期至",    @""]
                
                 ];
    
    
    if ([_customerEntity.inquiryTradeType isEqualToString:@"求购"]) {
      
        _sourceArray = saleArr;
   
    }else if([_customerEntity.inquiryTradeType isEqualToString:@"求租"])
    {
        _sourceArray = rentArr;
    
    }else{
        
        _sourceArray = bothArr;
    }
    
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.footView];

    
    [self initData];
   
    
    
    
    /*
    
    <NSLayoutConstraint: key2 UILabel:0x10df56020.leading == UIView:view2.leading>,
    <NSLayoutConstraint:0x174489560 UILabel value2:0x10df562b0.leading == UILabel:key2 0x10df56020.trailing + 5>,
    <NSLayoutConstraint:0x174489650 UIView view2:0x10df55850.trailing == UILabel:0x10df562b0.trailing>,
    <NSLayoutConstraint:0x174489790 UIView view1 :0x10df55420.width == UIView:view 0x10df54f40.width * 0.45 + 193.05>,
    <NSLayoutConstraint:0x1744897e0 UIView view1:0x10df55420.leading == UIView:view 0x10df54f40.leading>,
    <NSLayoutConstraint:0x174489830 UIView view2 :0x10df55850.leading == UIView:view1 0x10df55420.trailing>,
    <NSLayoutConstraint:0x1744898d0 UIView:view 0x10df54f40.trailing == UIView: view2 0x10df55850.trailing>,
    <NSLayoutConstraint:0x1744899c0 UIView:view 0x10df54f40.leading == UITableViewCellContentView :cell 0x10df54990.leading + 12>,
    <NSLayoutConstraint:0x174489a60 UITableViewCellContentView: cell 0x10df54990.trailing == UIView:view 0x10df54f40.trailing + 12>,
    <NSLayoutConstraint:0x17448a050 UITableViewCellContentView:0x10df54990.width == 375>,
    
    
   */
    
    
    
}

- (void)initPresenter
{
    self.view.backgroundColor = UICOLOR_RGB_Alpha(0xF4F4F4,1.0);
    
    _customerInfoPresenter = [[CustomerInfoZJPresenter alloc] initWithDelegate:self];
   
}

- (void)initData
{
    // 获取客户详情
    [self showLoadingView:nil];
    CustomerDetailApi *customerDetailApi = [[CustomerDetailApi alloc] init];
    customerDetailApi.keyId = _customerEntity.customerKeyId;
    customerDetailApi.contactName = @"";
    [_manager sendRequest:customerDetailApi];
}

- (void)getCustomerFollow
{
    // 获取客户跟进
    CustomerFollowApi *customerFollowApi = [[CustomerFollowApi alloc] init];
    customerFollowApi.inquiryKeyId = _customerEntity.customerKeyId;
    customerFollowApi.followTypeKeyId = @"";
    customerFollowApi.pageSize = @"1";
    customerFollowApi.pageIndex = @"1";
    customerFollowApi.sortField = @"";
    customerFollowApi.ascending = @"true";
    [_manager sendRequest:customerFollowApi];
}

- (NSString *)formatDate:(NSString *)dateString
{
    if(dateString)
    {
        //    2015-11-16T14:37:34.102+08:00
        if(dateString.length > 19)
        {
            NSString *date = [dateString substringWithRange:NSMakeRange(0, 19)];
            return [CommonMethod getDetailedFormatDateStrFromTime:date];
        }
        
        return [CommonMethod getDetailedFormatDateStrFromTime:dateString];
    }
    else
    {
        return dateString;
    }
}

#pragma mark -  ***打电话***
- (void)callPhone {
    
    // 是否需要验证打电话权限
    if (![_customerInfoPresenter canCallPhoneWithCustomerDetailEntity:_customerDetailEntity]) {
       
        showMsg(@"您没有相关权限");
        
    }else{
        
        
        if(_customerDetailEntity.contacts.count){
            
            NSMutableArray *mutA = [NSMutableArray array];
            for (CustomerContacts* contact in _customerDetailEntity.contacts) {
                
                [mutA addObject:@[contact.contactType?:@"",contact.contactName?:@""]];
            }
            
            JMDetailPresentView *presentV = [[JMDetailPresentView alloc] initPresentViewContactWithArray: mutA.copy];
            presentV.delegate = self;
            [self.view addSubview:presentV];

        
        }else{
            showMsg(@"暂无客户联系方式！");
        }
        
        
        
    }

}
- (void)didSelectCell:(NSInteger)index {
    
    
    CustomerContacts* contact = _customerDetailEntity.contacts[index];
    
    NSString *phone;
    if (contact.mobile.length) {
        
        phone = [@"tel:" stringByAppendingString:contact.mobile];
        
    }else if (contact.tel.length){
        
        if ([contact.tel isEqualToString:@"--"]) {
            showMsg(@"联系人电话有误!");
            return;
        }
       
        phone = [@"tel:" stringByAppendingString:contact.tel];
        
        NSArray *arr = [phone componentsSeparatedByString:@"-"];
        
        if (arr.count >2) {
            
            phone = [arr[0] stringByAppendingString:arr[1]];
        }
        
        
    }else{
        
        showMsg(@"联系人电话有误!");
        return;
        
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        
    });
    

    
}

// 数据返回过慢导致bug  重写mbHUB
- (void)initHUDView
{
    [_customerHUD removeFromSuperview];
    
    _customerHUD = nil;
    
    _customerHUD = [[MBProgressHUD alloc]initWithView:self.view];
    _customerHUD.mode = MBProgressHUDModeCustomView;
    
    UIImageView *hudBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, -6, 45, 45)];
    [hudBgImageView setImage:[UIImage imageNamed:@"spinner_outer"]];
    
    CABasicAnimation *animation = [CABasicAnimation   animationWithKeyPath:@"transform.rotation"];
    animation.duration = MAXFLOAT * 0.4;
    animation.additive = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:MAXFLOAT];
    animation.repeatCount = MAXFLOAT;
    [hudBgImageView.layer addAnimation:animation forKey:nil];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, -3, 35, 35)];
    [iconView setImage:[UIImage imageNamed:@"zy_icon"]];
    
    [iconView addSubview:hudBgImageView];
    
    _customerHUD.customView = iconView;
    [self.view addSubview:_customerHUD];
    
    _customerHUD.labelText = @"";
    [_customerHUD show:YES];
}

//- (void)showLoadingView:(NSString *)message
//{
//    [self initHUDView];
//
//
//    _customerHUD.labelText = message ? message : @"";
//    [_customerHUD show:YES];
//}


- (void)initNavTitleView
{
    UIButton *navLeftBtn = [self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)];
    
    [self setNavTitle:@"客户信息"
       leftButtonItem:navLeftBtn
      rightButtonItem:nil];
}


#pragma mark - ************tableview************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1) {
        
        return _sourceArray.count;
        
    }else if (section == 4){
    
        if(!_customerDetailEntity.targetEstates.length || [@"--" isEqualToString:_customerDetailEntity.targetEstates] ){
           
            return 0;
            
        }else{
            
            return 1;
        }
        
    }else{
        
        return 1;
    }
    
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
         JMCustomMessageCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
        
        
        CustomerContacts *customer = (CustomerContacts *)_customerDetailEntity.contacts[0];
        
        NSString *cusNameStr = customer.contactName;
        
        cell.name.text = cusNameStr;
        cell.relation.text = customer.contactType;
        cell.time.text = _customerEntity.regDate;
        cell.number.text = [NSString stringWithFormat: @"%ld", (long)_customerDetailEntity.takeSeeCount];
        
        
        return cell;
        
    }else if(indexPath.section == 1) {
        
        
        CustomerInfoTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"customerInfoItem" forIndexPath:indexPath];
        
        
        NSArray *stringArr = [self getCellString:indexPath];
        
        
        cell.labelForKey.text = _sourceArray[indexPath.row][0];
        cell.labelKey02.text = _sourceArray[indexPath.row][1];
        
        cell.labelForValue.text = stringArr[0];
        cell.labelValue02.text = stringArr[1];
        
        
        
        if (!cell.labelKey02.text.length) {
            
            cell.firstViewWidth.constant = (APP_SCREEN_WIDTH -24) *0.55;
          
        }

        return cell;
        
    } else if(indexPath.section == 2) {
        
        PDHeaderCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"PDHeaderCell" forIndexPath:indexPath];
        cell.titleStr = @"目标楼盘";
        cell.bgView.hidden = NO;
        cell.topLine.hidden = NO;
        cell.leftImageV.constant = 24;
        cell.topConstraint.constant = 38;
        cell.selectionStyle = 0;
        return cell;
        
    } else if(indexPath.section == 3) { //目标楼盘名字
        JMCustomInfoCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"customHouse" forIndexPath:indexPath];
        cell.takeSeeV.hidden = YES;
        cell.selectionStyle = 0;
        cell.titleNameLabel.text = _customerDetailEntity.targetEstates;
        return cell;
        
    }   else if(indexPath.section == 4) { //发送看房路线
        JMCustomInfoCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"customHouse" forIndexPath:indexPath];
        return cell;
        
    }
    else if(indexPath.section == 5) {  //客源跟进头
        
        PDHeaderCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"PDHeaderCell" forIndexPath:indexPath];
        cell.bgView.hidden = NO;
        cell.selectionStyle = 0;
        cell.titleStr = @"客源跟进";
        cell.topConstraint.constant = 18;
        cell.leftImageV.constant = 24;
        return cell;
        
    }else{ //跟进

        
        CustomerFollowPreviewTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"customerFollowPreview" forIndexPath:indexPath];
        
            if (!_customerFollowEntity) return cell;
        
            if( _customerFollowEntity.inqFollows.count){
                
                    CustomerFollowItemEntity *followItem  = _customerFollowEntity.inqFollows[0];
                
                    cell.contentLabel.text = followItem.followContent;
                    cell.labelForName.text = followItem.followPerson;
                    cell.labelForFollowType.text = followItem.followType;
                    cell.labelForFollowDate.text = [self formatDate:followItem.followDate];
                
                    cell.messgeaLabel.hidden = YES;
                    cell.arrowImage.hidden = NO;
                    cell.userInteractionEnabled = YES;
                
            }else{
                
                cell.messgeaLabel.hidden = NO;
                cell.arrowImage.hidden = YES;
                cell.userInteractionEnabled = NO;
            }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    
    if(section == 0) {
        
        return 130;
    }else if(section == 1) {

        return  30;
    
    }else if(section == 2) {
        
        return  60;
        
    }else if(section == 3) {
        
        return  40;
        
    }else if(section == 4) {
        
        return  50;
        
    }else if(section == 5) {
        
        return  48;
        
    }else if(section == 6) {
        
        return  _customerFollowEntity.inqFollows.count?UITableViewAutomaticDimension:50;
        
    } else{
        
        return 40;
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if(indexPath.section == 4) {
        
        if ([_customerDetailEntity.targetEstates isEqualToString:@"-"]) {
            
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"无看房路线，请在电脑端编辑客户时设置目标楼盘" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
            
                        }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
        }else{
          
            NSString *title = _customerDetailEntity.targetEstates;
            
            NSRange range = [title rangeOfString:@"，"];//判断字符串是否包含
            if (range.length > 0) {
                // 包含
                _titles = [_customerDetailEntity.targetEstates componentsSeparatedByString:@"，"];
                [self showPickView:_selectIndex];
                
            }else{
                
                // 不包含
                [self sendTakeGetEstates:@"" andName:title];
            }
            
        }
        
        
        
      
        
        
    }else if(indexPath.section == 6) {
        
        CustomerFollowViewController *customerFollow = [[CustomerFollowViewController alloc]initWithNibName:@"CustomerFollowViewController" bundle:nil];
        customerFollow.customerEntity = _customerEntity;
        customerFollow.backDelegate = self;
        [self.navigationController pushViewController:customerFollow animated:YES];
    }
}

- (CustomActionSheet *)showPickView:(NSInteger)selectIndex
{
    
    UIPickerView *mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                               40,
                                                                               APP_SCREEN_WIDTH,
                                                                               180)];
    mPickerView.dataSource = self;
    mPickerView.delegate = self;
    [mPickerView selectRow:selectIndex
               inComponent:0
                  animated:YES];
    
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:mPickerView
                                                             AndHeight:300];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];
    
    return sheet;
}

#pragma mark - <PickerViewDelegate>
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(_titles){
        return _titles.count;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *cusPicLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 20.0f)];
    
    NSString *cusStr = _titles[row];
    
    cusPicLabel.text = cusStr;
    [cusPicLabel setFont:[UIFont systemFontOfSize:18.0]];
    [cusPicLabel setTextAlignment:NSTextAlignmentCenter];
    cusPicLabel.backgroundColor = [UIColor clearColor];
    
    return cusPicLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectIndex = row;
}


- (void)doneSelectItemMethod
{
    [self sendTakeGetEstates:@"" andName:_titles[_selectIndex]];
}

- (NSArray *)getCellString:(NSIndexPath *)indexPath {
    
    NSMutableArray *mutArr = [NSMutableArray array];
    

    for (int i = 0; i<_sourceArray[indexPath.row].count; i++) {
        
        
       NSString *keyLabel = _sourceArray[indexPath.row][i];
       NSString *resultString = nil;
        
        if ([keyLabel isEqualToString:@"登记日期"]) {
            
            resultString = _customerEntity.regDate;
            
        }else if([keyLabel isEqualToString:@"交易类型"]){
            
            resultString = _customerDetailEntity.inquiryTradeType;
            
        }else if([keyLabel isEqualToString:@"面       积"]){
            
            resultString = [_customerDetailEntity.area stringByAppendingString:@"平"];;
            
            
        }else if([keyLabel isEqualToString:@"房       型"]){
            
            resultString = _customerDetailEntity.houseType;
            
        }else if([keyLabel isEqualToString:@"朝       向"]){
            
            resultString = _customerDetailEntity.houseDirection;
            
        }else if([keyLabel isEqualToString:@"楼       层"]){
            
            resultString = _customerDetailEntity.houseFloor;
            
        }else if([keyLabel isEqualToString:@"紧迫程度"]){
            
            resultString = _customerDetailEntity.emergency;
            
        }else if([keyLabel isEqualToString:@"居住人口"]){
            
            resultString = _customerDetailEntity.familySize;
            
        }else if([keyLabel isEqualToString:@"期望路线"]){
            
            resultString = _customerDetailEntity.transportations;
            
        }else if([keyLabel isEqualToString:@"信息来源"]){
            
            resultString = _customerDetailEntity.inquirySource;
            
        }else if([keyLabel isEqualToString:@"装修状况"]){
            
            resultString = _customerDetailEntity.decorationSituation;
            
        }else if([keyLabel isEqualToString:@"建筑类型"]){
            
            resultString = _customerDetailEntity.propertyType;
            
        }else if ([keyLabel isEqualToString:@"心理租价"]) {
            
            resultString = [_customerDetailEntity.rentPrice stringByAppendingString:@"元/月"];
            
        }else if([keyLabel isEqualToString:@"租赁期至"]){
            
            resultString = _customerDetailEntity.rentExpireDate;
            
        }else if([keyLabel isEqualToString:@"付佣方式"]){
            
            resultString = _customerDetailEntity.payCommissionType;
            
        }else if([keyLabel isEqualToString:@"心理购价"]){
            
            resultString = [_customerDetailEntity.salePrice stringByAppendingString:@"万"];
            
        }else if([keyLabel isEqualToString:@"付款方式"]){
            
            resultString = _customerDetailEntity.inquiryPaymentType;
            
        }else if([keyLabel isEqualToString:@"购房原因"]){
            
            resultString = _customerDetailEntity.buyReason;
            
        }else if([keyLabel isEqualToString:@"房屋用途"]){
            
            resultString = _customerDetailEntity.propertyUsage;
            
        }else if([keyLabel isEqualToString:@"目标楼盘"]){
            
            resultString = _customerDetailEntity.targetEstates;
        }else{
            
            
            resultString = @"";
        }
        
        
        [mutArr addObject:resultString?:@""];
        
    }
    
    
    return mutArr.copy;
}


#pragma mark - <CustomerFollowBackDelegate>

- (void)customerFollowBack{
    if ([_customerInfoPresenter canAddCustomerFollow]) {
        [self getCustomerFollow];
        [self showLoadingView:nil];
    }
}

#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    
    if ([modelClass isEqual:[CustomerDetailEntity class]]) {
        
        _customerDetailEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        

//
        if (_customerDetailEntity.contacts.count <= 0) {
            if (_customerHUD) {
                [_customerHUD hide:YES];
            }
            return;
        }
        
        CustomerContacts *customer = (CustomerContacts *)_customerDetailEntity.contacts[0];
        
        NSString *cusNameStr = [NSString stringWithFormat:@"%@：%@",customer.contactType,customer.contactName];
        
        /**
         *  防止电话icon超出边界
         */
        CGFloat cusNameStrWidth = 10 + [cusNameStr getStringWidth:[UIFont fontWithName:FontName
                                                                                  size:15.0]
                                                           Height:20
                                                             size:15.0];
        
        CGFloat cusNameMaxWidth = (APP_SCREEN_WIDTH*0.58)-50;
        
        if (cusNameStrWidth > cusNameMaxWidth) {
            
            cusNameStrWidth = cusNameMaxWidth ;
        }
        

        [self getCustomerFollow];

    }

    if ([modelClass isEqual:[CustomerFollowEntity class]]) {
        _customerFollowEntity = [DataConvert convertDic:data toEntity:modelClass];
         [_customerHUD hide:YES];
    }

    [self.myTableView reloadData];
    [self hiddenLoadingView];
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    
    if (_customerHUD) {
        [_customerHUD hide:YES];
    }
}

- (UITableView *)myTableView {
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREENSafeAreaHeight-80-APP_NAV_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _myTableView.backgroundColor = UICOLOR_RGB_Alpha(0xF4F4F4,1.0);
        _myTableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
        _myTableView.estimatedRowHeight = 50.0;
        [_myTableView registerNib:[UINib nibWithNibName:@"JMCustomMessageCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
        
        [_myTableView registerNib:[UINib nibWithNibName:@"CustomerInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"customerInfoItem"];
        
        [_myTableView registerNib:[UINib nibWithNibName:@"CustomerFollowPreviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"customerFollowPreview"];
        
        [_myTableView registerNib:[UINib nibWithNibName:@"JMCustomInfoCell" bundle:nil] forCellReuseIdentifier:@"customHouse"];
        [_myTableView registerNib:[UINib nibWithNibName:@"PDHeaderCell" bundle:nil] forCellReuseIdentifier:@"PDHeaderCell"];
        
    }
    
    return _myTableView;
    
}

- (UIView *)footView {
    
    if (!_footView) {
        
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_SCREENSafeAreaHeight-80-APP_NAV_HEIGHT, APP_SCREEN_WIDTH, 80)];
        _footView.backgroundColor = UICOLOR_RGB_Alpha(0xF4F4F4,1.0);
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, APP_SCREEN_WIDTH-24, 56)];
        [btn setTitle:@"打电话" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setLayerCornerRadius:5];
        btn.backgroundColor = YCThemeColorGreen;
        [btn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
        
        
        
    }
    
    return _footView;
}

@end
