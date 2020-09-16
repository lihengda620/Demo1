//
//  RegisterViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/2.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "RegisterViewController.h"
#import "TemsViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate,MZTimerLabelDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UITextField * phoneTF;
@property (nonatomic, strong) UITextField * PWTF;
@property (nonatomic, strong) UITextField * codeTF;
@property (nonatomic, strong) UIButton * codeBtn;
@property (nonatomic, strong) UIButton * registerBtn;
@property (nonatomic, strong) UIButton * selectedBtn;


@end

@implementation RegisterViewController
{
    //倒计时
    UILabel *timer_show;
    NSString * tempStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    tempStr = @"0";
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
    
    
    UIView * codeWordView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(43), CGRectGetMaxY(passWordView.frame) + FitSizeH(29), FitSizeW(216), FitSizeH(44)) BgColor:RGBA(250, 250, 250, 1.0) BgImage:nil];
    codeWordView.layer.cornerRadius = FitSizeW(5);
    [self.view addSubview:codeWordView];
    
    self.codeTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(10), 0, FitSizeH(196), FitSizeH(FitSizeH(44))) placeholder:@"请输入验证码" passWord:NO leftImageView:nil rightImageView:nil Font:15 backgRoundImageName:nil];
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTF.backgroundColor = [UIColor clearColor];
    [codeWordView addSubview:self.codeTF];
    
    self.codeBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(CGRectGetMaxX(passWordView.frame) - FitSizeW(67), CGRectGetMaxY(passWordView.frame) + FitSizeH(29), FitSizeW(67), FitSizeH(44)) Title:@"验证码" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_CodeBtn)];
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.masksToBounds = YES;
    [self.codeBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.view addSubview:self.codeBtn];
    
    self.selectedBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(43), FitSizeH(60) + CGRectGetMaxY(codeWordView.frame), FitSizeH(22), FitSizeW(22)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"register_weixuanz" Target:self Action:@selector(click_selectedBtn:)];
    [self.selectedBtn setImage:[UIImage imageNamed:@"register_xuanzhong"] forState:UIControlStateSelected];
    self.selectedBtn.selected = NO;
    [self.selectedBtn setEnlargeEdge:10];
    [self.view addSubview:self.selectedBtn];
    
    GHAttributesLabel *attributesLabel = [[GHAttributesLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.selectedBtn.frame),  CGRectGetMidY(self.selectedBtn.frame) - FitSizeH(13), FitSizeW(350), FitSizeH(22))];
    NSString *temp = @"本人仔细阅读并同意《用户协议》";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:temp];
    NSString *actionStr = @"《用户协议》";
    NSRange range = [temp rangeOfString:actionStr];
    [attrStr addAttribute:NSLinkAttributeName value:actionStr range: range];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attrStr.length)];
    attributesLabel.actionBlock = ^{
        TemsViewController * navc = [[TemsViewController alloc]init];
        navc.urlStr = @"/index/Index/regtreaty";
        navc.modalPresentationStyle = 0;
        [self presentViewController:navc animated:YES completion:nil];
    };
    [attributesLabel setAttributesText:attrStr actionText:actionStr];
    [self.view addSubview:attributesLabel];
    
    self.registerBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(43), CGRectGetMaxY(codeWordView.frame) + FitSizeH(100), FitSizeW(290), FitSizeH(44)) Title:[self.isWechatLogin isEqualToString:@"1"]?@"绑定手机" : @"注册登录" Font:15 IsBold:YES TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_registerBtn)];
    [self.registerBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    self.registerBtn.layer.cornerRadius = 5;
    [self.view addSubview:self.registerBtn];
    
    self.backBtn = [FlanceTools buttonCreateWithFrame:CGRectMake((SCREEN_WIDTH - FitSizeW(100)) / 2, CGRectGetMaxY(self.registerBtn.frame) + FitSizeH(5), FitSizeW(100), FitSizeH(40)) Title:@"返回" Font:14 IsBold:NO TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(click_back)];
    [self.view addSubview:self.backBtn];
    
    UITapGestureRecognizer *keyboardDownTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KeyboardDown)];
    [self.view addGestureRecognizer:keyboardDownTap];
}

