//
//  WebViewController.m
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/23.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "WebViewController.h"
#import "WXApi.h"

@interface WebViewController ()
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIWebView * mainWebView;
@property (nonatomic, strong) UIButton * rightBtn;

@property (nonatomic, strong) UIView * moreView;
@property (nonatomic, strong) UIButton * shouCangBtn;
@property (nonatomic, strong) UIButton * fenXiangBtn;
//分享
@property (nonatomic, strong) UIControl * mainControl;
@property (nonatomic, strong) UIView * shareView;

@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(releshDetailInfo) name:@"releshDetailInfo" object:nil];
    //监听UIWindow显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    //监听UIWindow隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=NO;
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)releshDetailInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetCollectExist];
}

-(void)endFullScreen{
    NSLog(@"退出全屏");
    [UIApplication sharedApplication].statusBarHidden = NO;
}

-(void)beginFullScreen{
    NSLog(@"开启全屏");
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationView];
    [self initView];
    
    
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * versionStr = [userDefaultes stringForKey:@"versionStr"];
    if (![versionStr isEqualToString:@"1.0"]) {
        NSLog(@"未登录");
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self doGetCollectExist];
    }
    
}

- (void)initNavigationView{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:self.titleStr Color:[UIColor whiteColor] Direction:NSTextAlignmentCenter];
    [self.navigationView addSubview: self.titleLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, CGRectGetMidY(self.titleLabel.frame) - FitSizeH(22), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - FitSizeW(50), STATUS_BAR_HEIGHT +(NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT) / 2 - FitSizeH(20), FitSizeW(40), FitSizeH(40));
    [self.rightBtn setImage:[UIImage imageNamed:@"icon_gengduo"] forState:UIControlStateNormal];
    self.rightBtn.layer.cornerRadius = FitSizeW(5);
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.selected = NO;
    [self.rightBtn addTarget:self action:@selector(click_rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.rightBtn];
}

- (void)click_rightBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.moreView.hidden = NO;
    }else{
        self.moreView.hidden = YES;
    }
}

- (void)initView{
    
    
    CGRect webViewRect = CGRectMake(FitSizeW(17),NAVIGATION_BAR_HEIGHT + FitSizeH(10),ScreenSizeWidth - FitSizeW(34) ,SCREENHEIGHT - FitSizeH(10) - NAVIGATION_BAR_HEIGHT);
    self.mainWebView = [[UIWebView alloc] initWithFrame:webViewRect];
    [self.mainWebView setBackgroundColor:[UIColor whiteColor]];
    self.mainWebView.scrollView.bounces = YES;
    self.mainWebView.scrollView.showsHorizontalScrollIndicator = YES;
    self.mainWebView.allowsInlineMediaPlayback = YES;
    self.mainWebView.mediaPlaybackRequiresUserAction = NO;
    [self.view addSubview:self.mainWebView];
    NSString * urlStr = [NSString stringWithFormat:@"%@/Index/index/%@?id=%@",RBDom,self.type,[self.isRecommend isEqualToString:@"1"] ? self.type_id : self.idStr];
    NSURL * url = [NSURL URLWithString:urlStr];
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //更多
    self.moreView = [FlanceTools viewCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(50), CGRectGetMaxY(self.navigationView.frame), FitSizeW(40), FitSizeH(90)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.moreView];
    self.moreView.hidden = YES;
    
    self.shouCangBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, 0, FitSizeW(40), FitSizeH(45)) Title:@"收藏" Font:13 IsBold:NO TitleColor:RGBA(15, 15, 15, 1.0) TitleSelectColor:RGBA(15, 15, 15, 1.0) ImageName:@"souchangweixuan" Target:self Action:@selector(doCollectSite:)];
    [self.shouCangBtn setImage:[UIImage imageNamed:@"shoucang_red"] forState:UIControlStateSelected];
    [self.moreView addSubview:self.shouCangBtn];
    CGFloat space = 10.0;
    [self.shouCangBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop
                                      imageTitleSpace:space];
    
    self.fenXiangBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, FitSizeH(45), FitSizeW(40), FitSizeH(45)) Title:@"分享" Font:13 IsBold:NO TitleColor:RGBA(15, 15, 15, 1.0) TitleSelectColor:RGBA(15, 15, 15, 1.0) ImageName:@"fenxiang" Target:self Action:@selector(fenXiangBtn:)];
    [self.moreView addSubview:self.fenXiangBtn];
    [self.fenXiangBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop
                                      imageTitleSpace:space];
    
    self.mainControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.mainControl];
    self.mainControl.backgroundColor = RGBA(1, 1, 1, 0.5);
    [self.mainControl addTarget:self action:@selector(click_mainCon) forControlEvents:UIControlEventTouchUpInside];
    self.mainControl.hidden = YES;
    
    self.shareView = [FlanceTools viewCreateWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, FitSizeH(208)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.shareView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.shareView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.shareView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.shareView.layer.mask = maskLayer;
    
    UIButton * wechatUserBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(29), FitSizeW(36), FitSizeW(50), FitSizeH(50)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"denxiang_weixin" Target:self Action:@selector(click_wechatUserBtn)];
    [self.shareView addSubview:wechatUserBtn];
    
    UILabel * wechatText1 = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(29), CGRectGetMaxY(wechatUserBtn.frame), FitSizeW(50), FitSizeH(25)) Font:14 IsBold:NO Text:@"微信" Color:RGBA(50, 50, 50, 1.0) Direction:NSTextAlignmentCenter];
    [self.shareView addSubview:wechatText1];
    
    UIButton * wechatFriendBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(114), FitSizeW(36), FitSizeW(50), FitSizeH(50)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"fenxiang_pengyouquan" Target:self Action:@selector(click_wechatFriendBtn)];
    [self.shareView addSubview:wechatFriendBtn];
    
    UILabel * wechatText2 = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(114), CGRectGetMaxY(wechatFriendBtn.frame), FitSizeW(50), FitSizeH(25)) Font:14 IsBold:NO Text:@"朋友圈" Color:RGBA(50, 50, 50, 1.0) Direction:NSTextAlignmentCenter];
    [self.shareView addSubview:wechatText2];
    
    UIButton * wechatCancelBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(63), FitSizeH(143), FitSizeW(250), FitSizeH(45)) Title:@"取    消" Font:17 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_wechatCancelBtn)];
    wechatCancelBtn.backgroundColor = RGBA(238, 82, 82, 1);
    wechatCancelBtn.layer.cornerRadius = FitSizeH(45) / 2;
    [self.shareView addSubview:wechatCancelBtn];
}

