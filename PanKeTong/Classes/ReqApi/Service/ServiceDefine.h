//
//  ServiceDefine.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#ifndef PanKeTong_ServiceDefine_h
#define PanKeTong_ServiceDefine_h

#define REQUEST_TIME_OUT    10               //网络请求超时时限

//API地址（Help）
#define     APIHelpHost                     @"http://10.5.10.143:8004/help"

//测试网络连接地址
#define     SERVER_IP                       @"mobileapi.centanet.com"

//114.113.64.186:9092
//10.5.238.83:29263
//10.7.19.11:8086
//http://10.7.19.28:8080

/*
 *  api测试 http://114.80.110.197/hkapi/api/
 */
//#define     HouseKeeperUrl                  @"http://zygj.centanet.com/api/api/" //移动A+url
//#define     AgencyUrl                       @"http://10.5.238.82:29263/api/" //agency url
////#define     AgencyUrl                       @"http://114.113.64.186:9095/api/" //天津agency url
////#define     AgencyUrl                       @"http://10.106.1.102:8081/api/" //深圳agency url
//#define     VirtualCallUrl                  @"http://tjstatic.centaline.com.cn/static/Appconfig.html" //虚拟号url
//#define     DascomUrl                       @"http://220.194.66.24:50580/SSMN_ZY_Server/" //拨打/获取/修改 虚拟商url
//#define     AgencyPicUtl                    @"http://10.7.19.23:8080/image/upload/" //agency图片url
//#define     TARGETESTATES                   @"http://tj.centaline.com.cn:8080/" //带看路线URL
//#define     ImageServerUrl                  @"http://10.7.19.23:8080/image/upload/"    //房源实堪图片服务
//#define     SharePropDetailUrl              @"http://10.5.10.143:8004/home/share"
//#define     AgentPhotoUrl                   @"http://10.7.19.23:8080/image/upload/" //agency图片url
//#define     MessageUrl(string)              [NSString stringWithFormat:@"http://114.80.110.197/hkapi/mobile/info/info?infoid=%@",string] //官方消息详情



//http://tj.centaline.com.cn:8080/api/
//http://10.5.238.83:29263/api/
//http://10.7.19.11:8086/help

//图片外网：tjstatic.centaline.com.cn
//文件外网：


//http://10.4.18.33:8010/hkindex/
/*
 *  api正式
 */
//#define     HouseKeeperUrl                  @"http://zygj.centanet.com/api/api/" //移动A+url
//#define     AgencyUrl                       @"http://tj.centaline.com.cn:8080/api/" //agency url
//#define     VirtualCallUrl                  @"http://tjstatic.centaline.com.cn/static/Appconfig.html" //虚拟号url
//#define     DascomUrl                       @"http://220.194.66.24:50580/SSMN_ZY_Server/" //拨打/获取/修改 虚拟商url
//#define     AgencyPicUtl                    @"http://tjstatic.centaline.com.cn/image/upload/" //agency图片url
//#define     TARGETESTATES                   @"http://tj.centaline.com.cn:8080/" //带看路线URL
//#define     AgentPhotoUrl                   @"http://pic.centanet.com/tianjin/pic/agent/"   //天津经纪人头像图片服务地址
//#define     ImageServerUrl                  @"http://tjstatic.centaline.com.cn/image/upload/"    //房源实堪图片服务
//#define     SharePropDetailUrl              @"http://tj.centaline.com.cn:8080/home/share"   //agency房源分享
//#define     MessageUrl(string)              [NSString stringWithFormat:@"http://zygj.centanet.com/api/mobile/info/info?infoid=%@",string]//官方消息详情


/**
 *  app下载地址、帮助中心
 */
#define     APPDownloadUrl                  @"http://zygj.centanet.com/ydaj/" // APP下载地址
//#define     APPDownloadSZUrl                  @"http://zygj.centanet.com/download/sz.html" //APP深圳下载地址

//#define     HouseKeeperHelpWebPageUrl       @"http://zygj.centanet.com/api/mobile/help" //移动A+帮助中心url


/**
 * 聊天：客户默认头像url
 */
#define     DefaultChatUserIcon             @"http://passport.centanet.com/page/common/UserPicHandler.ashx"

/**
 *融云serve地址
 */
#define RONG_CLOUD_URL              @"https://api.cn.rong.io/user/"


#pragma mark - Http Request Tag（本地http请求的tag值）

//#define     Tag_HouseKeeperLogin                    8001        //登录（移动A+系统）
#define     Tag_ReleaseEstManage                    8009        //放盘管理
//#define     Tag_RefreshEstList                      8010        //刷新放盘管理房源列表
#define     Tag_RecommendPropList                   8013        //推荐房源（猜你喜欢）
//#define     Tag_EstReleaseDetail                    8014        //放盘管理详情
//#define     Tag_EstDetailImg                        8016        //放盘管理详情大图


//#define     Tag_EstReleaseSetOnLine                 8033        //上架
//#define     Tag_EstReleaseSetOffLine                8034        //下架
#define     Tag_UploadPropImgToServer               8036        //上传房源实堪图到图片服务器
#define     Tag_UploadPropImgToAgency               8037        //上传房源实勘图到A+系统




#define     RONG_CLOUD_TAG_USERTOKEN                8135        //融云serve获取token
#define     RONG_CLOUD_TAG_CHECKONLINE              8136        //检查用户是否在线
#define     Tag_AppVersion                          8138        //检查AppVersion
#define     Tag_UserAndPublicAccount                8143        //归属人或公客池智能提示




//#define     Tag_SSOModify                           8155        //sso密码同步
#define     Tag_PropLeftFollow                      8156        //左导跟进记录
//
//#pragma mark - 虚拟号 Request tag
//
#define     Tag_DascomGetRealPhone                  9001        //获取手机号码
//


#pragma mark - Http Request Method（接口定义的方法名称）
#define     RONG_CLOUD_REQUEST_USERTOKEN            @"getToken.json"        //聊天用户的token
#define     RONG_CLOUD_CHECK_ONLINE                 @"checkOnline.json"     //聊天用户是否在线
//#define     Request_PropLeftFollow                  @"WebApiProperty/property-left-follow"  //左导跟进记录




#endif
