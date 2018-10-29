//
//  EditEntrustFilingVC.m
//  PanKeTong
//
//  Created by 张旺 on 2017/7/28.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "EditEntrustFilingVC.h"
#import "EntrustFilingEditApi.h"
#import "EntrustFilingEditEntity.h"
#import "EntrustFilingEditDetailEntity.h"
#import "EntrustFilingAddApi.h"
#import "EntrustFilingDeleteApi.h"

#import "TCPickView.h"
#import "AudioPlayView.h"
//#import "UploadPhotoCell.h"
#import "JMEntrustUploadPhotoCell.h"
#import "AddEntrustFilingSignCell.h"
#import "TZImagePickerController.h"
#import "ShowEntrustFilingPhotoVC.h"
#import "SearchRemindPersonViewController.h"
#import "DateTimePickerDialog.h"

#import "JMEntrustFilingHeaderView.h"

#import "UITableView+Category.h"


#define UploadPhotoButtonBaseTag    1000
#define viewPhotoButtonBaseTag      2000
#define BackAlertViewBaseTag        3000
#define CleanAlertViewBaseTag       4000
#define DeleteAlertViewBaseTag      5000
#define SaveAlertViewBaseTag        6000
#define AudioPlayerTag              7000
#define TableViewBaseTag            8000
///备案枚举状态
enum TrustAuditingStatusEnum{
    UNAPPROVED = 0, // 待审核
    APPROVED = 1,   // 审核通过
    REJECT = 2,     // 审核拒绝
};
@interface EditEntrustFilingVC ()<UITableViewDelegate,UITableViewDataSource,TCPickViewDelegate,TZImagePickerControllerDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate,SearchRemindPersonDelegate, DateTimeSelected>
{
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UIView *_bottomView;
    __weak IBOutlet UIButton *_cleanEntrustfilingBtn;
    __weak IBOutlet UIButton *_saveEntrustfilingBtn;
    
    EntrustFilingEditDetailEntity *_entrustFilingEditDetailEntity;
    
    // 上传照片
    NSMutableDictionary *_addPhotoDic;              // 手动添加的照片
    NSMutableDictionary *_serverPhotoDic;           // 从接口拿到的照片
    NSMutableArray *_photoTypeArray;                // 将所有照片类型放到一个集合
    NSMutableArray *_photoTypeIdArray;              // 照片类型对应Id放到一个集合
    NSMutableArray *_uploadPhotoArray;              // 上传到服务器的照片数组
    
    NSInteger _photoSelectTypeIndex;                // 选择照片类型的下标
    NSInteger _currentUploadPhotoTypeIndex;         // 正在上传照片类型下标
    NSInteger _currentUploadArrayIndex;             // 该类型数组里面正在上传的index
    NSInteger _addPhotoMaxCount;                    // 上传照片最大数量
    NSInteger _addPhotoMinCount;                    // 上传照片最小数量
    NSInteger _photoMaxTotalNumber;                 // 照片最大总量
    NSIndexPath *_selectIndexPath;
    NSDate *_dateTime;
    
    BOOL _hasPickView;
    BOOL _isSubmission;                             // 是否在提交中
    BOOL _isViewPermission;                         // 是否有查看权限
    BOOL _isEditPermission;                         // 是否有编辑权限
    BOOL _isChangePageValue;                        // 是否更改了页面上的值
    BOOL _haveAudio;                                // 是否有录音附件
    BOOL _isCancelUpload;                           // 是否取消上传
    BOOL _isUploadPhotoFailed;                      // 上传照片是否失败
    BOOL _isDeleteEntrustFiling;                    // 是否删除备案
    
    
    DateTimePickerDialog *_dateTimePickerDialog;
}

@property (nonatomic, copy) NSString * imageTypeName;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomCon;

@end

@implementation EditEntrustFilingVC

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 注释掉  否则返回的时候 详情页有问题
   // [self setNavigationBarIsHasOffline:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 如果正在播放，暂停
    if (_isPlaying)
    {
        AudioPlayView *audioPlayView = [_mainTableView viewWithTag:AudioPlayerTag];
        [audioPlayView audioPlayOrPause];
    }
}

#pragma mark - init

- (void)initView
{
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.separatorColor = YCOtherColorDivider;
    _mainTableView.backgroundColor = [UIColor whiteColor];
    [_cleanEntrustfilingBtn setLayerCornerRadius:5];
    [_saveEntrustfilingBtn setLayerCornerRadius:5];
    self.bottomViewBottomCon.constant = BOTTOM_SAFE_HEIGHT;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomView.layer.shadowOpacity = 0.2;
    self.bottomView.layer.shadowRadius = 2;
    self.clearBtn.backgroundColor = YCTextColorRentOrange;
    self.saveBtn.backgroundColor = YCThemeColorGreen;
    self.imageTypeName = @"附件";
    
    [self setNavTitle:@"编辑备案" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:[self customBarItemButton:@"删除" backgroundImage:nil foreground:nil sel:@selector(deleteEntrustfiling)]];
}



