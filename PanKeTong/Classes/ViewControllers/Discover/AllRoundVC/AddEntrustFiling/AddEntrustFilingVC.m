//
//  AddEntrustFilingVC.m
//  PanKeTong
//
//  Created by 张旺 on 2017/7/18.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AddEntrustFilingVC.h"
#import "EntrustFilingAddApi.h"
#import <Photos/Photos.h>

#import "AddEntrustFilingSignCell.h"
#import "JMEntrustUploadPhotoCell.h"
#import "UploadPhotoCell.h"
#import "TCPickView.h"
#import "TZImagePickerController.h"
#import "ShowEntrustFilingPhotoVC.h"
#import "SearchRemindPersonViewController.h"

#import "JMEntrustFilingHeaderView.h"
#import "HudViewUtil.h"

#import "DateTimePickerDialog.h"

#import "UITableView+Category.h"

#define UploadPhotoButtonBaseTag    1000
#define viewPhotoButtonBaseTag      2000
#define BackAlertViewBaseTag        3000
#define CleanAlertViewBaseTag       4000
#define CommitAlertViewBaseTag      5000
#define TableViewBaseTag            6000

@interface AddEntrustFilingVC ()<UITableViewDelegate,UITableViewDataSource,TCPickViewDelegate,TZImagePickerControllerDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate,SearchRemindPersonDelegate,DateTimeSelected>{
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UIButton *_cleanEntrustfilingBtn;
    __weak IBOutlet UIButton *_saveEntrustfilingBtn;
    
    BOOL _hasPickView;
    BOOL _isSubmission;                             // 是否在提交中

    NSString *_signatory;                           // 签署人
    NSString *_signatoryId;                         // 签署人Id
    NSString *_signDeptKeyId;                       // 签署人部门Id
    NSString *_signTime;                            // 签署时间
    
    // 上传照片
    NSMutableDictionary *_photoAllDic;              // 将所有照片放到这个字典里面
    NSMutableArray *_photoTypeArray;                // 将所有照片类型放到一个集合
    NSMutableArray *_photoTypeIdArray;              // 照片类型对应Id放到一个集合
    NSMutableArray *_uploadPhotoArray;              // 上传到服务器的照片数组
    
    NSInteger _currentUploadArrayIndex;             // 该类型数组正在上传的index
    NSInteger _currentUploadPhotoTypeIndex;         // 正在上传照片类型下标
    NSInteger _photoSelectTypeIndex;                // 选择照片类型的下标
    NSInteger _photoMaxCount;                       // 上传照片最大数量
    NSInteger _photoMinCount;                       // 上传照片最小数量
    BOOL _isCancelUpload;                           // 是否取消上传
    BOOL _isChangePageValue;                        // 是否更改了页面上的值
    
    NSIndexPath *_selectIndexPath;
    NSDate *_dateTime;
    
    
    DateTimePickerDialog *_dateTimePickerDialog;
}

@property (nonatomic, copy) NSString * imageTypeName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *funcViewBottomCon;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation AddEntrustFilingVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}

#pragma mark - init
- (void)initView{
    
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.separatorColor = YCOtherColorDivider;
    _mainTableView.backgroundColor = [UIColor whiteColor];
    [_cleanEntrustfilingBtn setLayerCornerRadius:5];
    [_saveEntrustfilingBtn setLayerCornerRadius:5];
    
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomView.layer.shadowOpacity = 0.2;
    self.bottomView.layer.shadowRadius = 2;
    
    self.clearBtn.backgroundColor = YCTextColorRentOrange;
    self.saveBtn.backgroundColor = YCThemeColorGreen;
    
    self.funcViewBottomCon.constant = BOTTOM_SAFE_HEIGHT;
    self.imageTypeName = @"附件";
    
    [self setNavTitle:@"新增备案" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:nil];

}



- (void)initData{
    [self initArray];
    
    NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    [_photoAllDic setObject:photoArray forKey:self.imageTypeName];
    [_photoTypeIdArray addObject:self.imageTypeName];
    [_photoTypeArray addObject:self.imageTypeName];
    
    _signatory = [AgencyUserPermisstionUtil getIdentify].uName;     // 默认显示登录用户
    _signatoryId =  [AgencyUserPermisstionUtil getIdentify].uId;
    _signDeptKeyId = [AgencyUserPermisstionUtil getIdentify].departId;
    _signTime = [CommonMethod formatDateStrFromDate:[NSDate date]]; // 默认显示当前时间
    
    _photoMaxCount = 20;
    _photoMinCount = 1;
    _hasPickView = NO;
    _isSubmission = NO;
}

