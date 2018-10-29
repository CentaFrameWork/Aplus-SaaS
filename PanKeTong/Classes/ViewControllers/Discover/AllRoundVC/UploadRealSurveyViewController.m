//
//  UploadRealSurveyViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/14.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "UploadRealSurveyViewController.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "UploadRealSurveyCollectionCell.h"
#import "PhotoAlbumListViewController.h"
#import "PhotoAssetsItemEntity.h"
#import "ShowPhotoAssetsViewController.h"

#import "UploadPropImgApi.h"
#import "ShowPhotoAssetsViewController.h"

#import "PropetyRealSettingApi.h"
#import "PropetyRealSettingEntity.h"

#import "TZImageManager.h"
#import "UIView+Layout.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "UIProgressPie.h"//进度条饼状图
#import "UIImage+Cap.h"
#import "JMCropViewController.h"

#define InvalidCameraAlertTag               2000
#define QuitUploadImgAlertTag               3000
#define ORIGINAL_MAX_WIDTH                  640.0f

#define Collection_Marge 12
#define Item_Width (APP_SCREEN_WIDTH - 3*Collection_Marge)/2

#define IOS_VERSION_8_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))

@interface UploadRealSurveyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,PhotoAlbumDetailDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate,
ShowPhotoAssetsDelegate,ProgressDelegate> {
    
    
    UIProgressPie *_progressPie;//饼状进度条
    SelectItemDtoEntity *_decorationSituation;
    UploadPropImgApi *_uploadImgApi;
    PropetyRealSettingApi *_getRealSettingApi;
    
    UIWindow * _mainWindow;
    UILabel *_decorationTypeLabel;
    UIButton *_decorationTypeButton;
    UIView *_uploadProgressView;
    __weak IBOutlet UICollectionView *_mainCollectionView;
    
    UIBarButtonItem  *_leftItem;
    

    NSMutableArray *_photoAssetSelectArray; //选择过的图片数组
    NSMutableArray *_photoAssetUrlArray;    //选择过的图片路径数组
    
    NSInteger _uploadPhotoCnt;          //上传到图片服务器的次数，此属性和选择的图片总数相同时代表上传完成
    NSInteger _currentUploadIndex;      //当前正在上传的index，图片列表是按顺序上传，所以要用到这个
    
    NSInteger _minImageWidth;              // 上传图片最小宽度
    NSInteger _minImageHeight;             // 上传图片最小高度

    NSMutableArray *_photosDicArray;       //即将要上传的图片配置信息数组
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;

    BOOL _isNowUploadImg;               //是否正在上传图片，防止重复点击提交按钮
    BOOL _isSelectOriginalPhoto;
    float _currentSumProgress;
}
@property (nonatomic,strong)UIView *footerView;
@property (nonatomic,strong)NSMutableArray *mutArray;
@property (nonatomic,strong)UIImagePickerController *imagePickerController;

@end

@implementation UploadRealSurveyViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initView];
    [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_mainCollectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
 
    [super viewWillDisappear:animated];
    [_uploadProgressView removeFromSuperview];
}

#pragma mark - init

- (void)initView {
    [self setNavTitle:@"上传实勘"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(uploadMethod)]];
    
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.contentInset = UIEdgeInsetsMake(0, Collection_Marge, 0, Collection_Marge);
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"UploadRealSurveyCollectionCell" bundle:nil]
          forCellWithReuseIdentifier:@"uploadRealSurveyCollectionCell"];
   
    // 注册footer
//    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReuse"];
//
    [self.view addSubview:self.footerView];
  
    // 初始化相机对象
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;

}