//陈行注释，现在已经不做审核状态判断了
//- (NSString *)setNavTitle
//{
//    NSString *navTitle = @"编辑备案";
//    if ([_trustAuditState integerValue] == UNAPPROVED)
//    {
//        navTitle = @"待审核";
//    }
//
//    return navTitle;
//}

- (void)initData
{
    [self initArray];
    
    _isViewPermission = NO;
    _isEditPermission = NO;
    _hasPickView = NO;
    _isSubmission = NO;
    _isChangePageValue = NO;
    _isDeleteEntrustFiling = NO;
    
    _addPhotoMaxCount = 20;
    _addPhotoMinCount = 1;
    _photoMaxTotalNumber = 50;
    
    // 获取编辑委托信息
    [self showLoadingView:nil];
    EntrustFilingEditApi *entrustFilingEditApi = [[EntrustFilingEditApi alloc] init];
    entrustFilingEditApi.keyId = _propertyKeyId;
    [_manager sendRequest:entrustFilingEditApi];
}

- (void)initArray
{
    _uploadPhotoArray = [[NSMutableArray alloc] init];
    _addPhotoDic = [[NSMutableDictionary alloc] init];
    _serverPhotoDic = [[NSMutableDictionary alloc] init];
    _photoTypeArray = [[NSMutableArray alloc] init];
    _photoTypeIdArray = [[NSMutableArray alloc] init];
}

#pragma mark - 获取委托权限

///// 获取查看委托权限
//- (BOOL)getViewEntrustFilingPermission
//{
//    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_REGISTERTRUSTS_VIEW_NONE])
//    {
//        // 没有
//        return NO;
//    }
//    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_REGISTERTRUSTS_VIEW_MYSELF])
//    {
//        // 本人 判断登录用户id跟签署人id
//        if ([[AgencyUserPermisstionUtil getIdentify].uId isEqualToString:_entrustFilingEditDetailEntity.signUserKeyId])
//        {
//            return YES;
//        }
//
//        return NO;
//    }
//    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_REGISTERTRUSTS_VIEW_MYDEPARTMENT])
//    {
//        // 本部  判断签署人部门id是否包含在该用户部门权限里面
//        NSString *departmentKeyIds = [AgencyUserPermisstionUtil getAgencyPermisstion].departmentKeyIds;
//
//        if ([AgencyUserPermisstionUtil Content:departmentKeyIds ContainsWith:_entrustFilingEditDetailEntity.signDeptKeyId])
//        {
//            return YES;
//        }
//
//        return NO;
//    }
//
//    // 全部
//    return YES;
//}

///// 获取编辑委托权限
//- (BOOL)getEditEntrustFilingPermission
//{
//    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_REGISTERTRUSTS_MODIFY_NONE])
//    {
//        // 没有
//        return NO;
//    }
//    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_REGISTERTRUSTS_MODIFY_MYSELF])
//    {
//        // 本人 判断登录用户id跟签署人id
//        if ([[AgencyUserPermisstionUtil getIdentify].uId isEqualToString:_entrustFilingEditDetailEntity.signUserKeyId])
//        {
//            return YES;
//        }
//
//        return NO;
//    }
//    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_REGISTERTRUSTS_MODIFY_MYDEPARTMENT])
//    {
//        // 本部  判断签署人部门id是否包含在该用户部门权限里面
//        NSString *departmentKeyIds = [AgencyUserPermisstionUtil getAgencyPermisstion].departmentKeyIds;
//
//        if ([AgencyUserPermisstionUtil Content:departmentKeyIds ContainsWith:_entrustFilingEditDetailEntity.signDeptKeyId])
//        {
//            return YES;
//        }
//
//        return NO;
//    }
//
//    // 全部
//    return YES;
//}

#pragma mark - button Click methods

/// 清空备案
- (IBAction)cleanEntrustfiling:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否清空所有内容？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = CleanAlertViewBaseTag;
    [alertView show];
}

/// 删除备案
-(void)deleteEntrustfiling
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否删除该房源的业主委托信息？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = DeleteAlertViewBaseTag;
    [alertView show];
}

