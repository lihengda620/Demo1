//
//  PayViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/3.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "PayViewController.h"
#import "PaySuccessViewController.h"
#import "PayFailureViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface PayViewController ()
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIView * payView;
@property (nonatomic, strong) UIImageView * zhifubaoView;
@property (nonatomic, strong) UIImageView * weixinView;
@property (nonatomic, strong) UIImageView * weixinSelectedImageView;
@property (nonatomic, strong) UIImageView * zhifubaoSelectedImageView;
@property (nonatomic, strong) UILabel * weixinLabel;
@property (nonatomic, strong) UILabel * zhifubaoLabel;
@property (nonatomic, strong) UIButton * weixinBtn;
@property (nonatomic, strong) UIButton * zhifubaoBtn;
@property (nonatomic, strong) UIButton * sureBtn;

@end

@implementation PayViewController
{
    UIButton * currentBtn;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(245, 245, 245, 1.0);
    [self initNavigationView];
    [self initView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ALiPayFailure) name:@"ALiPayFailure" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ALiPaySuccess) name:@"ALiPaySuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ALiPaySuccess) name:@"WechatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ALiPayFailure) name:@"WechatPayFailure" object:nil];
}

- (void)initNavigationView{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"支    付" Color:[UIColor blackColor] Direction:NSTextAlignmentCenter];
    [self.navigationView addSubview: self.titleLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, CGRectGetMidY(self.titleLabel.frame) - FitSizeH(22), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
}

- (void)initView{
    self.payView = [FlanceTools viewCreateWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame) + FitSizeH(4), SCREEN_WIDTH, FitSizeH(137)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.payView];
    
    UIView * lineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(68), FitSizeW(345), FitSizeH(1)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
    [self.payView addSubview:lineView];

    if ([self.isALiPayOK isEqualToString:@"0"]&&[self.isWechartOK isEqualToString:@"1"]) {
        //未安装支付宝  安装了微信
        self.payView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH, FitSizeH(68));
        
        self.weixinView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(24), FitSizeH(18), FitSizeW(33), FitSizeH(33)) ImageName:@"weixin"];
        [self.payView addSubview:self.weixinView];
        
        self.weixinLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.weixinView.frame) + FitSizeW(10), 0, FitSizeW(150), FitSizeH(68)) Font:15 IsBold:NO Text:@"微信支付" Color:RGBA(51, 51, 51, 1.0) Direction:NSTextAlignmentLeft];
        [self.payView addSubview:self.weixinLabel];
        
        self.weixinBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitSizeH(68)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"weixuanz" Target:self Action:@selector(click_Btn:)];
        [self.weixinBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [self.payView addSubview:self.weixinBtn];
        [self.weixinBtn setImageEdgeInsets:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2 + FitSizeH(100), 0, 0)];
        self.weixinBtn.selected = YES;
        currentBtn = self.weixinBtn;
    }else if ([self.isWechartOK isEqualToString:@"0"]&&[self.isALiPayOK isEqualToString:@"1"]){
        //未安装微信  安装了支付宝
        self.payView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH, FitSizeH(68));
        
        self.zhifubaoView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(24), FitSizeH(18), FitSizeW(33), FitSizeH(33)) ImageName:@"zhifubao"];
        [self.payView addSubview:self.zhifubaoView];
        
        self.zhifubaoLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.zhifubaoView.frame) + FitSizeW(10), 0, FitSizeW(150), FitSizeH(68)) Font:15 IsBold:NO Text:@"支付宝支付" Color:RGBA(51, 51, 51, 1.0) Direction:NSTextAlignmentLeft];
        [self.payView addSubview:self.zhifubaoLabel];
        
        self.zhifubaoBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitSizeH(68)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"weixuanz" Target:self Action:@selector(click_Btn:)];
        [self.zhifubaoBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [self.payView addSubview:self.zhifubaoBtn];
        [self.zhifubaoBtn setImageEdgeInsets:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2 + FitSizeH(100), 0, 0)];
        self.zhifubaoBtn.selected = YES;
        currentBtn = self.zhifubaoBtn;
    }else{
        self.zhifubaoView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(24), FitSizeH(18), FitSizeW(33), FitSizeH(33)) ImageName:@"zhifubao"];
        [self.payView addSubview:self.zhifubaoView];
        
        self.zhifubaoLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.zhifubaoView.frame) + FitSizeW(10), 0, FitSizeW(150), FitSizeH(68)) Font:15 IsBold:NO Text:@"支付宝支付" Color:RGBA(51, 51, 51, 1.0) Direction:NSTextAlignmentLeft];
        [self.payView addSubview:self.zhifubaoLabel];
        
        self.zhifubaoBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitSizeH(68)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"weixuanz" Target:self Action:@selector(click_Btn:)];
        [self.zhifubaoBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [self.payView addSubview:self.zhifubaoBtn];
        [self.zhifubaoBtn setImageEdgeInsets:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2 + FitSizeH(100), 0, 0)];
        self.zhifubaoBtn.selected = YES;
        currentBtn = self.zhifubaoBtn;
        
        self.weixinView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(24), FitSizeH(18) + CGRectGetMaxY(lineView.frame), FitSizeW(33), FitSizeH(33)) ImageName:@"weixin"];
        [self.payView addSubview:self.weixinView];
        
        self.weixinLabel = [FlanceTools labelCreateWithFrame:CGRectMake(CGRectGetMaxX(self.zhifubaoView.frame) + FitSizeW(10), CGRectGetMaxY(lineView.frame), FitSizeW(150), FitSizeH(68)) Font:15 IsBold:NO Text:@"微信支付" Color:RGBA(51, 51, 51, 1.0) Direction:NSTextAlignmentLeft];
        [self.payView addSubview:self.weixinLabel];
        
        self.weixinBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, FitSizeH(68), SCREEN_WIDTH, FitSizeH(68)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"weixuanz" Target:self Action:@selector(click_Btn:)];
        [self.weixinBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [self.payView addSubview:self.weixinBtn];
        [self.weixinBtn setImageEdgeInsets:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2 + FitSizeH(100), 0, 0)];
        self.weixinBtn.selected = NO;
        
    }
    
    
    self.sureBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(75), CGRectGetMaxY(self.payView.frame) + FitSizeH(99), FitSizeW(226), FitSizeH(46)) Title:@"确    认" Font:17 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_sureBtn)];
    self.sureBtn.layer.cornerRadius = FitSizeH(46) / 2;
    self.sureBtn.layer.masksToBounds = YES;
    [self.sureBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.view addSubview:self.sureBtn];
}

