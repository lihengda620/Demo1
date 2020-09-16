//
//  ChangePhoneViewController.m
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/26.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "ChangePhoneViewController.h"

@interface ChangePhoneViewController ()<UITextFieldDelegate,MZTimerLabelDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UITextField * phoneTF;
@property (nonatomic, strong) UITextField * nowPhoneTF;
@property (nonatomic, strong) UITextField * codeTF;
@property (nonatomic, strong) UIButton * codeBtn;
@property (nonatomic, strong) UIButton * registerBtn;


@end

@implementation ChangePhoneViewController
{
    //倒计时
    UILabel *timer_show;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.nowPhoneTF.text = @"";
    self.codeTF.text = @"";
    self.phoneTF.text = @"";
    [_codeBtn setTitle:@"验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
    [timer_show removeFromSuperview];//移除倒计时模块
    _codeBtn.userInteractionEnabled = YES;//按钮可以点击
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=NO;
    
}



- (void)initView
{
    self.logoImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake((SCREEN_WIDTH - FitSizeW(233)) / 2, FitSizeH(101), FitSizeW(233), FitSizeH(62)) ImageName:@"logo"];
    [self.view addSubview:self.logoImageView];
    
    UIView * phoneView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(43), CGRectGetMaxY(self.logoImageView.frame) + FitSizeH(46), FitSizeW(290), FitSizeH(44)) BgColor:RGBA(250, 250, 250, 1.0) BgImage:nil];
    phoneView.layer.cornerRadius = FitSizeW(5);
    [self.view addSubview:phoneView];
    
    self.phoneTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(10), 0, FitSizeH(270), FitSizeH(FitSizeH(44))) placeholder:@"请输入旧手机号" passWord:NO leftImageView:nil rightImageView:nil Font:15 backgRoundImageName:nil];
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTF.backgroundColor = [UIColor clearColor];
    [phoneView addSubview:self.phoneTF];
    
    UIView * passWordView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(43), CGRectGetMaxY(phoneView.frame) + FitSizeH(29), FitSizeW(290), FitSizeH(44)) BgColor:RGBA(250, 250, 250, 1.0) BgImage:nil];
    passWordView.layer.cornerRadius = FitSizeW(5);
    [self.view addSubview:passWordView];
    
    self.nowPhoneTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(10), 0, FitSizeH(270), FitSizeH(FitSizeH(44))) placeholder:@"请输入新手机号" passWord:NO leftImageView:nil rightImageView:nil Font:15 backgRoundImageName:nil];
    self.nowPhoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.nowPhoneTF.backgroundColor = [UIColor clearColor];
    [passWordView addSubview:self.nowPhoneTF];
    
    
    UIView * codeWordView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(43), CGRectGetMaxY(passWordView.frame) + FitSizeH(29), FitSizeW(216), FitSizeH(44)) BgColor:RGBA(250, 250, 250, 1.0) BgImage:nil];
    codeWordView.layer.cornerRadius = FitSizeW(5);
    [self.view addSubview:codeWordView];
    
    self.codeTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(10), 0, FitSizeH(196), FitSizeH(FitSizeH(44))) placeholder:@"请输入新手机验证码" passWord:NO leftImageView:nil rightImageView:nil Font:15 backgRoundImageName:nil];
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTF.backgroundColor = [UIColor clearColor];
    [codeWordView addSubview:self.codeTF];
    
    self.codeBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(CGRectGetMaxX(passWordView.frame) - FitSizeW(67), CGRectGetMaxY(passWordView.frame) + FitSizeH(29), FitSizeW(67), FitSizeH(44)) Title:@"验证码" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_CodeBtn)];
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.masksToBounds = YES;
    [self.codeBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.view addSubview:self.codeBtn];

    
    self.registerBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(43), CGRectGetMaxY(codeWordView.frame) + FitSizeH(100), FitSizeW(290), FitSizeH(44)) Title:@"确认更换" Font:15 IsBold:YES TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_registerBtn)];
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
    [self.nowPhoneTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
}

- (void)click_registerBtn
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * moblieStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"mobile"]];
    if (![FlanceTools validateMobile:self.phoneTF.text]) {
        [self showAlert:@"手机号码有误，请重新输入"];
        return;
    }
    if (![FlanceTools validateMobile:self.nowPhoneTF.text]) {
        [self showAlert:@"手机号码有误，请重新输入"];
        return;
    }
    if ([self.nowPhoneTF.text isEqualToString:self.phoneTF.text]) {
        [self showAlert:@"新手机号与旧手机号相同"];
        return;
    }
    if (![self.phoneTF.text isEqualToString:moblieStr]) {
        [self showAlert:@"旧手机号与登录手机号不符"];
        return;
    }
    if (self.codeTF.text.length > 4||self.codeTF.text.length == 0) {
        [self showAlert:@"请填写正确的验证码"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doUserChangemobile:self.nowPhoneTF.text captcha:self.codeTF.text];
    
}

- (void)click_selectedBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)click_CodeBtn
{
    [self KeyboardDown];
    if (![FlanceTools validateMobile:self.nowPhoneTF.text]) {
        [self showAlert:@"手机号码有误，请重新输入"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetVerificationCode:self.nowPhoneTF.text];
    
}


#pragma mark 获取验证码
- (void)doGetVerificationCode:(NSString *)phoneStr
{   //创建请求地址
    NSString *url = GetFasong;
    //构造参数
    NSDictionary *parameters=@{@"mobile":phoneStr,@"event":@"changemobile"};
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

#pragma mark 修改手机号
- (void)doUserChangemobile:(NSString *)phoneStr captcha:(NSString *)captcha
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserChangemobile];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"mobile":phoneStr,@"token":tokenStr,@"captcha":captcha};
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
            [self.navc ChangePhoneLogOut];
            [self.navigationController popViewControllerAnimated:YES];
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