/// 保存备案
- (IBAction)saveEntrustfiling:(id)sender
{
    if (_isSubmission)
    {
        return;
    }
    // 提交条件判断
    if (_entrustFilingEditDetailEntity.signUserName.length <= 0 || _entrustFilingEditDetailEntity.signDate.length <= 0)
    {
        showMsg(@"请将必填项填写完整！");
        return;
    }
    
    if ([self calculatePhotoTotalNumberWithPhotos:nil] < _addPhotoMinCount)
    {
        NSString *tips = [NSString stringWithFormat:@"请至少上传%d张附件", (int)_addPhotoMinCount];
        showMsg(tips);
        return;
    }
    
    if (_isChangePageValue)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认修改该房源的业主委托信息？"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = SaveAlertViewBaseTag;
        [alertView show];
    }
    else
    {
        // 保存提交
        _isSubmission = YES;
        
        // 上传照片，从第一个类型开始
        [self uploadPhotoArrayWithPhotoType:0];
    }
}

/// 选择备案照片
- (void)uploadPhotoClick:(UIButton *)button
{
    if (_isSubmission)
    {
        return;
    }
    
    _photoSelectTypeIndex = button.tag - UploadPhotoButtonBaseTag;
    
    [self addPhotoImage];
    
//    BYActionSheetView *byActionSheet = [[BYActionSheetView alloc]initWithTitle:nil
//                                                                      delegate:self
//                                                             cancelButtonTitle:@"取消"
//                                                             otherButtonTitles:@"相机",@"手机相册", nil];
//    _photoSelectTypeIndex = button.tag - UploadPhotoButtonBaseTag;
//    [byActionSheet show];
}

#pragma mark -  查看备案照片
- (void)viewPhotoClick:(UIButton *)button
{
    if (_isSubmission)
    {
        return;
    }
    ShowEntrustFilingPhotoVC *showEntrustFilingPhotoVC = [[ShowEntrustFilingPhotoVC alloc] initWithNibName:@"ShowEntrustFilingPhotoVC"
                                                                                                    bundle:nil];
    // 删除照片后刷新TableView
    showEntrustFilingPhotoVC.deletePhotoBlock = ^(){
        _isChangePageValue = YES;
        [_mainTableView reloadData];
    };
    
    // 先取出照片类型
    NSString *photoType = [_photoTypeArray objectAtIndex:button.tag - viewPhotoButtonBaseTag];
    
    showEntrustFilingPhotoVC.photoImageArray = [_addPhotoDic objectForKey:photoType];
    showEntrustFilingPhotoVC.serverPhotoArray = [_serverPhotoDic objectForKey:photoType];
    showEntrustFilingPhotoVC.uploadPhotoDetailArray = _uploadPhotoArray;
    showEntrustFilingPhotoVC.isOnlyViewPermission = !_isEditPermission;
    showEntrustFilingPhotoVC.photoType = photoType;

    [self.navigationController pushViewController:showEntrustFilingPhotoVC animated:YES];
}