- (void)click_Btn:(UIButton *)sender
{
    self.zhifubaoBtn.selected = NO;
    self.weixinBtn.selected = NO;
    sender.selected = !sender.selected;
    currentBtn = sender;
}

- (void)click_sureBtn{
    
////    PaySuccessViewController * navc = [[PaySuccessViewController alloc]init];
//    PayFailureViewController * navc = [[PayFailureViewController alloc]init];
//    [self.navigationController pushViewController:navc animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (currentBtn == self.zhifubaoBtn) {
        NSLog(@"商品支付宝支付");
        [self doGetIndexOrderAliPayOrder];
    }else{
        //微信支付
        [self doGetIndexWxPayOrder];
    }
    
}

#pragma mark 支付成功
- (void)ALiPaySuccess
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.label.text = @"支付成功";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    }completionBlock:^{
        [HUD removeFromSuperview];
        PaySuccessViewController * navc = [[PaySuccessViewController alloc]init];
        navc.RentHouseVC = self.RentHouseVC;
        navc.FaBuElesVC = self.FaBuElesVC;
        navc.FaBuDatingVC = self.FaBuDatingVC;
        navc.FaBuBuySellVC = self.FaBuBuySellVC;
        navc.FaBuHousekeepingVC = self.FaBuHousekeepingVC;
        navc.FaBuRecruitmentVC = self.FaBuRecruitmentVC;
        navc.FaBuHunLianVC = self.FaBuHunLianVC;
        navc.payType = self.payType;
        [self.navigationController pushViewController:navc animated:YES];
        
    }];
}

#pragma mark 支付失败
- (void)ALiPayFailure
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.label.text = @"支付失败";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    }completionBlock:^{
        [HUD removeFromSuperview];
        PayFailureViewController * navc = [[PayFailureViewController alloc]init];
        navc.order_noStr = self.order_noStr;
        navc.total_feeStr = self.total_feeStr;
        navc.payType = self.payType;
        [self.navigationController pushViewController:navc animated:YES];
        
    }];
}


