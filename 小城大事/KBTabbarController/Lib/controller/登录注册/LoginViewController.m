//
//  LoginViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/2.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPWViewController.h"
#import "RegisterViewController.h"
#import "CodeLoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UITextField * phoneTF;
@property (nonatomic, strong) UITextField * PWTF;
@property (nonatomic, strong) UIButton * codeLoginBtn;
@property (nonatomic, strong) UIButton * forgetPWBtn;
@property (nonatomic, strong) UIButton * loginBtn;
@property (nonatomic, strong) UIButton * registerBtn;
@property (nonatomic, strong) UIButton * weichatBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.logNAVC = self;
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, STATUS_BAR_HEIGHT +((STATUS_BAR_HEIGHT + FitSizeH(8))/2 - FitSizeH(22)), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.backBtn];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)initView
{
    self.logoImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake((SCREEN_WIDTH - FitSizeW(233)) / 2, FitSizeH(101), FitSizeW(233), FitSizeH(62)) ImageName:@"logo"];
    [self.view addSubview:self.logoImageView];
    
    UIView * phoneView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(43), CGRectGetMaxY(self.logoImageView.frame) + FitSizeH(46), FitSizeW(290), FitSizeH(44)) BgColor:RGBA(250, 250, 250, 1.0) BgImage:nil];
    phoneView.layer.cornerRadius = FitSizeW(5);
    [self.view addSubview:phoneView];
    
    self.phoneTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(10), 0, FitSizeH(270), FitSizeH(FitSizeH(44))) placeholder:@"请输入手机号" passWord:NO leftImageView:nil rightImageView:nil Font:15 backgRoundImageName:nil];
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTF.backgroundColor = [UIColor clearColor];
    [phoneView addSubview:self.phoneTF];
    
    UIView * passWordView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(43), CGRectGetMaxY(phoneView.frame) + FitSizeH(29), FitSizeW(290), FitSizeH(44)) BgColor:RGBA(250, 250, 250, 1.0) BgImage:nil];
    passWordView.layer.cornerRadius = FitSizeW(5);
    [self.view addSubview:passWordView];
    
    self.PWTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(10), 0, FitSizeH(270), FitSizeH(FitSizeH(44))) placeholder:@"请输入密码" passWord:YES leftImageView:nil rightImageView:nil Font:15 backgRoundImageName:nil];
    self.PWTF.backgroundColor = [UIColor clearColor];
    [passWordView addSubview:self.PWTF];
    
    self.codeLoginBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(CGRectGetMinX(passWordView.frame), CGRectGetMaxY(passWordView.frame), FitSizeW(100), FitSizeH(40)) Title:@"验证码登录" Font:14 IsBold:NO TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(click_codeLogin)];
    self.codeLoginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.codeLoginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.view addSubview:self.codeLoginBtn];
    
    self.forgetPWBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(CGRectGetMaxX(passWordView.frame) - FitSizeW(100), CGRectGetMaxY(passWordView.frame), FitSizeW(100), FitSizeH(40)) Title:@"忘记密码？" Font:14 IsBold:NO TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(click_forgetBtn)];
    self.forgetPWBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:self.forgetPWBtn];
    
    self.loginBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(43), CGRectGetMaxX(passWordView.frame) + FitSizeH(90), FitSizeW(290), FitSizeH(44)) Title:@"登录" Font:15 IsBold:YES TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_LoginBtn)];
    [self.loginBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    self.loginBtn.layer.cornerRadius = 5;
    [self.view addSubview:self.loginBtn];
    
    self.registerBtn = [FlanceTools buttonCreateWithFrame:CGRectMake((SCREEN_WIDTH - FitSizeW(100)) / 2, CGRectGetMaxY(self.loginBtn.frame) + FitSizeH(5), FitSizeW(100), FitSizeH(40)) Title:@"立即注册" Font:14 IsBold:NO TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(click_registerBtn)];
    [self.view addSubview:self.registerBtn];
    
    
   
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        NSLog(@"微信安装了");
        UILabel * loginTypeLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREENWIDTH / 2 - FitSizeW(60.5), FitSizeH(30) + CGRectGetMaxY(self.registerBtn.frame), FitSizeW(121), FitSizeH(20)) Font:13 IsBold:NO Text:@"其他登录方式" Color:RGBA(150, 150, 150, 1.0) Direction:NSTextAlignmentCenter];
        [self.view addSubview:loginTypeLabel];
        
        UIView * lineview3 = [FlanceTools viewCreateWithFrame:CGRectMake(CGRectGetMinX(loginTypeLabel.frame) - FitSizeW(63), CGRectGetMidY(loginTypeLabel.frame) - FitSizeH(0.5), FitSizeW(63), FitSizeH(1)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
        [self.view addSubview:lineview3];
        
        UIView * lineview4 = [FlanceTools viewCreateWithFrame:CGRectMake(CGRectGetMaxX(loginTypeLabel.frame), CGRectGetMidY(loginTypeLabel.frame) - FitSizeH(0.5), FitSizeW(63), FitSizeH(1)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
        [self.view addSubview:lineview4];
        
        self.weichatBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(SCREEN_WIDTH / 2 - FitSizeH(24), CGRectGetMaxY(loginTypeLabel.frame) + FitSizeH(10), FitSizeW(48), FitSizeH(48)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"weixinLogin" Target:self Action:@selector(click_wechatLoginBtn:)];
        [self.view addSubview:self.weichatBtn];
        UITapGestureRecognizer *keyboardDownTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KeyboardDown)];
        [self.view addGestureRecognizer:keyboardDownTap];
    }else{
        NSLog(@"微信没安装");
    }
}