- (void)initArray{
    _uploadPhotoArray = [[NSMutableArray alloc] init];
    _photoAllDic = [[NSMutableDictionary alloc] init];
    _photoTypeArray = [[NSMutableArray alloc]init];
    _photoTypeIdArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setNavTitle:@"新增备案" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:nil];
    
}

#pragma mark - button Click methods

- (IBAction)cleanEntrustfiling:(id)sender{
    if (_isSubmission){
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否清空所有内容？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = CleanAlertViewBaseTag;
    [alertView show];
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        if (alertView.tag == BackAlertViewBaseTag){
            _isCancelUpload = YES;
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        if (_isSubmission){
            return;
        }
        
        if(alertView.tag == CleanAlertViewBaseTag){
            // 确定
            for (NSString *photoType in _photoTypeArray)
            {
                NSMutableArray *phptoArray = [[NSMutableArray alloc] init];
                [_photoAllDic setObject:phptoArray forKey:photoType];
            }
            _signTime = @"";
            _signatory = nil;
            [_mainTableView reloadData];
        }
        
        if (alertView.tag == CommitAlertViewBaseTag){
            _isSubmission = YES;
            [_mainTableView reloadData];
            
            [self showLoadingView:nil];
            
            // 上传照片，从第一个类型开始
            [self uploadPhotoArrayWithPhotoType:0];
        }
    }
}

#pragma mark - private
- (IBAction)commitEntrustfiling:(id)sender{
    if (_isSubmission){
        return;
    }
    // 提交条件判断
    if (_signatory.length <= 0 || _signTime.length <= 0){
        showMsg(@"请将必填项填写完整！");
        return;
    }
    if ([self calculatePhotoNumberAndPhotos:nil] < _photoMinCount){
        NSString *tips = [NSString stringWithFormat:@"请至少上传%d张附件", (int)_photoMinCount];
        showMsg(tips);
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否提交业主委托？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = CommitAlertViewBaseTag;
    [alertView show];
}

- (void)back{
    if (_isChangePageValue == NO){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSString *alertTitle = @"是否放弃本次编辑?";
    if (_isSubmission){
        alertTitle = @"正在上传照片，确定要放弃？";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = BackAlertViewBaseTag;
    [alertView show];
}

/// 选择备案照片
- (void)uploadPhotoClick:(UIButton *)button{
    if (_isSubmission){
        return;
    }
    
    _photoSelectTypeIndex = button.tag - UploadPhotoButtonBaseTag;
    
    [self addPhotoImage];
    
//    BYActionSheetView *byActionSheet = [[BYActionSheetView alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相机",@"手机相册", nil];
//    _photoSelectTypeIndex = button.tag - UploadPhotoButtonBaseTag;
//    [byActionSheet show];
}

/// 查看备案照片
- (void)viewPhotoClick:(UIButton *)button{
    if (_isSubmission){
        return;
    }
    ShowEntrustFilingPhotoVC *showEntrustFilingPhotoVC = [[ShowEntrustFilingPhotoVC alloc] initWithNibName:@"ShowEntrustFilingPhotoVC"
                                                                                                    bundle:nil];
    // 删除照片后刷新TableView
    showEntrustFilingPhotoVC.deletePhotoBlock = ^(){
        [_mainTableView reloadData];
    };

    // 先取出照片类型
    NSString *photoType = [_photoTypeArray objectAtIndex:button.tag - viewPhotoButtonBaseTag];
    
    showEntrustFilingPhotoVC.photoImageArray = [_photoAllDic objectForKey:photoType];
    showEntrustFilingPhotoVC.photoType = photoType;
    [self.navigationController pushViewController:showEntrustFilingPhotoVC animated:YES];
}

/// 开始上传照片到服务器
- (void)uploadPhotoToServerWithImageArray:(NSArray *)imageArray andImage:(UIImage *)image andPhotoTypeIndex:(NSInteger)photoTypeIndex{
    // 网络请求管理器
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer]; // JSON
    
    NSString *getImageServerUrl = [[BaseApiDomainUtil getApiDomain] getImageServerUrl]; // URl地址

    _currentUploadPhotoTypeIndex = photoTypeIndex;  // 上传照片类型下标

    [sessionManager POST:getImageServerUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 上传图片，一张一张传
        // 图片压缩，图片少压缩大一点，不然没进度蒙层
        NSData *imageData;
        if (imageArray.count > 10){
            imageData = UIImageJPEGRepresentation(image, 0.3);
        }
        else{
            imageData = UIImageJPEGRepresentation(image, 0.5);
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = CompleteNoFormat;
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpeg"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        // 进度蒙层
        float currentSumProgress = (float)_currentUploadArrayIndex + uploadProgress.fractionCompleted;
        NSInteger progress = currentSumProgress * (100 / imageArray.count);
        
        UploadPhotoCell *uploadPhotoCell = [_mainTableView viewWithTag:TableViewBaseTag + photoTypeIndex];
        uploadPhotoCell.shadowImageView.progressNumber = progress;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *imageUrl = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"imageUrl = %@",imageUrl);
        
        //截取图片名称
        NSString * imageName = @"";
        NSArray *strArr =[imageUrl componentsSeparatedByString:@"/"];
        imageName = [strArr lastObject];
        
        Attachments *attachments = [[Attachments alloc] init];
        attachments.keyId = @"";
        attachments.attachmentName = imageName;
        attachments.attachmentPath = imageUrl;
        attachments.attachmenSysTypeKeyId = _photoTypeIdArray[photoTypeIndex];
        attachments.attachmenSysType = @"";
        attachments.attachmenSysTypeName = _photoTypeArray[photoTypeIndex];
        [_uploadPhotoArray addObject:[attachments getReqBody]];
        
        _currentUploadArrayIndex ++;
        // 一张一张将该类型照片上传
        if (imageArray.count > _currentUploadArrayIndex){
            [self uploadPhotoToServerWithImageArray:imageArray andImage:imageArray[_currentUploadArrayIndex] andPhotoTypeIndex:photoTypeIndex];
        }
        else{
            // 继续上传下组类型照片
            _currentUploadArrayIndex = 0;
            _currentUploadPhotoTypeIndex ++;
            [self uploadPhotoArrayWithPhotoType:_currentUploadPhotoTypeIndex];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 失败
        showMsg(@"网络连接已中断,请重试");
        _isSubmission = NO;
        [_uploadPhotoArray removeAllObjects];
        [_mainTableView reloadData];
    }];
}

/// 批量上传照片
- (void)uploadPhotoArrayWithPhotoType:(NSInteger)photoTypeIndex{
    // 判断该类型有照片，则上传
    for (NSInteger i = photoTypeIndex; i < _photoTypeArray.count; i++){
        NSArray *photoArray = [_photoAllDic objectForKey:_photoTypeArray[photoTypeIndex]];
        if (photoArray.count > 0){
            //有照片则上传,退出循环
            [self uploadPhotoToServerWithImageArray:photoArray andImage:photoArray[0]  andPhotoTypeIndex:photoTypeIndex];
            return;
        }
        else{
            photoTypeIndex ++;
        }
    }
    
    // 没有照片或上传完成，保存提交
    if (photoTypeIndex >= _photoTypeArray.count && !_isCancelUpload){
        [self uploadToServer];
    }
}

/// 提交到服务器
- (void)uploadToServer{
    EntrustFilingAddApi *entrustFilingAddApi = [[EntrustFilingAddApi alloc] init];
    entrustFilingAddApi.keyId = @"";
    entrustFilingAddApi.propertyKeyId = _propertyKeyId;
    entrustFilingAddApi.propertyEntrustType = _signType;
    entrustFilingAddApi.signDate = _signTime;
    entrustFilingAddApi.signUserKeyId = _signatoryId;
    entrustFilingAddApi.signUserName = _signatory;
    entrustFilingAddApi.signDeptKeyId = _signDeptKeyId;
    entrustFilingAddApi.createUserKeyId = @"";
    entrustFilingAddApi.createDeptKeyId = @"";
    entrustFilingAddApi.createTime = @"";
    entrustFilingAddApi.corporationKeyId = @"";
    entrustFilingAddApi.cityKeyId = @"";
    entrustFilingAddApi.vsersion = @"";
    entrustFilingAddApi.trustAuditState = @"";
    entrustFilingAddApi.trustAuditDate = @"";
    entrustFilingAddApi.trustAuditPersonKeyId = @"";
    entrustFilingAddApi.attachments = _uploadPhotoArray;
    entrustFilingAddApi.commitEntrustfilingType = AddEntrustFiling;
    [_manager sendRequest:entrustFilingAddApi];
}

#pragma mark - <TCPickViewDelegate>

- (void)pickViewRemove{
    _hasPickView = NO;
}
//
//#pragma mark - <BYActionSheetDelegate>
//
//- (void)actionSheetView:(BYActionSheetView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex andButtonTitle:(NSString *)buttonTitle{
//    switch (buttonIndex){
//        case 0:{
//            // 拍照获取
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//            {
//                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//
//                [self presentViewController:imagePicker animated:YES completion:nil];
//            }
//            else
//            {
//                showMsg(@"相机不可用!");
//            }
//        }
//            break;
//
//        case 1:{
//            // 相册获取
//            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_photoMaxCount
//                                                                                                columnNumber:4
//                                                                                                    delegate:self
//                                                                                           pushPhotoPickerVc:YES];
//            // 在内部显示拍照按钮
//            imagePickerVc.allowTakePicture = NO;
//
//            // 设置是否可以选择视频
//            imagePickerVc.allowPickingVideo = NO;
//
//            // 设置是否可以选择原图
//            imagePickerVc.allowPickingOriginalPhoto = NO;
//
//            // 最多三十张
//            imagePickerVc.maxImagesCount = _photoMaxCount;
//
//            // 单选模式,maxImagesCount为1时才生效
//            imagePickerVc.circleCropRadius = 1;
//
//            // 你可以通过block或者代理，来得到用户选择的照片.
//            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//                if ([self calculatePhotoNumberAndPhotos:photos] > _photoMaxCount)
//                {
//                    NSString *showMsgStr = [NSString stringWithFormat:@"最多选择%@张照片",@(_photoMaxCount)];
//                    showMsg(showMsgStr);
//                    return;
//                }
//
//                _isChangePageValue = YES;
//                [self imageArrayAssignmentWithButtonTag:_photoSelectTypeIndex andSelectCompleteImageArray:photos];
//                [_mainTableView reloadData];
//            }];
//
//            [self presentViewController:imagePickerVc animated:YES completion:nil];
//        }
//            break;
//
//        default:
//            break;
//    }
//}

/// 选择后的照片字典赋值
- (void)imageArrayAssignmentWithButtonTag:(NSInteger)buttonTag
                          andSelectCompleteImageArray:(NSArray *)selectCompleteImageArray{
    // 先取出照片类型
    NSString *photoType = [_photoTypeArray objectAtIndex:buttonTag];
    
    [[_photoAllDic objectForKey:photoType] addObjectsFromArray:selectCompleteImageArray];
}

/// 计算照片数量
- (NSInteger)calculatePhotoNumberAndPhotos:(NSArray *)photos{
    // 计算选过照片数量
    NSInteger selectPhotoNumber = 0;
    for (NSArray *array in [_photoAllDic allValues]){
        selectPhotoNumber = selectPhotoNumber + array.count;
    }
    
    return selectPhotoNumber + photos.count;    // 选择过的加上当前选择的照片数量
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    if ([self calculatePhotoNumberAndPhotos:@[image]] > _photoMaxCount){
        NSString *showMsgStr = [NSString stringWithFormat:@"最多选择%@张照片",@(_photoMaxCount)];
        showMsg(showMsgStr);
        return;
    }
    
    _isChangePageValue = YES;
    [self imageArrayAssignmentWithButtonTag:_photoSelectTypeIndex andSelectCompleteImageArray:@[image]];
    [_mainTableView reloadData];
}

#pragma mark - <SearchRemindPersonDelegate>

- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem{
    NSIndexPath *indexPth = [NSIndexPath indexPathForRow:0 inSection:0];
    _signatoryId = selectRemindItem.resultKeyId;
    _signatory = selectRemindItem.resultName;
    _signDeptKeyId = selectRemindItem.departmentKeyId;
    _isChangePageValue = YES;
    [_mainTableView reloadRowsAtIndexPaths:@[indexPth] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 3;
    }

    return _photoTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        
        static NSString * identifier = @"AddEntrustFilingSignCell";
        
        AddEntrustFilingSignCell *addEntrustFilingSignCell = [tableView tableViewCellByNibWithIdentifier:identifier];
        
        addEntrustFilingSignCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [addEntrustFilingSignCell setCellValueWithIndexPath:indexPath
                                               andSignatory:_signatory
                                                andSignType:_signType
                                                andSignTime:_signTime
                                        andIsEditPermission:YES];
        return addEntrustFilingSignCell;
    }
    else{
        
        static NSString * identifier = @"JMEntrustUploadPhotoCell";
        
        JMEntrustUploadPhotoCell * cell = [tableView tableViewCellByNibWithIdentifier:identifier];
        
        [cell setPhotoArray:_photoAllDic[self.imageTypeName] andServerPhotoArray:nil];
        
        // 查看照片
        UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePhotoViewTouchWithTgr:)];
        
        [cell.imageConView addGestureRecognizer:tgr];
        
        [cell.addPhotoBtn addTarget:self action:@selector(addPhotoImage) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
//        UploadPhotoCell *uploadPhotoCell = [UploadPhotoCell cellWithTableView:tableView andIndexPath:indexPath];
//
//        // 给TableView设置tag，用于上传图片蒙层
//        uploadPhotoCell.tag = TableViewBaseTag + indexPath.row;
//
//        // 上传过的蒙层删除掉
//        if (_currentUploadPhotoTypeIndex > indexPath.row){
//            [uploadPhotoCell.shadowImageView removeFromSuperview];
//        }
//
//        // 上传照片
//        [uploadPhotoCell.uploadPhotoButton addTarget:self action:@selector(uploadPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
//        uploadPhotoCell.uploadPhotoButton.tag = UploadPhotoButtonBaseTag + indexPath.row;
//        NSLog(@"_photoAllDic===%@  _photoTypeArray===%@,",_photoAllDic,_photoTypeArray);
//        [uploadPhotoCell setCellValueWithIndexPath:indexPath
//                                       andPhotoDic:_photoAllDic
//                                 andServerPhotoDic:nil
//                               andPhotoTypeArray:_photoTypeArray
//                                   andIsSubmission:_isSubmission];
//        // 查看照片
//        [uploadPhotoCell.viewPhotoButton addTarget:self action:@selector(viewPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
//        uploadPhotoCell.viewPhotoButton.tag = viewPhotoButtonBaseTag + indexPath.row;
//
//        return uploadPhotoCell;
    }

    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_hasPickView || _isSubmission){
        return;
    }
    
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            // 签署人
            SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc] initWithNibName:@"SearchRemindPersonViewController" bundle:nil];
            searchRemindPersonVC.selectRemindType = PersonType;
            searchRemindPersonVC.delegate = self;

            [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
        }
        else if (indexPath.row == 1){
            // 签署时间
            _hasPickView = YES;
            [self selectDate:_signTime];
//            TCPickView *pickView = [[TCPickView alloc] initDatePickViewWithDate:[NSDate dateFromString:_signTime]mode:UIDatePickerModeDate];
//            pickView.myDelegate = self;
//            [self.view addSubview:pickView];
//            [pickView showPickViewWithResultBlock:^(id result){
//                
//                _isChangePageValue = YES;
//                _hasPickView = NO;
//                AddEntrustFilingSignCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                cell.rightTitleLabel.text = [CommonMethod subTime:result];
//                _signTime = [CommonMethod subTime:result];
//            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? CGFLOAT_MIN : 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        
        return 50;
        
    }
    
    NSArray * photoArr = _photoAllDic[self.imageTypeName];
    
    return photoArr.count == 0 ? 244 : 274;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return nil;
        
    }else{
        
        JMEntrustFilingHeaderView * headerView = [JMEntrustFilingHeaderView viewFromXib];
        
        headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 38);
        
        return headerView;
        
    }
    
}