#pragma mark 商品支付宝支付
- (void)doGetIndexOrderAliPayOrder
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",OrderAliPayOrder];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    
    NSDictionary *parameters = @{@"token":tokenStr,@"order_no":self.order_noStr,@"total_fee":self.total_feeStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"OrderAliPayOrder responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            [self click_ALiPay:dataDic];
            
        }else if (code == 99){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"请登录后进行查看";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            }completionBlock:^{
                [HUD removeFromSuperview];
                LoginViewController *controller = [[LoginViewController alloc] init];
                controller.modalPresentationStyle = 0;
                [self presentViewController:controller animated:YES completion:nil];
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString * messageStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
            [self showAlert:messageStr];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error-->%@",error);
    }];
}

- (void)click_ALiPay:(NSDictionary *)orderInfo
{
    
    NSString *appScheme = @"CityThingsALiPay";
    
    NSString * orderString = [NSString stringWithFormat:@"%@",[orderInfo objectForKey:@"orderInfo"]];
    
    [[AlipaySDK defaultService]payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSString * memo = resultDic[@"memo"];
        NSLog(@"===memo:%@", memo);
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"])
        {
            NSLog(@"支付成功");
        }else{
            NSLog(@"支付失败%@",memo);
        }
    }];
}

#pragma mark 商品微信支付
- (void)doGetIndexWxPayOrder
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",OrderWxPayOrder];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    
    NSDictionary *parameters = @{@"token":tokenStr,@"order_no":self.order_noStr,@"total_fee":self.total_feeStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"OrderWxPayOrder responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //            PaySuccessViewController * navc = [[PaySuccessViewController alloc]init];
            //            [self.navigationController pushViewController:navc animated:YES];
            
            //            PayFailureViewController * navc = [[PayFailureViewController alloc]init];
            //            navc.orderID = self.orderID;
            //            navc.total_fee = self.total_fee;
            //            navc.payType = self.payType;
            //            [self.navigationController pushViewController:navc animated:YES];
            
            NSDictionary * dic = [responseObject objectForKey:@"data"];
            NSString * openID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"appid"]];
            NSString * sign = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sign"]];
            NSString * partnerid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"partnerid"]];
            NSString * package = [NSString stringWithFormat:@"%@",[dic objectForKey:@"package"]];
            NSString * noncestr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noncestr"]];
            NSString * timestamp = [NSString stringWithFormat:@"%@",[dic objectForKey:@"timestamp"]];
            NSString * prepayid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"prepayid"]];
            [self WechatPay:openID partnerId:partnerid prepayId:prepayid package:package nonceStr:noncestr timestamp:timestamp sign:sign];
        }else if (code == 99){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"请登录后进行查看";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            }completionBlock:^{
                [HUD removeFromSuperview];
                LoginViewController *controller = [[LoginViewController alloc] init];
                controller.modalPresentationStyle = 0;
                [self presentViewController:controller animated:YES completion:nil];
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString * messageStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
            [self showAlert:messageStr];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark 微信支付方法
- (void)WechatPay:(NSString *)openID partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timestamp:(NSString *)timestamp sign:(NSString *)sign{
    
    //需要创建这个支付对象
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = openID;
    // 商家id，在注册的时候给的
    req.partnerId = partnerId;
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId  = prepayId;
    // 根据财付通文档填写的数据和签名
    req.package  = package;
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = nonceStr;
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    req.timeStamp = timestamp.intValue;
    // 这个签名也是后台做的
    req.sign = sign;
    //发送请求到微信，等待微信返回onResp
    [WXApi sendReq:req];
    
}


#pragma mark 置顶临时支付接口
- (void)doGetOrderDemoWxPayOrder
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",OrderDemoWxPayOrder];
    //构造参数
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"order_no":self.order_noStr,@"total_fee":self.total_feeStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"Livelists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            PaySuccessViewController * navc = [[PaySuccessViewController alloc]init];
            [self.navigationController pushViewController:navc animated:YES];
            
        }else if (code == 99){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"请登录后进行查看";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            }completionBlock:^{
                [HUD removeFromSuperview];
                LoginViewController *controller = [[LoginViewController alloc] init];
                controller.modalPresentationStyle = 0;
                [self presentViewController:controller animated:YES completion:nil];
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString * messageStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
            [self showAlert:messageStr];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error-->%@",error);
    }];
}


-(AFHTTPSessionManager *)sharedManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //最大请求并发任务数
    manager.operationQueue.maxConcurrentOperationCount = 5;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    // 超时时间
    manager.requestSerializer.timeoutInterval = 30.0f;
    // 设置请求头
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    // 设置接收的Content-Type
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式 JSON
    //设置返回C的ontent-type
    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    return manager;
}

- (void)showAlert:(NSString *)text
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert ];
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)click_back
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"releshDetailInfo" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