- (void)initData {
    _maxUpdateCount = 9;
    _minImageWidth = 0;
    _minImageHeight = 0;
    
    // 创建相机胶卷数据库对象
    _photoAssetsLibrary = [[ALAssetsLibrary alloc]init];

    _photoAssetSelectArray = [[NSMutableArray alloc]init];
    _photoAssetUrlArray = [[NSMutableArray alloc]init];
    _photosDicArray = [[NSMutableArray alloc]init];
    
    _uploadImgApi = [UploadPropImgApi new];
    _getRealSettingApi = [PropetyRealSettingApi new];
    [_manager sendRequest:_getRealSettingApi];
    
  
    SysParamItemEntity *dataEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_DECORATION_SITUATION];
       
        NSString *defaultSelection = @"豪装";
        for (SelectItemDtoEntity *entity in dataEntity.itemList)
        {
            if ([entity.itemText isEqualToString:defaultSelection])
            {
                _decorationSituation = entity;
            }
        }
    
    
    _currentUploadIndex = 0;
    _currentSumProgress = 0;
}
#pragma mark - *************UICollectionView***********



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (_photoAssetSelectArray.count == _maxUpdateCount) {
       return _maxUpdateCount;
    }else{
        
     return _photoAssetSelectArray.count + 1;
    }
    
    

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UploadRealSurveyCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"uploadRealSurveyCollectionCell" forIndexPath:indexPath];
        
    if (indexPath.item == _photoAssetSelectArray.count) {
        //添加实堪
        [collectionCell.realSurveyImageView setImage:[UIImage imageNamed:@"uploadAdd"]];
        collectionCell.realSurveyTypeLabel.hidden = YES;
        collectionCell.realSurveyTypeView.hidden = YES;
    }else{
        //实堪图片
        PhotoAssetsItemEntity *photoAssetItem = [_photoAssetSelectArray objectAtIndex:indexPath.row];
        [collectionCell.realSurveyImageView setImage:photoAssetItem.photoThumbnailImage];
        
        if (photoAssetItem.photoAssetTypeTextStr.length){
            
            collectionCell.realSurveyTypeLabel.text = photoAssetItem.photoAssetTypeTextStr;
        
        }else{
            
            collectionCell.realSurveyTypeLabel.text = @"选择分类";
        }
        
        collectionCell.realSurveyTypeLabel.hidden = NO;
        collectionCell.realSurveyTypeView.hidden = NO;
        
    }
    return collectionCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.item == _photoAssetSelectArray.count) {
        
        if (_photoAssetSelectArray.count >= _maxUpdateCount) {
            
            NSString *showMsgStr =[NSString stringWithFormat:@"最多选择%ld张",_maxUpdateCount];
            
            
            [CustomAlertMessage showAlertMessage:showMsgStr andButtomHeight:BOTTOM_SAFE_HEIGHT+60];

        }else{
            
        
            NSArray * listArr = @[@"相机",@"手机相册"];
            
            [NewUtils popoverSelectorTitle:@"图片上传" listArray:listArr theOption:^(NSInteger optionValue) {
                
                
                if (optionValue) {
                    
                    //相册授权
                    
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        
                        if (status == PHAuthorizationStatusAuthorized) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                self.imagePickerController.sourceType = 0;
                                
                                [self presentViewController:self.imagePickerController
                                                   animated:YES
                                                 completion:^{
                                                     
                                                 }];
                            });
                            
                            
                           
                            
                        }else{
                            
                            
                            
                        [self presentViewController: [self presentAlterVCWithString:@"照片"] animated:YES completion:nil];
                            
                        }
                    }];
                    
                    
                }else{
                    
                    //相机授权
                    
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        
                        if (granted) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                self.imagePickerController.sourceType = 1;
                                
                                [self presentViewController:self.imagePickerController
                                                   animated:YES
                                                 completion:^{
                                                     
                                                 }];
                            });
                            
                           
                            
                        }else{
                              [self presentViewController: [self presentAlterVCWithString:@"相机"] animated:YES completion:nil];
                            
                        }
                    }];
                 
                    
                }
                
            }];
    
        }
       
    }else{
        
        ShowPhotoAssetsViewController *showPhotoAssetsVC = [[ShowPhotoAssetsViewController alloc]initWithNibName:@"ShowPhotoAssetsViewController"
                                                                                                          bundle:nil];
        showPhotoAssetsVC.delegate = self;
        showPhotoAssetsVC.photoAssetsSource = _photoAssetSelectArray;
        showPhotoAssetsVC.photoAssetsUrlArr = _photoAssetUrlArray;
        showPhotoAssetsVC.selectImageIndex = indexPath.item;
        showPhotoAssetsVC.isLockRoom = _isLockRoom;
        
        [self.navigationController pushViewController:showPhotoAssetsVC
                                             animated:YES];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(Item_Width, 130);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 12;
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//
//    UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footReuse" forIndexPath:indexPath];
//    [footView addSubview:self.footerView];
//
//    return footView;
//
//
//}

- (UIView *)footerView {
    
    if (!_footerView) {
        
            _footerView = [UIView new];
            _footerView.backgroundColor = [UIColor whiteColor];
            _footerView.frame = CGRectMake(0, APP_SCREENSafeAreaHeight-APP_NAV_HEIGHT-62, APP_SCREEN_WIDTH, 62);
        
        
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, APP_SCREEN_WIDTH, 1)];
        
        view.backgroundColor  = UICOLOR_RGB_Alpha(0xECECEC,1.0);
        [_footerView addSubview:view];
        
            _decorationTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 12, 70, 50)];
            _decorationTypeLabel.font = [UIFont systemFontOfSize:14];
            _decorationTypeLabel.text = @"  装修情况";
            _decorationTypeLabel.textColor = YCTextColorBlack;
            [_footerView addSubview:_decorationTypeLabel];
        
            _decorationTypeButton = [[UIButton alloc]initWithFrame:CGRectMake(-10, 12, APP_SCREEN_WIDTH+12, 50)];
            [_decorationTypeButton setTitle:@"豪装" forState:UIControlStateNormal];
            _decorationTypeButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [_decorationTypeButton setTitleColor:YCTextColorBlack forState:UIControlStateNormal];
            _decorationTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
           _decorationTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 37);
        
        
            [_decorationTypeButton addTarget:self action:@selector(choiceDecorationType) forControlEvents:UIControlEventTouchUpInside];
            
        
    
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH-24, 30, 8, 15)];
        imageV.image = [UIImage imageNamed:@"icon_jm_right_arrow"];
        [_footerView addSubview:imageV];
        
        [_footerView addSubview:_decorationTypeButton];
        
    }
    
    return _footerView;
}
#pragma mark - *******UIImagePickerController******



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage* editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
        
        JMCropViewController *vc = [JMCropViewController loadControllerWithImage:editedImage];
        
        vc.btnCancel = ^(){
            
            [picker dismissViewControllerAnimated:YES completion:nil];
            
        };
        vc.btnSure = ^(UIImage *editedImage){
            
            
            PhotoAssetsItemEntity *takePhotoEntity = [[PhotoAssetsItemEntity alloc]init];
            takePhotoEntity.photoThumbnailImage = editedImage;
            takePhotoEntity.photoAspectRatioThumbnailImage = editedImage;
            
            
            NSString *docImgName = [NSString stringWithFormat:@"image%@.png",@(_photoAssetUrlArray.count+1)];
            [CommonMethod saveImageToDoc:editedImage
                                withName:docImgName
                           andIsPanorama:takePhotoEntity.isPanorama];
            
            
            NSString *fullImgNameUrl = [CommonMethod getImageFromDocWithName:docImgName];
            
            [_photoAssetUrlArray addObject:fullImgNameUrl];
            [_photoAssetSelectArray addObject:takePhotoEntity];
            
            
            
            ShowPhotoAssetsViewController *showPhotoAssetsVC = [[ShowPhotoAssetsViewController alloc]initWithNibName:@"ShowPhotoAssetsViewController"
                                                                                                              bundle:nil];
            showPhotoAssetsVC.delegate = self;
            showPhotoAssetsVC.photoAssetsSource = _photoAssetSelectArray;
            showPhotoAssetsVC.photoAssetsUrlArr = _photoAssetUrlArray;
            showPhotoAssetsVC.selectImageIndex = _photoAssetUrlArray.count-1;
            showPhotoAssetsVC.isLockRoom = _isLockRoom;
            
            [picker pushViewController:showPhotoAssetsVC
                              animated:YES];
            
            
            
        };
        
        
        
        [picker pushViewController:vc  animated:YES];
        
}