-(void)KeyboardDown
{
    [self.phoneTF resignFirstResponder];
    [self.PWTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
}

- (void)click_registerBtn
{
    if (![FlanceTools validateMobile:self.phoneTF.text]) {
        [self showAlert:@"手机号码有误，请重新输入"];
        return;
    }
    if (![FlanceTools validatePassword:self.PWTF.text]) {
        [self showAlert:@"密码格式不正确"];
        return;
    }
    if (self.codeTF.text.length > 4||self.codeTF.text.length == 0) {
        [self showAlert:@"请填写正确的验证码"];
        return;
    }
    if ([self->tempStr isEqualToString:@"0"]) {
        [self showAlert:@"请勾选本人仔细阅读并同意《用户协议》"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.isWechatLogin isEqualToString:@"1"]) {
        [self doUserBindingmobile:self.phoneTF.text codeStr:self.codeTF.text passWordStr:self.PWTF.text];
    }else{
        [self doRegister:self.phoneTF.text codeStr:self.codeTF.text passWordStr:self.PWTF.text];
    }
    
    
}

- (void)click_selectedBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        tempStr = @"1";
    }else{
        tempStr = @"0";
    }
}

- (void)click_CodeBtn
{
    [self KeyboardDown];
    if (![FlanceTools validateMobile:self.phoneTF.text]) {
        [self showAlert:@"手机号码有误，请重新输入"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetVerificationCode:self.phoneTF.text];
    
}


#pragma mark 获取验证码
- (void)doGetVerificationCode:(NSString *)phoneStr
{   //创建请求地址
    NSString *url = GetFasong;
    //构造参数
    NSDictionary *parameters=@{@"mobile":phoneStr,@"event":[self.isWechatLogin isEqualToString:@"1"] ? @"binding" : @"register"};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"responseObject-->%@",responseObject);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self timeCount];
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

#pragma mark 注册
- (void)doRegister:(NSString *)phoneStr codeStr:(NSString *)codeStr passWordStr:(NSString *)passWordStr
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",Register];
    //构造参数
    NSDictionary *parameters = @{@"mobile":phoneStr,@"password":passWordStr,@"captcha":codeStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"Register responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            //登录操作
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self doUserLogin:phoneStr passWordStr:passWordStr];
            
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
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"click_LoginDismiss" object:nil];
            UIViewController *vc =  self;
            while (vc.presentingViewController) {
                vc = vc.presentingViewController;
            }
            [vc dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark 绑定手机号
- (void)doUserBindingmobile:(NSString *)phoneStr codeStr:(NSString *)codeStr passWordStr:(NSString *)passWordStr
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserBindingmobile];
    //构造参数
    NSDictionary *parameters = @{@"mobile":phoneStr,@"password":passWordStr,@"captcha":codeStr,@"openid":self.openidStr,@"headimgurl":self.headimgurl,@"nickname":self.nickname,@"sex":self.sex};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"Register responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"绑定成功，正在登录";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(3);
            }completionBlock:^{
                [HUD removeFromSuperview];
                [self doUserLogin:phoneStr passWordStr:passWordStr];
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

- (void)timeCount{//倒计时函数
    [_codeBtn setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    timer_show = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _codeBtn.frame.size.width, _codeBtn.frame.size.height)];//UILabel设置成和UIButton一样的尺寸和位置
    [_codeBtn addSubview:timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:60];//倒计时时间60s
    timer_cutDown.timeFormat = @"ss秒";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    _codeBtn.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
}

//倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [_codeBtn setTitle:@"验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
    [timer_show removeFromSuperview];//移除倒计时模块
    _codeBtn.userInteractionEnabled = YES;//按钮可以点击
}


- (void)click_back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