- (void)back
{
    if (_isEditPermission == NO || _isChangePageValue == NO)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSString *alertTitle = @"是否放弃本次编辑?";
    if (_isSubmission)
    {
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

#pragma mark - 上传照片，提交

/// 批量上传照片
- (void)uploadPhotoArrayWithPhotoType:(NSInteger)photoTypeIndex
{
    // 判断该类型有照片，则上传
    for (NSInteger i = photoTypeIndex; i < _photoTypeArray.count; i++)
    {
        NSArray *photoArray = [_addPhotoDic objectForKey:_photoTypeArray[photoTypeIndex]];
        if (photoArray.count > 0)
        {
            //有照片则上传,退出循环
            [self uploadPhotoToServerWithImageArray:photoArray andImage:photoArray[0]  andPhotoTypeIndex:photoTypeIndex];
            return;
        }
        else
        {
            photoTypeIndex ++;
        }
    }
    
    // 没有照片或上传完成，保存提交
    if (photoTypeIndex >= _photoTypeArray.count && !_isCancelUpload)
    {
        [self uploadToServer];
    }
}

/// 开始上传照片到服务器
- (void)uploadPhotoToServerWithImageArray:(NSArray *)imageArray andImage:(UIImage *)image andPhotoTypeIndex:(NSInteger)photoTypeIndex
{
    // 网络请求管理器
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer]; // JSON
    
    NSString *getImageServerUrl = [[BaseApiDomainUtil getApiDomain] getImageServerUrl]; // URl地址
    
    _currentUploadPhotoTypeIndex = photoTypeIndex;  // 上传照片类型下标
    
    [sessionManager POST:getImageServerUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 上传图片，一张一张传
        // 图片压缩，图片少压缩大一点，不然没进度蒙层
        NSData *imageData;
        if (imageArray.count > 10)
        {
            imageData = UIImageJPEGRepresentation(image, 0.3);
        }
        else
        {
            imageData = UIImageJPEGRepresentation(image, 0.5);
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = CompleteNoFormat;
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        // 进度蒙层
//        float currentSumProgress = (float)_currentUploadArrayIndex + uploadProgress.fractionCompleted;
//        NSInteger progress = currentSumProgress * (100 / imageArray.count);
//
//        UploadPhotoCell *uploadPhotoCell = [_mainTableView viewWithTag:TableViewBaseTag + photoTypeIndex];
//        uploadPhotoCell.shadowImageView.progressNumber = progress;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *imageUrl = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"imageUrl = %@",imageUrl);
        
        //截取图片名称
        NSString * imageName = @"";
        NSArray *strArr = [imageUrl componentsSeparatedByString:@"/"];
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
        if (imageArray.count > _currentUploadArrayIndex)
        {
            [self uploadPhotoToServerWithImageArray:imageArray andImage:imageArray[_currentUploadArrayIndex] andPhotoTypeIndex:photoTypeIndex];
        }
        else
        {
            // 继续上传下组类型照片
            _currentUploadArrayIndex = 0;
            _currentUploadPhotoTypeIndex ++;
            [self uploadPhotoArrayWithPhotoType:_currentUploadPhotoTypeIndex];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 失败
        showMsg(@"网络连接已中断,请重试");
        _isSubmission = NO;
        _isUploadPhotoFailed = YES;
        [_photoTypeArray removeAllObjects];
        [_uploadPhotoArray removeAllObjects];
        [self setPhotoInfoAndPermission];
    }];
}

/// 提交到服务器
- (void)uploadToServer
{
    [self showLoadingView:@"正在提交"];
    EntrustFilingAddApi *entrustFilingAddApi = [[EntrustFilingAddApi alloc] init];
    entrustFilingAddApi.keyId = _entrustFilingEditDetailEntity.keyId;
    entrustFilingAddApi.propertyKeyId = _propertyKeyId;
    entrustFilingAddApi.propertyEntrustType = _signType;
    entrustFilingAddApi.signDate = _entrustFilingEditDetailEntity.signDate;
    entrustFilingAddApi.signUserKeyId = _entrustFilingEditDetailEntity.signUserKeyId;
    entrustFilingAddApi.signUserName = _entrustFilingEditDetailEntity.signUserName;
    entrustFilingAddApi.signDeptKeyId = _entrustFilingEditDetailEntity.signDeptKeyId;
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
    entrustFilingAddApi.commitEntrustfilingType = EditEntrustFiling;
    
    [_manager sendRequest:entrustFilingAddApi];
}

#pragma mark - 设置从接口拿到的照片

/// 从接口拿到编辑备案，设置照片信息跟权限
- (void)setPhotoInfoAndPermission
{
    [self setPermissionAndView];
    
    NSString * keyName = self.imageTypeName;
    
    // 有编辑权限配置所有上传照片类型
    if (_isEditPermission == YES)
    {
        
        if (!_isUploadPhotoFailed) {
            // 一个类型一个数组
            NSMutableArray * photoArray = [[NSMutableArray alloc] init];
            [_addPhotoDic setObject:photoArray forKey:keyName];
        }
        
        NSMutableArray * serverphotoArray = [[NSMutableArray alloc] init];
        [_serverPhotoDic setObject:serverphotoArray forKey:keyName];
        
        
        [_photoTypeIdArray addObject:@"asf"];
        [_photoTypeArray addObject:keyName];
        
//        SysParamItemEntity *sysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_ENTRUSTFILING_PHOTOTYPE];
//
//        for (SelectItemDtoEntity *itemDtoEntity in sysParamItemEntity.itemList)
//        {
//            // 手动添加的照片
//            if (!_isUploadPhotoFailed)
//            {
//                // 一个类型一个数组
//                NSMutableArray * photoArray = [[NSMutableArray alloc] init];
//                [_addPhotoDic setObject:photoArray forKey:itemDtoEntity.itemText];
//            }
//
//            NSMutableArray * serverphotoArray = [[NSMutableArray alloc] init];
//            [_serverPhotoDic setObject:serverphotoArray forKey:itemDtoEntity.itemText];
//
//            [_photoTypeIdArray addObject:itemDtoEntity.itemValue];
//            [_photoTypeArray addObject:itemDtoEntity.itemText];
//            if ([itemDtoEntity.itemText isEqualToString:@"录音"])
//            {
//                // 录音类型不可编辑，删除
//                [_photoTypeArray removeObject:itemDtoEntity.itemText];
//                [_photoTypeIdArray removeObject:itemDtoEntity.itemValue];
//            }
//        }
    }
    
    for (AttachmentArray *attachment in _entrustFilingEditDetailEntity.attachmentArray)
    {
        if (attachment.attachmenSysTypeName.length < 1)
        {
            // 没有照片类型则设置成其他
            attachment.attachmenSysTypeName = keyName;
            
            if (attachment.attachmenSysTypeKeyId.length < 1)
            {
                attachment.attachmenSysTypeKeyId = @"";
            }
        }
        
        // 没有编辑权限，只显示从接口拿到的照片类型
        if (_isEditPermission == NO)
        {
            // 没有该类型照片数组，则创建
            if (![[_serverPhotoDic allKeys]containsObject:attachment.attachmenSysTypeName])
            {
                NSMutableArray * serverphotoArray = [[NSMutableArray alloc] init];
                [_serverPhotoDic setObject:serverphotoArray forKey:attachment.attachmenSysTypeName];
                [_photoTypeArray addObject:attachment.attachmenSysTypeName];
                
//                if ([attachment.attachmenSysTypeName isEqualToString:@"录音"])
//                {
//                    // 录音类型不可查看图片，删除
//                    [_photoTypeArray removeObject:attachment.attachmenSysTypeName];
//                }
            }
        }
        
        // 从接口拿到的照片路径添加到字典里
        [[_serverPhotoDic objectForKey:attachment.attachmenSysTypeName] addObject:attachment.attachmentPath];
        
//        // 有录音将录音添加到数组，下标为0，作为第一个显示
//        if ([attachment.attachmenSysTypeName isEqualToString:@"录音"])
//        {
//            _haveAudio = YES;
//            [_photoTypeArray insertObject:attachment.attachmenSysTypeName atIndex:0];
//            [_photoTypeIdArray insertObject:attachment.attachmenSysTypeKeyId atIndex:0];
//        }
        
        // 从接口拿到的照片信息添加到上传服务器数组
        Attachments *attachments = [[Attachments alloc] init];
        attachments.keyId = @"";
        attachments.attachmentName = attachment.attachmentName;
        attachments.attachmentPath = attachment.attachmentPath;
        attachments.attachmenSysTypeKeyId = attachment.attachmenSysTypeKeyId;
        attachments.attachmenSysType = @"";
        attachments.attachmenSysTypeName = attachment.attachmenSysTypeName;
        [_uploadPhotoArray addObject:[attachments getReqBody]];
    }
    
    [_mainTableView reloadData];
}

/// 设置权限跟视图
- (void)setPermissionAndView
{
//    // 判断是否有查看权限
//    if ([self getViewEntrustFilingPermission])
//    {
//        _isViewPermission = YES;
//    }
    
//    // 审核后判断是否有编辑权限
//    if ([self getEditEntrustFilingPermission])
//    {
//        _isEditPermission = YES;
//    }
    
    // 判断是否有查看权限
    BOOL isCanAdd1 = [AgencyUserPermisstionUtil hasRight:PROPERTY_REGISTERTRUSTS_VIEW_ALL];
    if (isCanAdd1) {
        _isViewPermission = YES;
    }
    
    // 审核后判断是否有编辑权限
    BOOL isCanAdd2 = [AgencyUserPermisstionUtil hasRight:PROPERTY_REGISTERTRUSTS_MODIFY_ALL];
    if (isCanAdd2) {
        _isEditPermission = YES;
    }
    
    UIButton * rightBtn = [self customBarItemButton:@"删除" backgroundImage:nil foreground:nil sel:@selector(deleteEntrustfiling)];
    
    if (_isEditPermission == NO)
    {
        _bottomView.hidden = YES;
        rightBtn = nil;
        
    }
    
    [self setNavTitle:@"编辑备案" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:rightBtn];
    
    [_mainTableView reloadData];
    
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == BackAlertViewBaseTag)
        {
            _isCancelUpload = YES;
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        if (_isSubmission)
        {
            return;
        }
        
        if(alertView.tag == CleanAlertViewBaseTag)
        {
            // 清空
            for (NSString *photoType in _photoTypeArray)
            {
                NSMutableArray * phptoArray = [[NSMutableArray alloc] init];
                [_addPhotoDic setObject:phptoArray forKey:@"其他"];
            }
            // 编辑委托时录音不可单独删除，即点击清空按钮，图片清空，录音不变
            if (_haveAudio)
            {
                NSArray *audioArray = [_serverPhotoDic objectForKey:@"录音"];
                [_serverPhotoDic removeAllObjects];
                [_serverPhotoDic setObject:audioArray forKey:@"录音"];
                
                NSInteger uploadPhotoArrayCount = _uploadPhotoArray.count;
                NSInteger removeArrayIndex = _uploadPhotoArray.count;
                for (int i = 0; i < uploadPhotoArrayCount; i ++)
                {
                    NSDictionary *dic = _uploadPhotoArray[removeArrayIndex - 1];
                    
                    AttachmentArray *attachment = [DataConvert convertDic:dic toEntity:[AttachmentArray class]];
                    if (![attachment.attachmenSysTypeName isEqualToString:@"录音"])
                    {
                        [_uploadPhotoArray removeObject:dic];
                    }
                    removeArrayIndex --;
                }
            }
            else
            {
                _serverPhotoDic = nil;
                [_uploadPhotoArray removeAllObjects];
            }
            
            _entrustFilingEditDetailEntity.signDate = @"";
            _entrustFilingEditDetailEntity.signUserName = nil;
            
            _isChangePageValue = YES;
            
            [_mainTableView reloadData];
        }
        else if (alertView.tag == DeleteAlertViewBaseTag)
        {
            
            // 删除委托
            EntrustFilingDeleteApi *entrustFilingDeleteApi = [[EntrustFilingDeleteApi alloc] init];
            entrustFilingDeleteApi.keyId = _entrustFilingEditDetailEntity.keyId;
            [_manager sendRequest:entrustFilingDeleteApi];
            _isDeleteEntrustFiling = YES;
            [self showLoadingView:@"正在删除"];
        }
        else
        {
            // 保存提交
            _isSubmission = YES;
            [_mainTableView reloadData];
            
            // 上传照片，从第一个类型开始
            [self uploadPhotoArrayWithPhotoType:0];
        }
    }
}

#pragma mark - <TCPickViewDelegate>

- (void)pickViewRemove
{
    _hasPickView = NO;
}

//#pragma mark - <BYActionSheetDelegate>
//
//- (void)actionSheetView:(BYActionSheetView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex andButtonTitle:(NSString *)buttonTitle
//{
//    switch (buttonIndex)
//    {
//        case 0:
//        {
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
//        case 1:
//        {
//            // 相册获取
//            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_addPhotoMaxCount
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
//            imagePickerVc.maxImagesCount = _addPhotoMaxCount;
//
//            // 单选模式,maxImagesCount为1时才生效
//            imagePickerVc.circleCropRadius = 1;
//
//            // 你可以通过block或者代理，来得到用户选择的照片.
//            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//                if ([self judgementPhotoIsOverLimitWithPhotoArray:photos])
//                {
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
              andSelectCompleteImageArray:(NSArray *)selectCompleteImageArray
{
    // 先取出照片类型
    NSString *photoType = [_photoTypeArray objectAtIndex:buttonTag];
    
    [[_addPhotoDic objectForKey:photoType] addObjectsFromArray:selectCompleteImageArray];
}

/// 判断照片是否超出限制
- (BOOL)judgementPhotoIsOverLimitWithPhotoArray:(NSArray *)photoArray
{
    if ([self calculatePhotoNumberWithPhotos:photoArray] > _addPhotoMaxCount)
    {
        NSString *showMsgStr = [NSString stringWithFormat:@"最多选择%@张照片",@(_addPhotoMaxCount)];
        showMsg(showMsgStr);
        return YES;
    }
    
    if ([self calculatePhotoTotalNumberWithPhotos:photoArray] > _photoMaxTotalNumber)
    {
        NSString *showMsgStr = [NSString stringWithFormat:@"附件最多%@张",@(_photoMaxTotalNumber)];
        showMsg(showMsgStr);
        return YES;
    }
    
    return NO;
}

/// 计算手动添加的照片数量
- (NSInteger)calculatePhotoNumberWithPhotos:(NSArray *)photos
{
    // 计算选过照片数量
    NSInteger addPhotoNumber = 0;
    for (NSArray *addArray in [_addPhotoDic allValues])
    {
        addPhotoNumber = addPhotoNumber + addArray.count;
    }
    
    return addPhotoNumber + photos.count;
}

/// 计算照片总数量
- (NSInteger)calculatePhotoTotalNumberWithPhotos:(NSArray *)photos
{
    // 计算选过照片数量
    NSInteger addPhotoNumber = 0;
    for (NSArray *addArray in [_addPhotoDic allValues])
    {
        addPhotoNumber = addPhotoNumber + addArray.count;
    }
    
    NSInteger serverPhotoNumber = 0;
    for (NSArray *serverArray in [_serverPhotoDic allValues])
    {
        serverPhotoNumber = serverPhotoNumber + serverArray.count;
    }
    
    return addPhotoNumber + serverPhotoNumber + photos.count; // 手动添加过的 + 接口拿到的 + 当前选择的
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if ([self judgementPhotoIsOverLimitWithPhotoArray:@[image]])
    {
        return;
    }
    
    _isChangePageValue = YES;
    [self imageArrayAssignmentWithButtonTag:_photoSelectTypeIndex andSelectCompleteImageArray:@[image]];
    [_mainTableView reloadData];
}

#pragma mark - <SearchRemindPersonDelegate>

- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem
{
    _isChangePageValue = YES;
    NSIndexPath *indexPth = [NSIndexPath indexPathForRow:0 inSection:0];
    _entrustFilingEditDetailEntity.signUserKeyId = selectRemindItem.resultKeyId;
    _entrustFilingEditDetailEntity.signUserName = selectRemindItem.resultName;
    _entrustFilingEditDetailEntity.signDeptKeyId = selectRemindItem.departmentKeyId;
    [_mainTableView reloadRowsAtIndexPaths:@[indexPth] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isViewPermission == NO)
    {
        return 1;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    
    return _photoTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString * identifier = @"AddEntrustFilingSignCell";
        
        AddEntrustFilingSignCell *addEntrustFilingSignCell = [tableView tableViewCellByNibWithIdentifier:identifier];
        
        addEntrustFilingSignCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [addEntrustFilingSignCell setCellValueWithIndexPath:indexPath
                                               andSignatory:_entrustFilingEditDetailEntity.signUserName
                                                andSignType:_signType
                                                andSignTime:[CommonMethod subTime:_entrustFilingEditDetailEntity.signDate]
                                        andIsEditPermission:_isEditPermission];
        return addEntrustFilingSignCell;
    }
    else
    {
        
        static NSString * identifier = @"JMEntrustUploadPhotoCell";
        
        JMEntrustUploadPhotoCell * cell = [tableView tableViewCellByNibWithIdentifier:identifier];
        
        NSString *photoType = [_photoTypeArray objectAtIndex:0];
        
        [cell setPhotoArray:[_addPhotoDic objectForKey:photoType] andServerPhotoArray:[_serverPhotoDic objectForKey:photoType]];
        
        // 查看照片
        UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePhotoViewTouchWithTgr:)];
        
        [cell.imageConView addGestureRecognizer:tgr];
        
        [cell.addPhotoBtn addTarget:self action:@selector(addPhotoImage) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.addPhotoBtn.hidden = !_isEditPermission;
        
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasPickView || _isSubmission || _isEditPermission == NO)
    {
        return;
    }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            // 签署人
            SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
                                                                      initWithNibName:@"SearchRemindPersonViewController"
                                                                      bundle:nil];
            searchRemindPersonVC.selectRemindType = PersonType;
            searchRemindPersonVC.delegate = self;
            
            [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
        }
        else if (indexPath.row == 1)
        {
            // 签署时间
            _hasPickView = YES;
            
            NSString *data = _entrustFilingEditDetailEntity.signDate;
            if ([_entrustFilingEditDetailEntity.signDate contains:@"T"])
            {
                data = [CommonMethod getFormatDateStrFromTime:_entrustFilingEditDetailEntity.signDate];
            }
            _selectIndexPath = indexPath;
            
            [self selectDate:data];
        }
    }
}