#pragma mark - private
- (void)imagePhotoViewTouchWithTgr:(UITapGestureRecognizer *)tgr{
    
    if (_isSubmission){
        
        return;
        
    }
    
    NSMutableArray * photoArr = [_photoAllDic objectForKey:self.imageTypeName];
    
    if (photoArr.count == 0) {//添加
        
        [self addPhotoImage];
        
    }else{
        
        [self showPhotoImage];
        
    }
    
}

- (void)addPhotoImage{
    
    NSArray * listArr = @[@"相机",@"手机相册"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        switch (optionValue){
            case 0:{
                // 拍照获取
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = weakSelf;
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [weakSelf presentViewController:imagePicker animated:YES completion:nil];
                }
                else
                {
                    showMsg(@"相机不可用!");
                }
            }
                break;
                
            case 1:{
                // 相册获取
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_photoMaxCount
                                                                                                    columnNumber:4
                                                                                                        delegate:weakSelf
                                                                                               pushPhotoPickerVc:YES];
                // 在内部显示拍照按钮
                imagePickerVc.allowTakePicture = NO;
                
                // 设置是否可以选择视频
                imagePickerVc.allowPickingVideo = NO;
                
                // 设置是否可以选择原图
                imagePickerVc.allowPickingOriginalPhoto = NO;
                
                // 最多三十张
                imagePickerVc.maxImagesCount = _photoMaxCount;
                
                // 单选模式,maxImagesCount为1时才生效
                imagePickerVc.circleCropRadius = 1;
                
                // 你可以通过block或者代理，来得到用户选择的照片.
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    
                    if ([weakSelf calculatePhotoNumberAndPhotos:photos] > _photoMaxCount)
                    {
                        NSString *showMsgStr = [NSString stringWithFormat:@"最多选择%@张照片",@(_photoMaxCount)];
                        showMsg(showMsgStr);
                        return;
                    }
                    
                    _isChangePageValue = YES;
                    [weakSelf imageArrayAssignmentWithButtonTag:_photoSelectTypeIndex andSelectCompleteImageArray:photos];
                    [_mainTableView reloadData];
                }];
                
                [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
        
    }];
    
