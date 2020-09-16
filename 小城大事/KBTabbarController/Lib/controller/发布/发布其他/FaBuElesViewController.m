//
//  FaBuElesViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/28.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "FaBuElesViewController.h"

@interface FaBuElesViewController ()<UIScrollViewDelegate,UITextViewDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIScrollView * mainScrollView;
@property (nonatomic, strong) UIView * infoView;

//岗位名称
@property (nonatomic, strong) UITextField * nameTF;

//发布内容
@property (nonatomic, strong) UITextView * TextView;

//联系电话
@property (nonatomic, strong) UIView * sheJiaoLineView1;
@property (nonatomic, strong) UILabel * shejiaoTextLabel;
@property (nonatomic, strong) UITextField * shejiaoTF;
@property (nonatomic, strong) UIView * sheJiaoLineView2;
@property (nonatomic, strong) UITextView * tishiTextView;

@property (nonatomic, strong) UIButton * submitBtn;

@end

@implementation FaBuElesViewController
{
    UILabel * Placeholder;
    NSDictionary * categoryDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationView];
    [self initView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dogGetUserIndex];
    
    UITapGestureRecognizer *keyboardDownTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KeyboardDown)];
    [self.view addGestureRecognizer:keyboardDownTap];
    
    if ([self.isEditStr isEqualToString:@"1"]) {
        [self doGetElsesDetails];
    }
}

-(void)KeyboardDown
{
    [self.nameTF resignFirstResponder];
    [self.TextView resignFirstResponder];
    [self.shejiaoTF resignFirstResponder];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRootViewwController) name:@"click_PWLoginDismiss" object:nil];
}

- (void)getRootViewwController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=NO;
}

- (void)initNavigationView{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, STATUS_BAR_HEIGHT +((STATUS_BAR_HEIGHT + FitSizeH(8))/2 - FitSizeH(22)), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
}

- (void)initView{
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.navigationView.frame), FitSizeW(200), FitSizeH(38)) Font:17.0f IsBold:YES Text:@"新建一条其他信息..." Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.view addSubview: self.titleLabel];
    
    //信息模块
    self.infoView = [FlanceTools viewCreateWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame) + FitSizeH(38), SCREEN_WIDTH, FitSizeH(100)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.infoView];
    
    UILabel * userInfoTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), 0, FitSizeW(65), FitSizeH(50)) Font:14 IsBold:NO Text:@"标题" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.infoView addSubview:userInfoTextLabel];
    
    UIView * lineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15),FitSizeH(50), FitSizeW(345), FitSizeH(0.5)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
    [self.infoView addSubview:lineView];
    
    
    //标题
    self.nameTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), 0, FitSizeW(270), FitSizeH(50)) placeholder:@"请输入标题" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.nameTF.backgroundColor = [UIColor clearColor];
    [self.infoView addSubview:self.nameTF];
    [self.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel * userInfoTextLabel2 = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(50), FitSizeW(65), FitSizeH(50)) Font:14 IsBold:NO Text:@"发布内容" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.infoView addSubview:userInfoTextLabel2];

    self.TextView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.infoView.frame), FitSizeW(345), FitSizeH(117))];
    self.TextView.layer.cornerRadius = 5;
    self.TextView.layer.masksToBounds = YES;
    self.TextView.backgroundColor = RGBA(245, 245, 245, 1.0);
    [self.TextView setFont:[UIFont systemFontOfSize:15]];
    self.TextView.delegate = self;
    [self.TextView setTextColor:RGBA(158, 158, 158, 1)];
    [self.view addSubview:self.TextView];
    
    Placeholder = [[UILabel alloc] initWithFrame:CGRectMake(FitSizeW(5), 0,  FitSizeW(324), FitSizeH(30))];
    Placeholder.numberOfLines = 0;
    Placeholder.backgroundColor = [UIColor clearColor];
    Placeholder.textAlignment = NSTextAlignmentLeft;
    Placeholder.font = [UIFont systemFontOfSize:15.f];
    Placeholder.textColor = RGBA(158, 158, 158, 1);
    Placeholder.text = @"请描述发布内容";
    [self.TextView addSubview:Placeholder];
    
    //社交账号
    self.sheJiaoLineView1 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.TextView.frame) + FitSizeH(20), FitSizeW(345), FitSizeH(0.8)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
    [self.view addSubview:self.sheJiaoLineView1];
    
    self.shejiaoTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.sheJiaoLineView1.frame) , FitSizeW(65), FitSizeH(50)) Font:14 IsBold:NO Text:@"联系电话" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.view addSubview:self.shejiaoTextLabel];
    
    //联系电话
    self.shejiaoTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), CGRectGetMaxY(self.sheJiaoLineView1.frame), FitSizeW(270), FitSizeH(50)) placeholder:@"请输入您的联系电话" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.shejiaoTF.backgroundColor = [UIColor clearColor];
    self.shejiaoTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.shejiaoTF];
    
    self.sheJiaoLineView2 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.sheJiaoLineView1.frame) + FitSizeH(50), FitSizeW(345), FitSizeH(0.8)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
    [self.view addSubview:self.sheJiaoLineView2];
    
    self.tishiTextView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.sheJiaoLineView2.frame) + FitSizeH(10), FitSizeW(345), FitSizeH(45))];
    self.tishiTextView.text = @"消费者与您沟通后可以看到您的联系方式，同时您的消息中心也会收到通知.";
    self.tishiTextView.userInteractionEnabled = NO;
    self.tishiTextView.backgroundColor = [UIColor whiteColor];
    [self.tishiTextView setFont:[UIFont systemFontOfSize:14]];
    [self.tishiTextView setTextColor:RGBA(80, 80, 80, 1)];
    [self.view addSubview:self.tishiTextView];
    
    
    self.submitBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(15), SCREEN_HEIGHT - FitSizeH(80), FitSizeW(345), FitSizeH(44)) Title:@"发布信息200元/条" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_submitBtn:)];
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.view addSubview:self.submitBtn];
}