- (void)selectDate:(NSString *)date
{
    _dateTimePickerDialog = [DateTimePickerDialog initWithParentView:self.view
                                                        andDelegate:self
                                                             andTag:@"end"];
    _dateTimePickerDialog.datePickerMode = UIDatePickerModeDate;
    
    NSDate *defaultDate = [NSDate dateFromString:date];
    _dateTime = defaultDate;
    [_dateTimePickerDialog showWithDate:defaultDate andTipTitle:@"选择签署时间"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? CGFLOAT_MIN : 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 50;
    }
    
    NSString *photoType = [_photoTypeArray objectAtIndex:0];
    
    NSArray * photoArr = [_addPhotoDic objectForKey:photoType];
    
    NSArray * serverPhotoArr = [_serverPhotoDic objectForKey:photoType];
    
    return (photoArr.count + serverPhotoArr.count) == 0 ? 244 : 274;
    
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
    
//    NSMutableArray * photoArr = [_photoAllDic objectForKey:self.imageTypeName];
    
    // 先取出照片类型
    NSString *photoType = [_photoTypeArray objectAtIndex:0];
    
    NSArray * photoArr = [_addPhotoDic objectForKey:photoType];
    NSArray * serverPhotoArray = [_serverPhotoDic objectForKey:photoType];
    
    if (photoArr.count == 0 && serverPhotoArray.count == 0) {//添加
        
        [self addPhotoImage];
        
    }else{
        
        [self showPhotoImage];
        
    }
    
}