//    BYActionSheetView *byActionSheet = [[BYActionSheetView alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相机",@"手机相册", nil];
//
//    [byActionSheet show];
    
}

- (void)showPhotoImage{
    
    NSMutableArray * photoArr = [_photoAllDic objectForKey:self.imageTypeName];
    
    ShowEntrustFilingPhotoVC * showEntrustFilingPhotoVC = [[ShowEntrustFilingPhotoVC alloc] initWithNibName:@"ShowEntrustFilingPhotoVC" bundle:nil];
    // 删除照片后刷新TableView
    showEntrustFilingPhotoVC.deletePhotoBlock = ^(){
        
        [_mainTableView reloadData];
        
    };
    
    showEntrustFilingPhotoVC.photoImageArray = photoArr;
    
    showEntrustFilingPhotoVC.photoType = self.imageTypeName;
    
    [self.navigationController pushViewController:showEntrustFilingPhotoVC animated:YES];
    
}

#pragma mark - 选择时间
- (void)selectDate:(NSString *)date{
    _dateTimePickerDialog = [DateTimePickerDialog initWithParentView:self.view
                                                         andDelegate:self
                                                              andTag:@"end"];
    _dateTimePickerDialog.datePickerMode = UIDatePickerModeDate;
    NSDate *defaultDate = [NSDate dateFromString:date];
    _dateTime = defaultDate;
    [_dateTimePickerDialog showWithDate:defaultDate andTipTitle:@"选择签署时间"];
}

