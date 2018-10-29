//
//  ChooseLocationViewController.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/25.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "ChooseLocationViewController.h"
#import "ChooseLocationCell.h"
#import "TCLocationHelper.h" 
#import <BaiduMapAPI_Map/BMKMapComponent.h>         //base相关所有头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>   //检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>     //引入计算工具所有的头文件


@interface ChooseLocationViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet BMKMapView *_mapView;
    
    __weak IBOutlet UITableView *_mainTableView;
    
    __weak IBOutlet NSLayoutConstraint *_mapViewHeight;
    
    CLLocationCoordinate2D _userLocationCoor; //用户位置
    TCLocationHelper *_locationHelper;
    
    BMKPointAnnotation *_userLocationAnnotation;//定位信息
    BMKAnnotationView *_newAnnotation;//当前位置视图
    BMKGeoCodeSearch *_geoCodeSearch;//搜索周边用户信息
    
    NSMutableArray *_locationDataArr;
}
@end

@implementation ChooseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //地图定位
    _mapView.delegate = self;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    _mapView.delegate= nil;
    _geoCodeSearch.delegate = nil;
}

-(void)initView
{
    [self setNavTitle:@"选择位置"
       leftButtonItem:[self customBarItemButton:@"取消"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(back)]
      rightButtonItem:nil];
    self.navigationItem.leftBarButtonItem.width = 0;
    
    _mapViewHeight.constant = [CommonMethod calculateLengthFromMultipleScreenSizeWithLength:280.0];
    
}

-(void)initData
{
    _locationDataArr = [[NSMutableArray alloc] init];
    _locationHelper =  [TCLocationHelper shareInstance];
    
    WS(weakSelf);
    //获取当前位置信息
    [_locationHelper getLocationSuccess:^(TCLocationHelper *mananger) {
        //定位成功
        [weakSelf setUserCoor:mananger];
    } locationFailBlock:^(NSError *error) {
        //获取定位信息失败
        showMsg(@"无法获取当前位置");
    }];
    
}

#pragma mark 用户位置
- (void)setUserCoor:(TCLocationHelper*)mananger
{
    //获取定位信息成功
    _userLocationCoor = mananger.location.coordinate;
    
    [_mapView setCenterCoordinate:_userLocationCoor];
    [_mapView setZoomLevel:17];
    //添加用户位置坐标
    _userLocationAnnotation = [[BMKPointAnnotation alloc]init];
    
    _userLocationAnnotation.coordinate =_userLocationCoor;
    _userLocationAnnotation.title =[NSString stringWithFormat:@"%@%@%@",mananger.cityName,mananger.subLocality, mananger.addressDetail];
    
    [_mapView addAnnotation:_userLocationAnnotation];
    
    //搜索用户周边位置信息
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
    BMKReverseGeoCodeOption * reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeOption.reverseGeoPoint = mananger.location.coordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
}

#pragma mark 点击当前位置
- (IBAction)currentLocationClick:(id)sender {
    _mapView.centerCoordinate = _userLocationCoor;
    [_mapView setZoomLevel:17.0];
}

#pragma mark 放大地图
- (IBAction)mapZoomInClick:(id)sender {
    [_mapView zoomIn];
}

#pragma mark 缩小地图
- (IBAction)mapZoomOutClick:(id)sender {
    [_mapView zoomOut];
}

#pragma mark BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    _newAnnotation = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                   reuseIdentifier:@"renameMark"];
    
    _newAnnotation.image = [[UIImage alloc]init];
    
    //定位自己的图标
    _newAnnotation.image = [UIImage imageNamed:@"sign_btn_sing"];
    _newAnnotation.frame = CGRectMake(0, 0, 12, 20);
    _newAnnotation.canShowCallout = YES;
    return _newAnnotation;
}

#pragma mark BMKGeoCodeSearchDelegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //获取用户周边位置信息
    if (error == BMK_SEARCH_NO_ERROR) {
        [_locationDataArr removeAllObjects];
        
        //第一条显示当前位置
         LocationEntity *locationEntity = [[LocationEntity alloc] init];
        locationEntity.addressName = @"当前位置";
        locationEntity.addressDetail = _locationHelper.addressDetail;
        locationEntity.location = _userLocationCoor;
        [_locationDataArr addObject:locationEntity];
        
        for (BMKPoiInfo  *poiInfo in result.poiList) {
            //添加周边用户信息
            LocationEntity *locationEntity = [[LocationEntity alloc] init];
            locationEntity.addressName = poiInfo.name;
            locationEntity.addressDetail = poiInfo.address;
            locationEntity.location = poiInfo.pt;
            [_locationDataArr addObject:locationEntity];
        }
        
    
        [_mainTableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _locationDataArr.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseLocationCell * cell = [ChooseLocationCell cellWithTableView:tableView];
    //设置cell上的数据
    if (_locationDataArr.count > 0) {
        [cell setCellValueWithDataArray:_locationDataArr andIndexPath:indexPath
                      andChooseLocation:self.chooseLocationEntity];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationEntity *locationEntity = _locationDataArr[indexPath.row];
    if (_block) {
        _block(locationEntity);
    }
    [self back];

}

-(void)dealloc
{
    _mapView.delegate= nil;
    _geoCodeSearch.delegate = nil;

    
}
@end
