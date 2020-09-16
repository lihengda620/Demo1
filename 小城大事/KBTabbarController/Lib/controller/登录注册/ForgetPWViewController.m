//
//  ForgetPWViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/2.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "ForgetPWViewController.h"

@interface ForgetPWViewController ()<UITextFieldDelegate,MZTimerLabelDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UITextField * phoneTF;
@property (nonatomic, strong) UITextField * PWTF;
@property (nonatomic, strong) UITextField * againPWTF;
@property (nonatomic, strong) UITextField * codeTF;
@property (nonatomic, strong) UIButton * codeBtn;
@property (nonatomic, strong) UIButton * changePWBtn;

@end

@implementation ForgetPWViewController{
    //倒计时
    UILabel *timer_show;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, STATUS_BAR_HEIGHT +((STATUS_BAR_HEIGHT + FitSizeH(8))/2 - FitSizeH(22)), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.backBtn];
    
    [self initView];
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
    
    self.PWTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(10), 0, FitSizeH(270), FitSizeH(FitSizeH(44))) placeholder:@"请输入新密码" passWord:YES leftImageView:nil rightImageView:nil Font:15 backgRoundImageName:nil];
    self.PWTF.backgroundColor = [UIColor clearColor];
    [passWordView addSubview:self.PWTF];
    

    UIView * againPassWordView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(43), CGRectGetMaxY(passWordView.frame) + FitSizeH(29), FitSizeW(290), FitSizeH(44)) BgColor:RGBA(250, 250, 250, 1.0) BgImage:nil];
    againPassWordView.layer.cornerRadius = FitSizeW(5);
    [self.view addSubview:againPassWordView];
    
    self.againPWTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(10), 0, FitSizeH(270), FitSizeH(FitSizeH(44))) placeholder:@"请再次输入新密码" passWord:YES leftImageView:nil rightImageView:nil Font:15 backgRoundImageName:nil];
    self.againPWTF.backgroundColor = [UIColor clearColor];
    [againPassWordView addSubview:self.againPWTF];
    
    
    UIView * codeWordView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(43), CGRectGetMaxY(againPassWordView.frame) + FitSizeH(29), FitSizeW(216), FitSizeH(44)) BgColor:RGBA(250, 250, 250, 1.0) BgImage:nil];
    codeWordView.layer.cornerRadius = FitSizeW(5);
    [self.view addSubview:codeWordView];
    
    self.codeTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(10), 0, FitSizeH(196), FitSizeH(FitSizeH(44))) placeholder:@"请输入验证码" passWord:NO leftImageView:nil rightImageView:nil Font:15 backgRoundImageName:nil];
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTF.backgroundColor = [UIColor clearColor];
    [codeWordView addSubview:self.codeTF];
    
    self.codeBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(CGRectGetMaxX(againPassWordView.frame) - FitSizeW(67), CGRectGetMaxY(againPassWordView.frame) + FitSizeH(29), FitSizeW(67), FitSizeH(44)) Title:@"验证码" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_CodeBtn)];
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.masksToBounds = YES;
    [self.codeBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.view addSubview:self.codeBtn];
    
    self.changePWBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(43), CGRectGetMaxY(codeWordView.frame) + FitSizeH(37), FitSizeW(290), FitSizeH(44)) Title:@"更改密码" Font:15 IsBold:YES TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_rgisterBtn)];
    [self.changePWBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    self.changePWBtn.layer.cornerRadius = 5;
    [self.view addSubview:self.changePWBtn];
    UITapGestureRecognizer *keyboardDownTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KeyboardDown)];
    [self.view addGestureRecognizer:keyboardDownTap];
}

-(void)KeyboardDown
{
    [self.phoneTF resignFirstResponder];
    [self.PWTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.againPWTF resignFirstResponder];
}


- (void)click_rgisterBtn{
    if (![FlanceTools validateMobile:self.phoneTF.text]) {
        [self showAlert:@"手机号码有误，请重新输入"];
        return;
    }
    if (self.codeTF.text.length < 4) {
        [self showAlert:@"验证码无效"];
        return;
    }
    if (self.PWTF.text.length < 6) {
        [self showAlert:@"密码格式错误"];
        return;
    }
    if (![self.PWTF.text isEqualToString:self.againPWTF.text]) {
        [self showAlert:@"两次密码不一致"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doUserResetpwd:self.phoneTF.text codeStr:self.codeTF.text passWordStr:self.PWTF.text];
    
}

- (void)click_CodeBtn
{
    if (![FlanceTools validateMobile:self.phoneTF.text]) {
        [self showAlert:@"手机号码有误，请重新输入"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetVerificationCode:self.phoneTF.text];
    [self timeCount];
}

#pragma mark 重置密码
- (void)doUserResetpwd:(NSString *)phoneStr codeStr:(NSString *)codeStr passWordStr:(NSString *)passWordStr
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserResetpwd];
    //构造参数
    NSDictionary *parameters = @{@"mobile":phoneStr,@"newpassword":passWordStr,@"captcha":codeStr};
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
            HUD.label.text = @"密码已更新，请登录";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            }completionBlock:^{
                [HUD removeFromSuperview];
                [self dismissViewControllerAnimated:YES completion:^{
                    
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

#pragma mark 获取验证码
- (void)doGetVerificationCode:(NSString *)phoneStr
{   //创建请求地址
    NSString *url = GetFasong;
    //构造参数
    NSDictionary *parameters=@{@"mobile":phoneStr,@"event":@"resetpwd"};
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