- (void)textFieldDidChange:(id)sender
{
    if (self.nameTF.text.length > 10) // MAXLENGTH为最大字数
    {
        //超出限制字数时所要做的事
        self.nameTF.text = [self.nameTF.text substringToIndex: 10]; // MAXLENGTH为最大字数
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        Placeholder.text = @"";
    }else{
        Placeholder.text = @"请描述发布内容";
    }
}


- (void)click_submitBtn:(UIButton *)sender
{
    [self KeyboardDown];
    if (self.nameTF.text.length < 1) {
        [self showAlert:@"请输入标题"];
        return;
    }
    if (self.TextView.text.length < 1) {
        [self showAlert:@"请输入发布内容"];
        return;
    }
    if (self.TextView.text.length > 50) {
        [self showAlert:@"发布内容过长"];
        return;
    }
    
    
    if (![FlanceTools validateMobile:self.shejiaoTF.text]) {
        [self showAlert:@"请输入正确联系电话"];
        return;
    }
    
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * currentCityStr = [NSString stringWithFormat:@"%@",[userDefaultes stringForKey:@"currentCityStr"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.isEditStr isEqualToString:@"1"]) {
        [self doElsesEdit:self.nameTF.text content:self.TextView.text mobile:self.shejiaoTF.text city:currentCityStr];
    }else{
        [self doElsesCreate:self.nameTF.text content:self.TextView.text mobile:self.shejiaoTF.text city:currentCityStr];
    }
    
    
}