#pragma mark - 选择时间结果回调
- (void)selectedResultWithSender:(NSObject *)sender andDate:(NSDate *)dateTime{
    _dateTime = dateTime;
}

// 确定
- (void)clickDone{
    _dateTime = _dateTimePickerDialog.datePickerView.date;
    _isChangePageValue = YES;
    _hasPickView = NO;
    AddEntrustFilingSignCell *cell = [_mainTableView cellForRowAtIndexPath:_selectIndexPath];
    cell.rightTitleLabel.text = [NSDate stringWithSimpleDate:_dateTime];
    _signTime = [NSDate stringWithSimpleDate:_dateTime];
    
    [_mainTableView reloadData];
}

// 取消
- (void)clickCancle{
    _hasPickView = NO;
    _isChangePageValue = YES;
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass{
    [self hiddenLoadingView];
    if ([modelClass isEqual:[AgencyBaseEntity class]]){
        AgencyBaseEntity *agencyBaseEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (agencyBaseEntity.flag){
            [CustomAlertMessage showAlertMessage:@"新增委托成功"
                                 andButtomHeight:(APP_SCREEN_HEIGHT - APP_NAV_HEIGHT) / 2];
            
            self.addEntrustfilingSuccBlock ? self.addEntrustfilingSuccBlock() : nil;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        _isSubmission = NO;
        [_mainTableView reloadData];
        showMsg(@"提交失败，请重试!");
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    _isSubmission = NO;
    [_mainTableView reloadData];
    [super respFail:error andRespClass:cls];
}

@end