-(void)KeyboardDown
{
    [self.phoneTF resignFirstResponder];
    [self.PWTF resignFirstResponder];
    
}

- (void)click_LoginBtn
{
    if (![FlanceTools validateMobile:self.phoneTF.text]) {
        [self showAlert:@"手机号码有误，请重新输入"];
        return;
    }
    if (self.PWTF.text.length == 0) {
        [self showAlert:@"请输入密码"];
        return;
    }
    //登录操作
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doUserLogin:self.phoneTF.text passWordStr:self.PWTF.text];
}

- (void)click_codeLogin
{
    CodeLoginViewController * navc = [[CodeLoginViewController alloc]init];
    navc.modalPresentationStyle = 0;
    [self presentViewController:navc animated:YES completion:nil];
}

- (void)click_forgetBtn
{
    
    ForgetPWViewController * navc = [[ForgetPWViewController alloc]init];
    navc.modalPresentationStyle = 0;
    [self presentViewController:navc animated:YES completion:nil];
}

- (void)click_registerBtn
{
    RegisterViewController * navc = [[RegisterViewController alloc]init];
    navc.modalPresentationStyle = 0;
    [self presentViewController:navc animated:YES completion:nil];
}

- (void)click_wechatLoginBtn:(UIButton *)sender
{
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}

- (void)getWechatLogin:(NSString*)code{
    NSLog(@"code %@",code);
    __weak typeof(*&self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    //通过 appid  secret 认证code . 来发送获取 access_token的请求
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChatAPIKey,WeChatAppSecret,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic %@",dic);
        
        /*
         access_token    接口调用凭证
         expires_in    access_token接口调用凭证超时时间，单位（秒）
         refresh_token    用户刷新access_token
         openid    授权用户唯一标识
         scope    用户授权的作用域，使用逗号（,）分隔
         unionid     当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
        NSString* accessToken=[dic valueForKey:@"access_token"];
        NSString* openID=[dic valueForKey:@"openid"];
        NSString* refresh_token=[dic valueForKey:@"refresh_token"];
        NSString* expires_in=[dic valueForKey:@"expires_in"];
        [weakSelf requestUserInfoByToken:accessToken andOpenid:openID refresh_token:refresh_token expires_in:expires_in];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.localizedFailureReason);
    }];
    
}

-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID refresh_token:(NSString *)refresh_token expires_in:(NSString *)expires_in{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic  ==== %@",dic);
        NSString * head_imgStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"headimgurl"]];
        NSString * nicknameStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
        
        NSString * sexStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sex"]];
        [self doWechatLogin:openID access_token:token refresh_token:refresh_token expires_in:expires_in headimgurl:head_imgStr nickname:nicknameStr sex:sexStr];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %ld",(long)error.code);
    }];
}

#pragma mark 微信登录
- (void)doWechatLogin:(NSString *)openidStr access_token:(NSString *)access_token refresh_token:(NSString *)refresh_token expires_in:(NSString *)expires_in headimgurl:(NSString *)headimgurl nickname:(NSString *)nickname sex:(NSString *)sex
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserThird];
    //构造参数
    NSDictionary *parameters = @{@"openid":openidStr,@"expires_in":expires_in,@"access_token":access_token,@"refresh_token":refresh_token};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"UserLogin responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            NSDictionary * userinfoDic = [dataDic objectForKey:@"userinfo"];
            [userDefaultes setValue:userinfoDic forKey:@"userinfoDic"];
            //记录登录状态
            NSString * versionStr = @"1.0";
            NSString * mianzeStr = @"1.0";
            [userDefaultes setObject:versionStr forKey:@"versionStr"];
            [userDefaultes setObject:mianzeStr forKey:@"mianzeStr"];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"正在登录，请稍后";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            }completionBlock:^{
                [HUD removeFromSuperview];
                UIViewController *vc =  self;
                while (vc.presentingViewController) {
                    vc = vc.presentingViewController;
                }
                [vc dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"releshDetailInfo" object:nil];
            }];
        }else if (code == 3){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"检测您还未绑定手机号，请先绑定手机号";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(3);
            }completionBlock:^{
                [HUD removeFromSuperview];
                RegisterViewController * navc = [[RegisterViewController alloc]init];
                navc.isWechatLogin = @"1";
                navc.openidStr = openidStr;
                navc.headimgurl = headimgurl;
                navc.nickname = nickname;
                navc.sex = sex;
                navc.modalPresentationStyle = 0;
                [self presentViewController:navc animated:YES completion:^{
                }];
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


#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

// 返回16位大小写字母和数字
-(NSString *)getRandomString{
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:16];
    for (int i = 0; i < 16; i++)
    {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    return result;
}


#pragma mark 登录
- (void)doUserLogin:(NSString *)phoneStr passWordStr:(NSString *)passWordStr
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserLogin];
    //构造参数
    NSDictionary *parameters = @{@"account":phoneStr,@"password":passWordStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"UserLogin responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            NSDictionary * userinfoDic = [dataDic objectForKey:@"userinfo"];
            [userDefaultes setValue:userinfoDic forKey:@"userinfoDic"];
            //记录登录状态
            NSString * versionStr = @"1.0";
            NSString * mianzeStr = @"1.0";
            [userDefaultes setObject:versionStr forKey:@"versionStr"];
            [userDefaultes setObject:mianzeStr forKey:@"mianzeStr"];
            
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"正在登录，请稍后";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            }completionBlock:^{
                [HUD removeFromSuperview];
                UIViewController *vc =  self;
                while (vc.presentingViewController) {
                    vc = vc.presentingViewController;
                }
                [vc dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"releshDetailInfo" object:nil];
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
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"click_PWLoginDismiss" object:nil];
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