- (void)addPhotoImage{
    
    NSArray * listArr = @[@"相机", @"手机相册"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        switch (optionValue)
        {
            case 0:
            {
                // 拍照获取
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
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
                
            case 1:
            {
                // 相册获取
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_addPhotoMaxCount
                                                                                                    columnNumber:4
                                                                                                        delegate:self
                                                                                               pushPhotoPickerVc:YES];
                // 在内部显示拍照按钮
                imagePickerVc.allowTakePicture = NO;
                
                // 设置是否可以选择视频
                imagePickerVc.allowPickingVideo = NO;
                
                // 设置是否可以选择原图
                imagePickerVc.allowPickingOriginalPhoto = NO;
                
                // 最多三十张
                imagePickerVc.maxImagesCount = _addPhotoMaxCount;
                
                // 单选模式,maxImagesCount为1时才生效
                imagePickerVc.circleCropRadius = 1;
                
                // 你可以通过block或者代理，来得到用户选择的照片.
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    
                    if ([weakSelf judgementPhotoIsOverLimitWithPhotoArray:photos])
                    {
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
    
    ShowEntrustFilingPhotoVC *showEntrustFilingPhotoVC = [[ShowEntrustFilingPhotoVC alloc] initWithNibName:@"ShowEntrustFilingPhotoVC" bundle:nil];
    // 删除照片后刷新TableView
    showEntrustFilingPhotoVC.deletePhotoBlock = ^(){
        _isChangePageValue = YES;
        [_mainTableView reloadData];
    };
    
    // 先取出照片类型
    NSString *photoType = [_photoTypeArray objectAtIndex:0];
    
    showEntrustFilingPhotoVC.photoImageArray = [_addPhotoDic objectForKey:photoType];
    showEntrustFilingPhotoVC.serverPhotoArray = [_serverPhotoDic objectForKey:photoType];
    showEntrustFilingPhotoVC.uploadPhotoDetailArray = _uploadPhotoArray;
    showEntrustFilingPhotoVC.isOnlyViewPermission = !_isEditPermission;
    showEntrustFilingPhotoVC.photoType = photoType;
    
    [self.navigationController pushViewController:showEntrustFilingPhotoVC animated:YES];
}


#pragma mark - 选择时间结果回调
- (void)selectedResultWithSender:(NSObject *)sender andDate:(NSDate *)dateTime
{
    _dateTime = dateTime;
}

// 确定
- (void)clickDone
{
    _isChangePageValue = YES;
    _hasPickView = NO;
    AddEntrustFilingSignCell *cell = [_mainTableView cellForRowAtIndexPath:_selectIndexPath];
    cell.rightTitleLabel.text = [NSDate stringWithSimpleDate:_dateTime];
    _entrustFilingEditDetailEntity.signDate = [NSDate stringWithSimpleDate:_dateTime];

    [_mainTableView reloadData];
}

// 取消
- (void)clickCancle
{
    _hasPickView = NO;
    _isChangePageValue = YES;
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    [self hiddenLoadingView];
    if ([modelClass isEqual:[EntrustFilingEditEntity class]])
    {
        EntrustFilingEditEntity *entrustFilingEditEntity = [DataConvert convertDic:data toEntity:modelClass];
        _entrustFilingEditDetailEntity = entrustFilingEditEntity.value;
        [self setPhotoInfoAndPermission];
        return;
    }
    
    if ([modelClass isEqual:[AgencyBaseEntity class]])
    {
        [self hiddenLoadingView];
        AgencyBaseEntity *agencyBaseEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (agencyBaseEntity.flag)
        {
            NSString *showMessage = @"编辑委托成功";
            
            if (_isDeleteEntrustFiling)
            {
                showMessage = @"删除委托成功";
            }
            [CustomAlertMessage showAlertMessage:showMessage
                                 andButtomHeight:(APP_SCREEN_HEIGHT- 64)/2];
            
            self.refreshPropertyDetailDataBlock ? self.refreshPropertyDetailDataBlock() : nil;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        showMsg(@"提交失败，请重试!");
        _isSubmission = NO;
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    _isSubmission = NO;
}

- (void)dealloc
{
    AudioPlayView *audioPlayView = [_mainTableView viewWithTag:AudioPlayerTag];
    [audioPlayView.audioPlayer stop];
}

@end
