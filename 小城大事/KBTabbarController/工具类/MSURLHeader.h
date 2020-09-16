//
//  MSURLHeader.h
//  MSProduct
//
//  Created by lihengda on 2018/1/24.
//  Copyright © 2018年 lihengda. All rights reserved.
//

#ifndef MSURLHeader_h
#define MSURLHeader_h
#pragma pragma ------- url -------



//#define RBDom  @"http://www.xcoin.cc"
//#define RBDom  @"http://192.168.1.161:80"
#define RBDom  @"http://47.92.235.179:8890"
//#define RBDom  @"http://easy.qyxly.top"
#define PrjName  @"api/"
//#define PrjName  @"meishu/api/freedo/"

#define RBRequestTopOriginal  [NSString stringWithFormat:@"%@/%@", RBDom,PrjName]

//注册
#define Register [NSString stringWithFormat:@"%@User/register", RBRequestTopOriginal]

//短信验证码
#define GetFasong [NSString stringWithFormat:@"%@Sms/send", RBRequestTopOriginal]

//重置密码
#define UserResetpwd [NSString stringWithFormat:@"%@User/resetpwd", RBRequestTopOriginal]

//登录
#define UserLogin [NSString stringWithFormat:@"%@User/login", RBRequestTopOriginal]



//验证码登录
#define UserMobilelogin [NSString stringWithFormat:@"%@User/mobilelogin", RBRequestTopOriginal]

//微信登录
#define UserThird [NSString stringWithFormat:@"%@User/third", RBRequestTopOriginal]

//微信登录绑定手机
#define UserBindingmobile [NSString stringWithFormat:@"%@User/bindingmobile", RBRequestTopOriginal]

//分类列表
#define CategoryLists [NSString stringWithFormat:@"%@Category/lists", RBRequestTopOriginal]

//推荐列表
#define RecommendRecommend_lists [NSString stringWithFormat:@"%@Recommend/recommend_lists", RBRequestTopOriginal]

//商品列表
#define GoodsLists [NSString stringWithFormat:@"%@Goods/lists", RBRequestTopOriginal]

//通告列表
#define NoticeLists [NSString stringWithFormat:@"%@Notice/lists", RBRequestTopOriginal]

//新闻列表
#define NewslLists [NSString stringWithFormat:@"%@News/lists", RBRequestTopOriginal]

//招聘列表
#define RecruitstaffLists [NSString stringWithFormat:@"%@Recruitstaff/lists", RBRequestTopOriginal]

//家政列表
#define RecruithousekeepLists [NSString stringWithFormat:@"%@Recruithousekeep/lists", RBRequestTopOriginal]

//租房列表
#define LeaseLists [NSString stringWithFormat:@"%@Lease/lists", RBRequestTopOriginal]

//交友列表
#define AppointmentLists [NSString stringWithFormat:@"%@Appointment/lists", RBRequestTopOriginal]

//其他列表
#define ElsesLists [NSString stringWithFormat:@"%@Elses/lists", RBRequestTopOriginal]

//招聘详情
#define RecruitstaffDetails [NSString stringWithFormat:@"%@Recruitstaff/details", RBRequestTopOriginal]

//家政详情
#define RecruithousekeepDetails [NSString stringWithFormat:@"%@Recruithousekeep/details", RBRequestTopOriginal]

//租房详情
#define LeaseDetails [NSString stringWithFormat:@"%@Lease/details", RBRequestTopOriginal]

//买卖详情
#define GoodsDetails [NSString stringWithFormat:@"%@Goods/details", RBRequestTopOriginal]

//交友详情
#define AppointmentDetails [NSString stringWithFormat:@"%@Appointment/details", RBRequestTopOriginal]

//婚恋详情
#define LiveDetails [NSString stringWithFormat:@"%@Live/details", RBRequestTopOriginal]

//其他详情
#define ElsesDetails [NSString stringWithFormat:@"%@Elses/details", RBRequestTopOriginal]

//婚恋列表
#define Livelists [NSString stringWithFormat:@"%@Live/lists", RBRequestTopOriginal]


//收藏列表
#define CollectLists [NSString stringWithFormat:@"%@Collect/lists", RBRequestTopOriginal]

//删除收藏
#define CollectDelete [NSString stringWithFormat:@"%@Collect/delete", RBRequestTopOriginal]


//创建订单
#define OrderCreate [NSString stringWithFormat:@"%@Order/create", RBRequestTopOriginal]

//收藏与取消收藏
#define CollectSite [NSString stringWithFormat:@"%@Collect/site", RBRequestTopOriginal]