#pragma mark -  选择装修类型
- (void)choiceDecorationType {
    
  SysParamItemEntity* dataEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_DECORATION_SITUATION];
    

    _mutArray = [NSMutableArray array];
    
    for (SelectItemDtoEntity *entity in dataEntity.itemList) {
        
        [_mutArray addObject:entity.itemText?:@""];
    }
    
    
    [NewUtils popoverSelectorTitle:@"图片上传" listArray:_mutArray.copy theOption:^(NSInteger optionValue) {
        

         [_decorationTypeButton setTitle:_mutArray[optionValue] forState:UIControlStateNormal];
        
    }];
    
    
    
 
}


#pragma mark - 点击提交按钮
- (void)uploadMethod
{
    if (_isNowUploadImg)
    {
        return;
    }
    
    if (_photoAssetSelectArray.count == 0)
    {
        [CustomAlertMessage showAlertMessage:@"请选择图片\n\n" andButtomHeight:BOTTOM_SAFE_HEIGHT+60];

        return;
    }
    
    // 验证图片类型
    NSString *errorMsg = [self checkPhotosType:_photoAssetSelectArray];
    if (errorMsg.length) {
        
        
        [CustomAlertMessage showAlertMessage:errorMsg andButtomHeight:BOTTOM_SAFE_HEIGHT+60];

        
        return;
    }
    
    
    
    _isNowUploadImg = YES;
    _currentUploadIndex = 0;
    
    // 自定义alertview
    _uploadProgressView = [[UIView alloc] init];
    _uploadProgressView.backgroundColor = [UIColor clearColor];
    _uploadProgressView.frame = self.view.bounds;
    
    //开启进度条
    _progressPie = [[UIProgressPie alloc]initWithFrame:CGRectMake((APP_SCREEN_WIDTH - 120) / 2, (APP_SCREEN_HEIGHT - 64 - 120) / 2 - 20, 120, 120)];
    
    _progressPie.delegate = self;
    _progressPie.center = _uploadProgressView.center;
    
    [_uploadProgressView addSubview:_progressPie];
    [self.view addSubview:_uploadProgressView];
    
    //先把图片信息放到“photosArray”中，等待上传
    [self createPhotoDicWithPhotoAssets];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self uploadImgToImgServer];
    });
}

