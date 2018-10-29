//
//  PropAroundMapViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/10.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropAroundMapViewController.h"
#import "PropMapPoiTypeCollectionCell.h"

@interface PropAroundMapViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,BMKMapViewDelegate,BMKPoiSearchDelegate>
{
    
    BMKMapView *_mapView;               //地图view实例
    BMKPoiSearch *_poiSearch;           //poi检索实例
    BMKAnnotationView *_newAnnotation;  //标注点实例
    
    __weak IBOutlet UICollectionView *_selectPoiTypeCollectionView;
    
    NSMutableArray *_poiTypeItemUnSelectImgArray;   //选择poi搜索类型的图片数组（未选择状态）
    NSMutableArray *_poiTypeItemSelectImgArray;     //选择poi搜索类型的图片数组（选择状态）
    NSMutableArray *_poiTypeItemTitleArray;         //选择poi搜索类型的title数组
    
    NSMutableArray *_poiSearchResultList;           //poi检索结果
    
    NSString *_selectPoiBtnTag;                     //当前选择的poi类型
    
    UIButton *_clickDismissPoiTypeBtn;              //用来遮挡地图view，防止在切换poiType的时候滑动地图
    __weak IBOutlet NSLayoutConstraint *_poiTypeViewButtomHeight;
    
    __weak IBOutlet UIButton *_hiddenPoiTypeViewBtn;
    
    BOOL _showPropAnnotation;   //显示房源标注（用来区分poi检索结果标注）
    
}

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIButton *mapAppearArrow;

@end

@implementation PropAroundMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"地图周边"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    //首次进入页面显示房源标注点
    _showPropAnnotation = YES;
    
    [self initData];
    [self initView];
    
}

-(void)initData {

    _poiTypeItemUnSelectImgArray = @[@"mapPoiSchoolType_unSelect_icon.png",
                                     @"mapPoiTrafficType_unSelect_icon",
                                     
                                     @"mapPoiFoodType_unSelect_icon",
                                     
                                     @"mapPoiBankType_unSelect_icon",
                                     
                                     @"mapPoiMarketType_unSelect_icon",
                                     
                                     @"mapPoiHospitalType_unSelect_icon"
                                     ].mutableCopy;
  
    _poiTypeItemSelectImgArray = @[@"mapPoiSchoolType_select_icon.png",
                                   @"mapPoiTrafficType_select_icon",
                                   
                                   @"mapPoiFoodType_select_icon",
                                   
                                   @"mapPoiBankType_select_icon",
                                   @"mapPoiMarketType_select_icon",
                                   @"mapPoiHospitalType_select_icon"
                                   ].mutableCopy;
    
    
        _poiTypeItemTitleArray = @[@"学校",
                                   @"交通",
                                   @"餐饮",
                                   
                                   @"银行",
                                   @"超市",
                                   @"医院"
                                   ].mutableCopy;
    
    _poiSearchResultList = [[NSMutableArray alloc]init];
    
}

-(void)initView
{
    
    /**
     创建mapView
     */
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,
                                                           0,
                                                           APP_SCREEN_WIDTH,
                                                           APP_SCREEN_HEIGHT-64)];
    _mapView.delegate = self;
    _mapView.maxZoomLevel = 20;
    
    [self.view insertSubview:_mapView
                     atIndex:0];
    
    // 蒙版
    _clickDismissPoiTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clickDismissPoiTypeBtn setBackgroundColor:[UIColor clearColor]];
    [_clickDismissPoiTypeBtn setFrame:CGRectMake(0,
                                                 0,
                                                 APP_SCREEN_WIDTH,
                                                 APP_SCREEN_HEIGHT-185-APP_NAV_HEIGHT)];
    _clickDismissPoiTypeBtn.hidden = YES;
    _clickDismissPoiTypeBtn.selected = YES;
    [_clickDismissPoiTypeBtn addTarget:self
                                action:@selector(clickHiddenPoiTypeView:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clickDismissPoiTypeBtn];
    
    
    //创建底部选择poi类型的collectionView
    UINib *collectionCellNib = [UINib nibWithNibName:@"PropMapPoiTypeCollectionCell"
                                              bundle:nil];
    [_selectPoiTypeCollectionView registerNib:collectionCellNib
                   forCellWithReuseIdentifier:@"propMapTypeCell"];
   
    
    /**
     创建检索服务
     */
    _poiSearch = [[BMKPoiSearch alloc]init];
    _poiSearch.delegate = self;
    
    //添加房源point
    [self addPropAnnotation];
    
    
    
    _poiTypeViewButtomHeight.constant = 0;
//    [self changePoiTypeViewHiddenStatus:YES];
    
    
    
    //实现模糊效果
//
//    UIImage *image = [self newImageWithSize:CGSizeMake(375, 200) color:[UIColor whiteColor]];
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        CIContext *context = [CIContext contextWithOptions:nil];
//        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
//        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//        [filter setValue:ciImage forKey:kCIInputImageKey];
//        //设置模糊程度
//        [filter setValue:@120.0f forKey: @"inputRadius"];
//        CIImage *result = [filter valueForKey:kCIOutputImageKey];
//
//
//        CGImageRef outImage = [context createCGImage: result fromRect:ciImage.extent];
//        UIImage * blurImage = [UIImage imageWithCGImage:outImage];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//
//            [self.baseView insertSubview:[[UIImageView alloc] initWithImage: blurImage] atIndex:0];
//        });
//    });
    
   
    
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(12, 32, APP_SCREEN_WIDTH-24, 166);
    [effectView setLayerCornerRadius:5];
    [self.baseView insertSubview:effectView atIndex:0];

    UIView *effView = [[UIView alloc] initWithFrame:effectView.frame];
    [effView setLayerCornerRadius:5];
    effView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.baseView insertSubview:effView atIndex:1];
    
   
}