//查看是否收藏
#define CollectExist [NSString stringWithFormat:@"%@Collect/exist", RBRequestTopOriginal]


//发布招聘
#define RecruitstaffCreate [NSString stringWithFormat:@"%@Recruitstaff/create", RBRequestTopOriginal]
//发布家政
#define RecruithousekeepCreate [NSString stringWithFormat:@"%@Recruithousekeep/create", RBRequestTopOriginal]
//发布租房
#define LeaseCreate [NSString stringWithFormat:@"%@Lease/create", RBRequestTopOriginal]
//发布买卖
#define GoodsCreate [NSString stringWithFormat:@"%@Goods/create", RBRequestTopOriginal]
//发布其他
#define ElsesCreate [NSString stringWithFormat:@"%@Elses/create", RBRequestTopOriginal]
//发布交友
#define AppointmentCreate [NSString stringWithFormat:@"%@Appointment/create", RBRequestTopOriginal]
//发布婚恋
#define LiveCreate [NSString stringWithFormat:@"%@Live/create", RBRequestTopOriginal]

//编辑招聘
#define RecruitstaffEdit [NSString stringWithFormat:@"%@Recruitstaff/edit", RBRequestTopOriginal]
//编辑家政
#define RecruithousekeepEdit [NSString stringWithFormat:@"%@Recruithousekeep/edit", RBRequestTopOriginal]
//编辑其他
#define ElsesEdit [NSString stringWithFormat:@"%@Elses/edit", RBRequestTopOriginal]
//编辑交友
#define AppointmentEdit [NSString stringWithFormat:@"%@Appointment/edit", RBRequestTopOriginal]
//编辑婚恋
#define LiveEdit [NSString stringWithFormat:@"%@Live/edit", RBRequestTopOriginal]
//编辑买卖
#define GoodsEdit [NSString stringWithFormat:@"%@Goods/edit", RBRequestTopOriginal]
//编辑租房
#define LeaseEdit [NSString stringWithFormat:@"%@Lease/edit", RBRequestTopOriginal]

//搜索列表
#define SearchLists [NSString stringWithFormat:@"%@Search/lists", RBRequestTopOriginal]


//查询类别发布次数与价格
#define UserIndex [NSString stringWithFormat:@"%@User/index", RBRequestTopOriginal]

//图片上传
#define AjaxUpload [NSString stringWithFormat:@"%@Ajax/upload", RBRequestTopOriginal]

//修改个人信息
#define UserProfile [NSString stringWithFormat:@"%@User/profile", RBRequestTopOriginal]

//置顶临时接口
#define OrderDemoWxPayOrder [NSString stringWithFormat:@"%@Order/demoWxPayOrder", RBRequestTopOriginal]

//消息
#define MessageLists [NSString stringWithFormat:@"%@Message/lists", RBRequestTopOriginal]

//修改手机号
#define UserChangemobile [NSString stringWithFormat:@"%@User/changemobile", RBRequestTopOriginal]




//招聘删除
#define StaffDelete [NSString stringWithFormat:@"%@Recruitstaff/delete", RBRequestTopOriginal]

//家政删除
#define HousekeepDelete [NSString stringWithFormat:@"%@Recruithousekeep/delete", RBRequestTopOriginal]

//租房删除
#define LeaseDelete [NSString stringWithFormat:@"%@Lease/delete", RBRequestTopOriginal]

//买卖删除
#define GoodsDelete [NSString stringWithFormat:@"%@Goods/delete", RBRequestTopOriginal]

//交友删除
#define AppointmentDelete [NSString stringWithFormat:@"%@Appointment/delete", RBRequestTopOriginal]

//其他删除
#define ElseDelete [NSString stringWithFormat:@"%@Elses/delete", RBRequestTopOriginal]

//婚恋删除
#define LiveDelete [NSString stringWithFormat:@"%@Live/delete", RBRequestTopOriginal]

//热门搜索列表
#define IndexHot_search [NSString stringWithFormat:@"%@Index/hot_search", RBRequestTopOriginal]

//注销
#define UserLogout [NSString stringWithFormat:@"%@User/logout", RBRequestTopOriginal]

//推荐消息详情
#define RecommendRecommend_details [NSString stringWithFormat:@"%@Recommend/recommend_details", RBRequestTopOriginal]

//支付宝支付
#define OrderAliPayOrder [NSString stringWithFormat:@"%@Order/AliPayOrder", RBRequestTopOriginal]

//微信商品支付
#define OrderWxPayOrder [NSString stringWithFormat:@"%@Order/WxPayOrder", RBRequestTopOriginal]

#endif /* MSURLHeader_h */