- (void)fenXiangBtn:(UIButton *)sender{
    self.mainControl.hidden = NO;
    [UIView animateWithDuration:0.24 animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT - FitSizeH(208), SCREEN_WIDTH, FitSizeH(208));
    }];
}

- (void)click_mainCon
{
    self.mainControl.hidden = YES;
    [UIView animateWithDuration:0.24 animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, FitSizeH(208));
    }];
}

#pragma mark 点击分享微信
- (void)click_wechatUserBtn
{
    NSString * titleStr = self.titleStr;
    NSString * descriptionStr = @"小城大事，致力于打造最专业的同城信息平台！";
    UIImage * setThumbImage = [UIImage imageNamed:@"tupian_xitong"];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = titleStr;//标题
    message.description = descriptionStr;//描述
    [message setThumbImage:setThumbImage];//设置预览图
    
    //创建网页数据对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    NSString * urlStr = [NSString stringWithFormat:@"%@/Index/index/%@?id=%@",RBDom,self.type,[self.isRecommend isEqualToString:@"1"] ? self.type_id : self.idStr];
    webObj.webpageUrl = urlStr;//链接
    message.mediaObject = webObj;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.message = message;
    sendReq.scene = WXSceneSession;//分享到好友会话
    
    [WXApi sendReq:sendReq];//发送对象实例
}

#pragma mark 点击分享朋友圈
- (void)click_wechatFriendBtn
{
    NSString * titleStr = self.titleStr;
    NSString * descriptionStr = @"小城大事，致力于打造最专业的同城信息平台！";
    UIImage * setThumbImage = [UIImage imageNamed:@"tupian_xitong"];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = titleStr;//标题
    message.description = descriptionStr;//描述
    [message setThumbImage:setThumbImage];//设置预览图
    
    //创建网页数据对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    NSString * urlStr = [NSString stringWithFormat:@"%@/Index/index/%@?id=%@",RBDom,self.type,[self.isRecommend isEqualToString:@"1"] ? self.type_id : self.idStr];
    webObj.webpageUrl = urlStr;//链接
    message.mediaObject = webObj;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.message = message;
    sendReq.scene = WXSceneTimeline;//分享到朋友圈
    
    [WXApi sendReq:sendReq];//发送对象实例
}

#pragma mark 点击分享取消
- (void)click_wechatCancelBtn
{
    self.mainControl.hidden = YES;
    [UIView animateWithDuration:0.24 animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, FitSizeH(208));
    }];
}