- (NSString *)checkPhotosType:(NSArray *)photos {
   
    
    for (int i = 0; i < photos.count; i++)
    {
        PhotoAssetsItemEntity *photoAssetItem = [photos objectAtIndex:i];
        
        if ([NSString isNilOrEmpty:photoAssetItem.photoAssetTypeTitleStr])
        {
            return @"图片需要选择类型后才能上传!";
        }
    }
        
   
    
    return @"";
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case QuitUploadImgAlertTag:
        {
            if (buttonIndex == 1)
            {
                [self deleteLocalPhotos];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - CustomMethod

/// 删除本地的照片
- (void)deleteLocalPhotos
{
    // 返回之前删除本地保存的图片文件
    __weak typeof (NSArray *)weakPhotoUrlArr = _photoAssetUrlArray;
    
    //  后台执行：
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (int i = 0; i<weakPhotoUrlArr.count; i++)
        {
            NSString *deletePhotoUrl = [weakPhotoUrlArr objectAtIndex:i];
            [CommonMethod deleteImageFromDocWithName:deletePhotoUrl];
        }
    });

    [super back];
}

#pragma mark -   上传图片到图片服务器

- (void)uploadImgToImgServer {
    
    PhotoAssetsItemEntity *photoAssetItem ;
    NSString *uploadImgName;
    
    if (_photoAssetUrlArray.count > 0) {
        uploadImgName = [_photoAssetUrlArray objectAtIndex:_currentUploadIndex];
        photoAssetItem = [_photoAssetSelectArray objectAtIndex:_currentUploadIndex];
    }else{
        uploadImgName = nil;
        return;
    }

    [self uploadFileToImgServer:uploadImgName andImage:photoAssetItem.photoAspectRatioThumbnailImage andIsPanorama:NO];
    
}

//- (void)imgIsPanorama:(NSString *)uploadImgName andPhotoAssetsItemEntity:(PhotoAssetsItemEntity *)entity
//{
//    UIImage *image = entity.photoAspectRatioThumbnailImage;
//
//    // 若为全景图  获取原图
//    if (entity.isPanorama && entity.realALAssetValue)
//    {
//        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//        // 同步获得图片, 只会返回1张图片
//        options.synchronous = YES;
//        // 用于控制请求的图片质量
//        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//        // 控制图像的剪裁
//        options.resizeMode = PHImageRequestOptionsResizeModeExact;
//
//        PHAsset *asset = entity.realALAssetValue;
//        // 是否要原图
//        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
//        // 从asset中获得图片
//        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            [self uploadFileToImgServer:uploadImgName andImage:result andIsPanorama:YES];
//        }];
//    }
//    else
//    {
//        [self uploadFileToImgServer:uploadImgName andImage:image andIsPanorama:entity.isPanorama];
//    }
//}

/// 上传图片到agency
- (void)uploadImgToAgency
{
    _uploadImgApi.photo = _photosDicArray;
    _uploadImgApi.keyId = _propKeyId;
    _uploadImgApi.decorationSituationKeyId = _decorationSituation.itemValue;
    [_manager sendRequest:_uploadImgApi];
}

/// 创建图片上传photo字典，用来上传到agency
- (void)createPhotoDicWithPhotoAssets
{
    [_photosDicArray removeAllObjects];
    
    for (int i = 0; i<_photoAssetSelectArray.count; i++)
    {
        NSMutableDictionary *photoItemDic = [[NSMutableDictionary alloc]init];
        
        PhotoAssetsItemEntity *photoAssetItem = [_photoAssetSelectArray objectAtIndex:i];
        [photoItemDic setValue:@"false" forKey:@"HasDefault"];
        [photoItemDic setValue:photoAssetItem.photoAssetTypeValueStr forKey:@"PhotoTypeKeyId"];
        
        
        [_photosDicArray addObject:photoItemDic];
    }
}


#pragma mark - ShowPhotoAssetsDelegate

- (void)photoAssetsSource:(NSMutableArray *)array andUrl:(NSMutableArray *)urlArr
{
    _photoAssetSelectArray = [array mutableCopy];
    _photoAssetUrlArray = [urlArr mutableCopy];
    [_mainCollectionView reloadData];
}

#pragma mark - <PhotoAssetDetailDelegate>

/// 选择相册图片后代理回调方法
- (void)selectPhotoAssetSuccess:(NSMutableArray *)photoAssetItems
{
    /**
     *  把所有图片url保存到document中，上传图片的时候使用
     *
     *  docImgName的索引设置为add图片数组的总数是防止已经有照片的情况,又从1开始循环
     */
    for (int i = 0; i<photoAssetItems.count; i++)
    {
        // 获取图片后写入到document，png格式
        NSString *docImgName = [NSString stringWithFormat:@"image%@.png",@(_photoAssetSelectArray.count+i+1)];
        //获取保存过的图片的完整路径
        NSString *fullImgNameUrl = [CommonMethod getImageFromDocWithName:docImgName];
        
        [_photoAssetUrlArray addObject:fullImgNameUrl];
    }
    
    [_photoAssetSelectArray addObjectsFromArray:photoAssetItems];
    [_mainCollectionView reloadData];
}

- (void)back {
    UIAlertView *uploadImgAlert = [[UIAlertView alloc]initWithTitle:@"是否放弃本次上传?"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
    uploadImgAlert.tag = QuitUploadImgAlertTag;
    [uploadImgAlert show];
}
#pragma mark - <ProgressDelegate>

- (void)finished
{
    if (_isNowUploadImg == NO)
    {
        [self back];
    }
}

#pragma mark - 上传图片

- (void)uploadFileToImgServer:(NSString *)uploadImgName andImage:(UIImage *)image andIsPanorama:(BOOL)isPanorama {
    //网络请求管理器
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //JSON
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *getImageServerUrl = [[BaseApiDomainUtil getApiDomain] getImageServerUrl];

   
    
    [sessionManager POST:getImageServerUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
         NSData *data = UIImageJPEGRepresentation(image, 1.0);
         NSLog(@"我的长度:------>%ld",data.length);
        
         NSData *imageData = UIImageJPEGRepresentation([image getSmallImage], 1.0);
        
        
        //上传文件
//        NSData *imageData;
//        float maxCompressRatio = 0.7;

        // 若是全景图压缩质量减低
//        if (isPanorama) maxCompressRatio = 0.3;
//
//        imageData =  [CommonMethod compressImage:image
//                                   compressRatio:1
//                                maxCompressRatio:maxCompressRatio
//                                   andIsPanorama:isPanorama];

      
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = CompleteNoFormat;
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        NSLog(@"我的长度:------>%ld",imageData.length);
        
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/png"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        _currentSumProgress = (float)_currentUploadIndex + uploadProgress.fractionCompleted;
        int progress = _currentSumProgress * (100 / _photosDicArray.count);
        [_progressPie changeProgressRunOnMainThread:progress];
        
        
        NSLog(@"*图片进度**********%f",uploadProgress.fractionCompleted);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *imageUrl = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //图片配置信息字典
        NSMutableDictionary *imgResultDic = [_photosDicArray objectAtIndex:_currentUploadIndex];
        [imgResultDic setObject:imageUrl forKey:@"PhotoPath"];
        [_photosDicArray replaceObjectAtIndex:_currentUploadIndex withObject:imgResultDic];
        
        //上传下一张图片
        _currentUploadIndex++;
        if (_currentUploadIndex == _photosDicArray.count) {
            //如果上传的次数和图片数量相等就直接上传到agency上
            [self uploadImgToAgency];
        
        }else{
            
            //如果上传的次数小于图片的数量，就继续上传
            [self uploadImgToImgServer];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hiddenLoadingView];
        _isNowUploadImg = NO;
        [_uploadProgressView removeFromSuperview];
        showMsg(@"网络连接已中断");
        NSLog(@"error ===== %@",error);

     }];
}

#pragma mark - ResponseDelegate

- (void)dealData:(id)data andClass:(id)modelClass {
    
    
    if ([modelClass isEqual:[PropetyRealSettingEntity class]]) {
       
        PropetyRealSettingEntity *realSettingEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        _minUpdateCount = [realSettingEntity.minUpdate integerValue];
        _maxUpdateCount = realSettingEntity.maxUpdate.integerValue;
       
        if (realSettingEntity.imageMinHeight)
        {
            _minImageHeight = realSettingEntity.imageMinHeight.integerValue;
        }
        if (realSettingEntity.imageMinWidth)
        {
            _minImageWidth = realSettingEntity.imageMinWidth.integerValue;
        }
    
    }else if ([modelClass isEqual:[AgencyBaseEntity class]]){
      
        //上传到agency成功
        [self hiddenLoadingView];
        
        _currentUploadIndex = 0;
        AgencyBaseEntity *agencyEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (agencyEntity.flag)
        {
            [self deleteLocalPhotos];
            _isNowUploadImg = NO;
            
            self.uploadRealSurveySuccessBlock ? self.uploadRealSurveySuccessBlock() : nil;
            
        }
        else
        {
            [CustomAlertMessage showAlertMessage:@"上传失败\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2-64];
            
            [[[UIApplication sharedApplication].keyWindow viewWithTag:300] removeFromSuperview];
            _isNowUploadImg = NO;
        }
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    _isNowUploadImg = NO;
}


@end