#pragma mark 创建订单
- (void)doOrderCreate:(NSString *)total_fee type_id:(NSString *)type_id
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",OrderCreate];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"total_fee":total_fee,@"type":@"else",@"type_id":type_id,@"channel":@"2"};
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
            
            NSDictionary * dic = [responseObject objectForKey:@"data"];
            NSString * is_pay = [NSString stringWithFormat:@"%@",[dic objectForKey:@"is_pay"]];
            NSString * order_no = [NSString stringWithFormat:@"%@",[dic objectForKey:@"order_no"]];
            if ([is_pay isEqualToString:@"0"]) {
                //无需支付
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.label.text = @"发布成功";
                HUD.mode = MBProgressHUDModeText;
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                }completionBlock:^{
                    [HUD removeFromSuperview];
                    UIViewController *vc =  self;
                    while (vc.presentingViewController) {
                        vc = vc.presentingViewController;
                    }
                    [vc dismissViewControllerAnimated:YES completion:nil];
                }];
            }else{
                //需支付
                PayViewController * navc = [[PayViewController alloc]init];
                navc.FaBuElesVC = self;
                navc.order_noStr = order_no;
                navc.total_feeStr = total_fee;
                navc.payType = @"1";
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                    NSLog(@"微信安装了");
                    navc.isWechartOK = @"1";
                }else{
                    NSLog(@"微信没安装");
                    navc.isWechartOK = @"0";
                }
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
                    NSLog(@"支付宝安装了");
                    navc.isALiPayOK = @"1";
                }else{
                    NSLog(@"支付宝没安装");
                    navc.isALiPayOK = @"0";
                }
                if ([navc.isWechartOK isEqualToString:@"0"]&&[navc.isALiPayOK isEqualToString:@"0"]) {
                    [self showAlert:@"检测您并未安装微信与支付宝,请安装后再进行支付"];
                }else{
                    [self.navigationController pushViewController:navc animated:YES];
                }
                
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

#pragma mark 获取其他详情
- (void)doGetElsesDetails
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",ElsesDetails];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"id":self.idStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"RecruitstaffDetails responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            
            NSString * nameStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"name"]];
            self.nameTF.text = nameStr;
            
            NSString * contentStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"content"]];
            self.TextView.text = contentStr;
            Placeholder.text = @"";
            
            self.shejiaoTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"mobile"]];
        
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


#pragma mark 发布其他
- (void)doElsesCreate:(NSString *)name content:(NSString *)content mobile:(NSString *)mobile city:(NSString *)city
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",ElsesCreate];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"name":name,@"content":content,@"mobile":mobile,@"city":city};
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
            
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            NSString * idStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"id"]];
            //发布价格
            NSString * release_price = [NSString stringWithFormat:@"%@",[self->categoryDic objectForKey:@"release_price"]];
            
            [self doOrderCreate:release_price type_id:idStr];
            
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

#pragma mark 编辑其他
- (void)doElsesEdit:(NSString *)name content:(NSString *)content mobile:(NSString *)mobile city:(NSString *)city
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",ElsesEdit];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"name":name,@"content":content,@"mobile":mobile,@"city":city,@"id":self.idStr};
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
            
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"信息修改成功";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            }completionBlock:^{
                [HUD removeFromSuperview];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
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

#pragma mark 查询次数
- (void)dogGetUserIndex
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserIndex];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"type":@"else"};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"UserIndex responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->categoryDic = [dataDic objectForKey:@"category"][0];
            //发布价格
            NSString * release_price = [NSString stringWithFormat:@"%@",[self->categoryDic objectForKey:@"release_price"]];
            //剩余发布次数
            NSString * remain_free_release = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"remain_free_release"]];
            
            float release_priceFloat = [release_price floatValue];
            int remain_free_releaseInt = [remain_free_release intValue];
            
            
            if ([self.isEditStr isEqualToString:@"1"]) {
                [self.submitBtn setTitle:@"保存" forState:UIControlStateNormal];
            }else{
                if (remain_free_releaseInt > 0) {
                    //有免费次数
                    [self.submitBtn setTitle:[NSString stringWithFormat:@"免费发布次数还剩%d次",remain_free_releaseInt] forState:UIControlStateNormal];
                }else{
                    if (release_priceFloat > 0) {
                        [self.submitBtn setTitle:[NSString stringWithFormat:@"发布信息%.2f元 / 条",release_priceFloat] forState:UIControlStateNormal];
                    }else{
                        [self.submitBtn setTitle:@"限时免费发布" forState:UIControlStateNormal];
                    }
                }
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
    [self KeyboardDown];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert ];
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)releaseSuccessful
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.label.text = @"发布成功";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    }completionBlock:^{
        [HUD removeFromSuperview];
        UIViewController *vc =  self;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)click_back
{
    if ([self.isEditStr isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
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
