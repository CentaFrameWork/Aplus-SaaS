//
//  DealIploadImageController.m
//  PanKeTong
//
//  Created by Admin on 2018/3/26.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "DealIploadImageController.h"
#import "DealUploadImageCell.h"
#import "TZImagePickerController.h"
#import <Photos/Photos.h>
#import "UIImageView+WebCache.h"
#import "UIProgressPie.h"
#import "UIImage+Cap.h"

#define Collection_Marge 12
#define Item_Width (APP_SCREEN_WIDTH - 3*Collection_Marge)/2


#define MAX_IMAGE 5
//#define IMageURL @"http://10.1.30.115:9000"

@interface DealIploadImageController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,DealUploadImageDelegate>
@property (nonatomic,strong)NSMutableArray *DataSource;
@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,assign)NSInteger max_Count;
@property (nonatomic,assign)NSInteger currentImage;
@property (nonatomic,strong)NSMutableArray* imageAddressArray;
@property (nonatomic,strong)UIButton* rightBtn;
@property (nonatomic,assign)CGFloat currentCount;
@property (nonatomic,strong)UIProgressPie *progressPie;;

@end

@implementation DealIploadImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self.view addSubview:self.myCollectionView];
    [self getNetworkImage];

    
    
}

- (void)getNetworkImage {
    
    
//
//    NSString *ServerUrl = [[BaseApiDomainUtil getApiDomain] getImageServerUrl];
//
//    NSURL *url = [NSURL URLWithString:ServerUrl];
//
//    NSRange range = [ServerUrl rangeOfString:url.relativePath];
//
//   ServerUrl = [ServerUrl substringWithRange:NSMakeRange(0, range.location)];
    
    [AFUtils GET:AipPropertyGetDealImage parameters:@{@"TransactionKeyId":self.model.KeyId,@"FileType":self.number} controller:self successfulDict:^(NSDictionary *successfuldict) {
        
        for (NSDictionary *dict in successfuldict[@"Attachments"]) {
            
//            NSString *string = [ServerUrl stringByAppendingString:dict[@"AttachmentPath"]];
            
            NSURL *url = [NSURL URLWithString:dict[@"AttachmentPath"]];
            
            [self.DataSource addObject:url];
        }
        
        [self.myCollectionView reloadData];
        
    } failureDict:^(NSDictionary *failuredict) {
        
    } failureError:^(NSError *failureerror) {
        
    }];
}

#pragma mark - ******* collectionView *******

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.DataSource.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DealUploadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
   
    cell.delegate = self;
    cell.deleteBtn.tag = indexPath.row;
    if (indexPath.row == self.DataSource.count) {
        
        cell.imageView.image = [UIImage imageNamed:@"uploadAdd"];
        cell.deleteBtn.hidden = YES;
        
    } else {
    
        if ([self.DataSource[indexPath.row] isKindOfClass:[NSURL class]]) {
            
            cell.deleteBtn.hidden = YES;
            [cell.imageView sd_setImageWithURL:self.DataSource[indexPath.row] placeholderImage:[UIImage imageNamed:@"uploadPlac"] options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                cell.deleteBtn.hidden = NO;
            }];
            
        }else {
            
             cell.imageView.image = self.DataSource[indexPath.row];
             cell.deleteBtn.hidden = NO;
        }
        
       
        
    }
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == self.DataSource.count) {
        
        if (MAX_IMAGE - self.DataSource.count >0) {
           
            NSArray * listArr = @[@"相机",@"手机相册"];
            
            [NewUtils popoverSelectorTitle:@"图片上传" listArray:listArr theOption:^(NSInteger optionValue) {
                
                
                if (optionValue) {
                    
                    //相册授权
                    
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        
                        if (status == PHAuthorizationStatusAuthorized) {
                            
                            [self presentImagePickerVC];
                            
                            
                        }else{
                            
                            
                            
                             [self presentViewController: [self presentAlterVCWithString:@"照片"] animated:YES completion:nil];
                        }
                    }];
                    
                    
                }else{
                    
                    //相机授权
                    
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        
                        if (granted) {
                            
                            [self presentCameraVC];
                            
                        }else{
                             [self presentViewController: [self presentAlterVCWithString:@"相机"] animated:YES completion:nil];
                            
                        }
                    }];
                    
                    
                }
                
            }];
            
        }else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多只能上传5张图片" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:0 handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
    }else{
        
        
        
    }
    
    
}
#pragma mark -  *****删除图片****** 
- (void)didClickBtn:(UIButton *)btn {
    _rightBtn.enabled = YES;
    [self.DataSource removeObjectAtIndex:btn.tag];
   
//    if (!self.DataSource.count)  _rightBtn.enabled = NO;
    
    [self.myCollectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:btn.tag inSection:0];
        [self.myCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.myCollectionView reloadData];
    }];
    
}



#pragma mark -  *******获取相册******
- (void)presentImagePickerVC{
    
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAX_IMAGE - self.DataSource.count delegate:self];
        
//        imagePickerVc.navigationBar.barTintColor = [UIColor redColor];
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowTakePicture = NO;
        //    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
    
        [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        });
    
        
    
  
    
   
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
     _rightBtn.enabled = YES;
    
        for (int i = 0; i<photos.count; i++) {
            UIImage *image = photos[i];
            
            [self.DataSource addObject:[image getSmallImage]];
            
        }
         [self.myCollectionView reloadData];
}
#pragma mark -  *******获取相机*******
- (void)presentCameraVC {
    
    // 初始化相机对象
    UIImagePickerController* vc = [[UIImagePickerController alloc] init];
    vc.delegate = self;
    vc.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:vc animated:YES completion:nil];
        
    });
    
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    _rightBtn.enabled = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.DataSource addObject:[image getSmallImage]];
    [self.myCollectionView reloadData];
}


- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(Item_Width, 130);
        
        layout.minimumLineSpacing = Collection_Marge;
        layout.minimumInteritemSpacing = Collection_Marge;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 12, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT- APP_NAV_HEIGHT) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.dataSource = self;
        _myCollectionView.delegate = self;
        _myCollectionView.contentInset = UIEdgeInsetsMake(0, Collection_Marge, 0, Collection_Marge);
        [_myCollectionView registerClass:[DealUploadImageCell class] forCellWithReuseIdentifier:@"collection"];
    }
    
    return _myCollectionView;
}

- (void)setNav {
    
    _rightBtn = [self customBarItemButton:@"提交"
                          backgroundImage:nil
                               foreground:nil
                                      sel:@selector(rightClick)];
    [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    [self setNavTitle:self.title
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:_rightBtn];
    
    _rightBtn.enabled = NO;
   
}
#pragma mark -  点击提交
- (void)rightClick {
    
    [self setUIState];
    
    int current = (int)(self.DataSource.count - _currentImage-1);
    
    if (current >= 0) {
        
        __block DealUploadImageCell *cell = (DealUploadImageCell*)[self.myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentImage inSection:0]];
        
        NSData *data = UIImageJPEGRepresentation(cell.imageView.image, 1.0);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        
        
        AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString *ServerUrl = [[BaseApiDomainUtil getApiDomain] getImageServerUrl]; // URl地址

        [manager POST:ServerUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            
        [formData appendPartWithFileData:data name:@"image01" fileName:fileName mimeType:@"image/jpeg"];
            
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            self.currentCount = self.currentImage + uploadProgress.fractionCompleted;
            [self.progressPie changeProgressRunOnMainThread:self.currentCount * (100 / self.DataSource.count)];
            
            
            NSLog(@"*图片进度**********%f",uploadProgress.fractionCompleted);
            
//            CGFloat progress = uploadProgress.completedUnitCount * 1.0/ uploadProgress.totalUnitCount;
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                cell.progress = progress;
//            });
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *imageUrl = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSLog(@"我的地址是:%@",imageUrl);
            
            NSDictionary *dict = @{@"AttachmentName":@(self.currentImage),@"AttachmentPath":imageUrl};
            [self.imageAddressArray addObject:dict];
            self.currentImage++;
            
            [self rightClick];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            self.currentImage = 0;
            self.imageAddressArray = nil;
            
            
        }];
        
        
    }else{
        
        [AFUtils POST:AipPropertyUploadDealImage  parameters:@{@"TransactionKeyId":self.model.KeyId,@"FileType":self.number,@"Attachments":self.imageAddressArray} controller:self successfulDict:^(NSDictionary *successfuldict) {
            NSLog(@"%@",successfuldict);
            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传成功了" preferredStyle:UIAlertControllerStyleAlert];
//
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
//
//            }]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:JM_refreshDeal object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
//            [self presentViewController:alert animated:YES completion:nil];
            
        } failureDict:^(NSDictionary *failuredict) {
            
            NSLog(@"%@",failuredict);
            
             [self setDefaulPara];
            
        } failureError:^(NSError *failureerror) {
            
            NSLog(@"%@",failureerror);
            
            [self setDefaulPara];

        }];
   
    }
   
}

- (void)setDefaulPara {
    
    _currentImage = 0;
    self.imageAddressArray = nil;
    [self.progressPie removeFromSuperview];
    
    
}

- (void)setUIState {
    
    
    if(!_currentImage){
        _rightBtn.enabled = NO;
        NSArray *arr = [self.myCollectionView visibleCells];
        
        for (DealUploadImageCell * cell in arr) {
            cell.deleteBtn.hidden = YES;
            cell.userInteractionEnabled = NO;
            // NSData *data = UIImageJPEGRepresentation(cell.imageView.image, 1.0);
        }
        
         [self.view addSubview:self.progressPie];
    
    
    }
    
    
    
}

#pragma mark -  数据源
- (NSMutableArray *)imageAddressArray {
    
    if (!_imageAddressArray) {
        _imageAddressArray = [NSMutableArray array];
    }
    
    return _imageAddressArray;
}
- (NSMutableArray *)DataSource {
    
    if (!_DataSource) {
        _DataSource = [NSMutableArray array];
    }
    
    return _DataSource;
}

- (UIProgressPie *)progressPie {
    
    if (!_progressPie) {
        
//         _progressPie = [[UIProgressPie alloc]initWithFrame:CGRectMake((APP_SCREEN_WIDTH - 120) / 2, (APP_SCREEN_HEIGHT -180)*0.5, 100, 100)];
        
            _progressPie = [[UIProgressPie alloc]initWithFrame:CGRectMake((APP_SCREEN_WIDTH - 120) / 2, (APP_SCREEN_HEIGHT - 64 - 120) / 2 - 20, 120, 120)];
//        _progressPie.backgroundColor = [UIColor clearColor];
//        _progressPie.strokeWidth = 15;
//        _progressPie.progressColor = RGBColor(220, 220, 220);
//        _progressPie.progressTextColor = RGBColor(220, 220, 220);
////        _progressPie.circleColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//        _progressPie.bgColor =  [[UIColor blackColor] colorWithAlphaComponent:0.3];

//        _progressPie.style = UIProgressPieStyleStroke;
//        _progressPie.frame = CGRectMake((APP_SCREEN_WIDTH - 120) / 2, (APP_SCREEN_HEIGHT -180)*0.5, 120, 120);
//        [_progressPie changeProgress:0];
        
    }
    return _progressPie;
}


@end