- (UIImage *)newImageWithSize:(CGSize) size color:(UIColor *)color
{
    // UIGrphics
    // 设置一个frame
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // 开启图形绘制
    UIGraphicsBeginImageContext(size);
    
    // 获取当前图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置填充颜色
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    // 填充
    CGContextFillRect(context, rect);
    
    // 从当前图形上下文中获取一张透明图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形绘制
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma AddPropAnnotationMapMethod
- (void)addPropAnnotation {
    
    BMKPointAnnotation *pointAnnoation;
    pointAnnoation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = _latitude;
    coor.longitude = _longitude;
    pointAnnoation.coordinate = coor;
    pointAnnoation.title = [NSString stringWithFormat:@"%@",_propTitleString];
    
    [_mapView addAnnotation:pointAnnoation];
    
    if (coor.latitude != 0){
        [_mapView setCenterCoordinate:coor animated:YES];
        [_mapView setZoomLevel:15];
    }else{
        
        [CustomAlertMessage showAlertMessage:@"无法定位该房源\n\n"
                             andButtomHeight:APP_SCREEN_HEIGHT/2];
        
    }
    
}

#pragma mark -  点击隐藏底部view的btn
- (IBAction)clickHiddenPoiTypeView:(UIButton*)clickBtn {
    
    if (clickBtn.tag) {
         [self changePoiTypeViewHiddenStatus:YES];
    }else{
        
         [self changePoiTypeViewHiddenStatus:NO];
    }
   
    
    
}



-(void)changePoiTypeViewHiddenStatus:(BOOL)show {
    
   
    
    [UIView animateWithDuration:0.25 animations:^{
      
        if (show) {
            
            
            _poiTypeViewButtomHeight.constant = 0;
        }else{
            
            
            _poiTypeViewButtomHeight.constant = -210;
        }
        
       [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        
        if (!show)  _mapAppearArrow.hidden = show;
    }];
    if (show)  _mapAppearArrow.hidden = show;
    _clickDismissPoiTypeBtn.hidden = !show;
   
  
   
}

#pragma mark - ***********UICollectionView**********

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"propMapTypeCell";
        
    PropMapPoiTypeCollectionCell *collectionCell = (PropMapPoiTypeCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                                                                             forIndexPath:indexPath];
    
    NSString *selectPoiImg = [_poiTypeItemSelectImgArray objectAtIndex:indexPath.row];
    NSString *unSelectPoiImg = [_poiTypeItemUnSelectImgArray objectAtIndex:indexPath.row];
    NSString *poiTitleStr = [_poiTypeItemTitleArray objectAtIndex:indexPath.row];
    
    /**
     *  第一次进入页面时_selectPoiBtnTag为nil
     */
    if (_selectPoiBtnTag) {
        
        NSInteger currentSelectIndex = _selectPoiBtnTag.integerValue;
        
        if (currentSelectIndex == indexPath.row) {
            
            collectionCell.mapPoiTitleLabel.textColor = [UIColor whiteColor];
            [collectionCell.mapPoiImgBtn setImage:[UIImage imageNamed:selectPoiImg]
                                         forState:UIControlStateNormal];
        }else{
            
            collectionCell.mapPoiTitleLabel.textColor = LITTLE_GRAY_COLOR;
            
            [collectionCell.mapPoiImgBtn setImage:[UIImage imageNamed:unSelectPoiImg]
                                         forState:UIControlStateNormal];
        }
        
    }else{
        
        collectionCell.mapPoiTitleLabel.textColor = LITTLE_GRAY_COLOR;
        [collectionCell.mapPoiImgBtn setImage:[UIImage imageNamed:unSelectPoiImg]
                                     forState:UIControlStateNormal];
        
    }
    
    collectionCell.mapPoiTitleLabel.text = poiTitleStr;
    
    collectionCell.mapPoiBigBtn.tag = indexPath.row;
    [collectionCell.mapPoiBigBtn addTarget:self
                                    action:@selector(changePoiSearchItemWithTag:)
                          forControlEvents:UIControlEventTouchUpInside];
    
    
    return collectionCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return CGSizeMake((APP_SCREEN_WIDTH-36-48)/3, 45);
    
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 12;
}


/**
 *  切换poiItem的状态：选中、未选中
 */
-(void)changePoiSearchItemWithTag:(UIButton *)clickBtn {
    
    NSInteger clickItemIndex = clickBtn.tag;
    
    /**
     poi 检索条件
     */
    BMKNearbySearchOption *nearbySearchOption = [[BMKNearbySearchOption alloc]init];
    nearbySearchOption.pageIndex = 0;
    nearbySearchOption.pageCapacity = 10;
    nearbySearchOption.radius = 5000;
    nearbySearchOption.location = CLLocationCoordinate2DMake(_latitude,
                                                             _longitude);
    
    
    nearbySearchOption.keyword = _poiTypeItemTitleArray[clickItemIndex];
        
    BOOL flag = [_poiSearch poiSearchNearBy:nearbySearchOption];
    
    if (!flag) {
        
        [CustomAlertMessage showAlertMessage:@"查找失败,请重试\n\n"
                             andButtomHeight:APP_SCREEN_HEIGHT/2];
    }
    
    _selectPoiBtnTag = [NSString stringWithFormat:@"%@",@(clickItemIndex)];
    
    [_selectPoiTypeCollectionView reloadData];
    
}

#pragma mark - PoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher
                result:(BMKPoiResult*)poiResult
             errorCode:(BMKSearchErrorCode)errorCode
{
    
    if (_poiSearchResultList.count != 0) {
        
        [_mapView removeAnnotations:_poiSearchResultList];
    }
    
    [_poiSearchResultList removeAllObjects];
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        for (int i = 0; i < poiResult.poiInfoList.count; i++) {
            
            BMKPoiInfo* poi = [poiResult.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* annotationItem = [[BMKPointAnnotation alloc]init];
            annotationItem.coordinate = poi.pt;
            
            annotationItem.title = [NSString stringWithFormat:@"%@",poi.name];
            
            [_poiSearchResultList addObject:annotationItem];
        }
        
        [_mapView addAnnotations:_poiSearchResultList];
        [_mapView showAnnotations:_poiSearchResultList
                         animated:YES];
        
    }else{
        
        [CustomAlertMessage showAlertMessage:@"查找失败,请重试\n\n"
                             andButtomHeight:APP_SCREEN_HEIGHT/2];
    }
    
}

#pragma mark - BMKMapViewDelegate
/**
 *添加标注必须实现此方法来返回标注的view
 *
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    //得到pointAnnotation，取得title来显示在自定义的label上
    BMKPointAnnotation *currentPoint = (BMKPointAnnotation *)annotation;
    
    
    NSString *AnnotationViewID = @"renameMark";
    
    _newAnnotation = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (!_newAnnotation) {
        
        _newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:AnnotationViewID];
    }
    
    if (_showPropAnnotation) {
        
        _newAnnotation.enabled = YES;
        _newAnnotation.canShowCallout = YES;
        
        _newAnnotation.annotation = annotation;
        
        // 设置颜色（红色）
        ((BMKPinAnnotationView*)_newAnnotation).pinColor = BMKPinAnnotationColorRed;
        // 从天上掉下效果
        ((BMKPinAnnotationView*)_newAnnotation).animatesDrop = YES;
        // 设置可拖拽
        ((BMKPinAnnotationView*)_newAnnotation).draggable = NO;
        
        _showPropAnnotation = NO;
        
    }else{
        
        /**
         *  poi搜索结果name
         */
        NSString *pointNameStr = [NSString stringWithFormat:@"%@",currentPoint.title];
        CGFloat pointNameWidth = [pointNameStr getStringWidth:[UIFont fontWithName:FontName
                                                                              size:11.0]
                                                       Height:12.0
                                                         size:11.0];
        
        /**
         *  计算房源距离poi搜索结果的某一点的距离
         */
        CLLocationCoordinate2D starCoor = CLLocationCoordinate2DMake(_latitude,
                                                                     _longitude);
        BMKMapPoint pointStart = BMKMapPointForCoordinate(starCoor);
        
        CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake(currentPoint.coordinate.latitude,
                                                                    currentPoint.coordinate.longitude);
        BMKMapPoint pointEnd = BMKMapPointForCoordinate(endCoor);
        
        CLLocationDistance pointDistance = BMKMetersBetweenMapPoints(pointStart, pointEnd);
        
        NSString *pointDisString ;
        
        if (pointDistance > 20000) {
            
            pointDisString = [NSString stringWithFormat:@">20km"];
            
        }else if(pointDistance < 1000){
            
            pointDisString = [NSString stringWithFormat:@"距离：%.0f米",pointDistance];
        } else{
            pointDisString = [NSString stringWithFormat:@"距离：%.1f千米",pointDistance/1000];
        }
        
        CGFloat pointDisStrWidth = [pointDisString getStringWidth:[UIFont fontWithName:FontName
                                                                                  size:11.0]
                                                           Height:12.0
                                                             size:11.0];
        
        /**
         标注点最后计算的宽度，不超过150
         */
        CGFloat pointItemWidth;
        
        if (pointDisStrWidth > pointNameWidth) {
            
            pointItemWidth = pointDisStrWidth + 16;
            
        }else{
            
            pointItemWidth = pointNameWidth + 16;
        }
        
        if (pointItemWidth > 200) {
            
            pointItemWidth = 200;
        }
        
        
        //自定义标注view
        UIView *cusAnnotationView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            pointItemWidth,
                                                                            50)];
        [cusAnnotationView setBackgroundColor:[UIColor clearColor]];
        
        //标注背景imageView
        UIImageView *topAnnotationImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                                         0,
                                                                                         pointItemWidth,
                                                                                         50)];
        [topAnnotationImgView setImage:[UIImage imageNamed:@"mapAnnotationTopImg_bg.png"]];
        
        UIImageView *buttomAnnotationImgView = [[UIImageView alloc]initWithFrame:CGRectMake(pointItemWidth/2-5,
                                                                                            36,
                                                                                            9,
                                                                                            14)];
        [buttomAnnotationImgView setImage:[UIImage imageNamed:@"mapAnnotationButtomImg_bg.png"]];
        
        [cusAnnotationView addSubview:topAnnotationImgView];
        [cusAnnotationView addSubview:buttomAnnotationImgView];
        
        
        //标注名称label
        UILabel *pointNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8,
                                                                           6,
                                                                           pointItemWidth-16,
                                                                           12)];
        pointNameLabel.backgroundColor =[UIColor clearColor];
        pointNameLabel.numberOfLines = 1;
        pointNameLabel.text = currentPoint.title;
        pointNameLabel.textAlignment = NSTextAlignmentCenter;
        pointNameLabel.font = [UIFont fontWithName:FontName
                                              size:11.0];
        pointNameLabel.textColor = LITTLE_BLACK_COLOR;
        pointNameLabel.userInteractionEnabled = NO;
        
        
        //标注和房源的距离label
        UILabel *pointDistanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(8,
                                                                               20,
                                                                               pointItemWidth-16,
                                                                               12)];
        pointDistanceLabel.backgroundColor =[UIColor clearColor];
        pointDistanceLabel.numberOfLines = 1;
        pointDistanceLabel.text = currentPoint.title;
        pointDistanceLabel.textAlignment = NSTextAlignmentCenter;
        pointDistanceLabel.font = [UIFont fontWithName:FontName
                                                  size:11.0];
        pointDistanceLabel.textColor = LITTLE_GRAY_COLOR;
        pointDistanceLabel.userInteractionEnabled = NO;
        
        
        
        pointDistanceLabel.text = pointDisString;
        
        
        [cusAnnotationView addSubview:pointNameLabel];
        [cusAnnotationView addSubview:pointDistanceLabel];
        
        
        [_newAnnotation addSubview:cusAnnotationView];
        
        _newAnnotation.frame = CGRectMake(0,
                                          0,
                                          50,
                                          12);
        _newAnnotation.enabled = YES;
        _newAnnotation.canShowCallout = NO;
        
    }
    
    return _newAnnotation;
}


@end