//WXSceneSession          = 0,   /**< 聊天界面    */
//WXSceneTimeline         = 1,   /**< 朋友圈     */
//WXSceneFavorite         = 2,   /**< 收藏       */
//WXSceneSpecifiedSession = 3,   /**< 指定联系人  */
//好友
- (void)sendMessage {
    WXMediaMessage *message = [WXMediaMessage message];
    
    NSString * titleStr = self.titleStr;
    NSString * descriptionStr = @"小城大事，致力于打造最专业的同城信息平台！";
    UIImage * setThumbImage = [UIImage imageNamed:@"tupian_xitong"];
    
    message.title = titleStr;//标题
    message.description = descriptionStr;//描述
    [message setThumbImage:setThumbImage];//设置预览图
    
    //创建网页数据对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    NSString * urlStr = [NSString stringWithFormat:@"%@/Index/index/%@?id=%@",RBDom,self.type,[self.isRecommend isEqualToString:@"1"] ? self.type_id : self.idStr];
    webObj.webpageUrl = urlStr;//链接
    message.mediaObject = webObj;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.message = message;
    sendReq.scene = WXSceneSession;//分享到好友会话
    
    [WXApi sendReq:sendReq];//发送对象实例
}

//朋友圈
- (void)sendMessageForWXSceneTimeline {
    //    if([WXApi isWXAppInstalled]){//判断当前设备是否安装微信客户端
    //
    //
    //    }else{
    //
    //        //未安装微信应用或版本过低
    //        NSLog(@"11");
    //    }
    
    //创建多媒体消息结构体
    WXMediaMessage *message = [WXMediaMessage message];
    
    NSString * titleStr = self.titleStr;
    NSString * descriptionStr = @"小城大事，致力于打造最专业的同城信息平台！";
    UIImage * setThumbImage = [UIImage imageNamed:@"tupian_xitong"];
    
    message.title = titleStr;//标题
    message.description = descriptionStr;//描述
    [message setThumbImage:setThumbImage];//设置预览图
    
    //创建网页数据对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    NSString * urlStr = [NSString stringWithFormat:@"%@/Index/index/%@?id=%@",RBDom,self.type,[self.isRecommend isEqualToString:@"1"] ? self.type_id : self.idStr];
    webObj.webpageUrl = urlStr;//链接
    message.mediaObject = webObj;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.message = message;
    sendReq.scene = WXSceneTimeline;//分享到朋友圈
    
    [WXApi sendReq:sendReq];//发送对象实例
}

#pragma mark 收藏与取消收藏
- (void)doCollectSite:(UIButton *)sender
{
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * versionStr = [userDefaultes stringForKey:@"versionStr"];
    if (![versionStr isEqualToString:@"1.0"]) {
        NSLog(@"未登录");
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.label.text = @"请登录后进行操作";
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
        //创建请求地址
        NSString *url=[NSString stringWithFormat:@"%@",CollectSite];
        //构造参数
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
        NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
        NSDictionary *parameters = @{@"token":tokenStr,@"type_id":self.idStr,@"type":[self.isRecommend isEqualToString:@"1"] ? @"recommend" : self.type};
        //AFN管理者调用get请求方法
        [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            //返回请求返回进度
            NSLog(@"downloadProgress-->%@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功返回数据 根据responseSerializer 返回不同的数据格式
            NSLog(@"GoodsSiteCollectGoods responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
            int code = [[responseObject valueForKey:@"code"]intValue];
            if (code == 200) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                sender.selected = !sender.selected;
                if (sender.selected == YES) {
                    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.label.text = @"收藏成功";
                    HUD.mode = MBProgressHUDModeText;
                    [HUD showAnimated:YES whileExecutingBlock:^{
                        sleep(2);
                    }completionBlock:^{
                        [HUD removeFromSuperview];
                        
                    }];
                }else{
                    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.label.text = @"取消收藏成功";
                    HUD.mode = MBProgressHUDModeText;
                    [HUD showAnimated:YES whileExecutingBlock:^{
                        sleep(2);
                    }completionBlock:^{
                        [HUD removeFromSuperview];
                        
                    }];
                }
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
    
}
#pragma mark 收藏与取消收藏
- (void)doGetCollectExist
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",CollectExist];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"id":self.idStr,@"type":[self.isRecommend isEqualToString:@"1"] ? @"recommend" : self.type,@"return":@"json"};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"GoodsSiteCollectGoods responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString * dataStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                self.shouCangBtn.selected = NO;
            }else{
                self.shouCangBtn.selected = YES;
            }
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
