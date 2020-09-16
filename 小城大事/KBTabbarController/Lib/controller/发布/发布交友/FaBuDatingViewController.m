//
//  FaBuDatingViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/29.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "FaBuDatingViewController.h"
#import "CityViewController.h"

@interface FaBuDatingViewController ()<UIScrollViewDelegate,UITextViewDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIScrollView * mainScrollView;

@property (nonatomic, strong) UIView * infoView;
//姓名
@property (nonatomic, strong) UITextField * nameTF;
//所在城市
@property (nonatomic, strong) UIButton * addressBtn;
//年龄
@property (nonatomic, strong) UITextField * ageTF;
@property (nonatomic, strong) UIButton * userManBtn;
@property (nonatomic, strong) UIButton * userWomenBtn;
//活动名称
@property (nonatomic, strong) UITextField * activityTF;

//择友标准
@property (nonatomic, strong) UITextView * zeyouTextView;



//联系方式
@property (nonatomic, strong) UIView * sheJiaoLineView1;
@property (nonatomic, strong) UILabel * shejiaoTextLabel;
@property (nonatomic, strong) UITextField * shejiaoTF;
@property (nonatomic, strong) UIView * sheJiaoLineView2;

@property (nonatomic, strong) UITextView * tishiTextView;

@property (nonatomic, strong) UIButton * submitBtn;

@end

@implementation FaBuDatingViewController{
    UILabel * introductionpPlaceholder;
    UILabel * zeyouPlaceholder;
    UILabel * jianjiePlaceholder;
    UILabel * juhuijianjiePlaceholder;
    UILabel * juhuiInfoPlaceholder;
    
    NSDictionary * categoryDic;
    NSString * currentCityStr;
    NSString * currentSelectStr;
    NSString * currentSexStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    currentCityStr = [NSString stringWithFormat:@"%@",[userDefaultes stringForKey:@"currentCityStr"]];
    currentSelectStr = currentCityStr;
    currentSexStr = @"1";
    [self initNavigationView];
    [self initView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dogGetUserIndex];
    
    UITapGestureRecognizer *keyboardDownTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KeyboardDown)];
    [self.view addGestureRecognizer:keyboardDownTap];
    
    if ([self.isEditStr isEqualToString:@"1"]) {
        [self doGetAppointmentDetails];
    }
}

-(void)KeyboardDown
{
    [self.nameTF resignFirstResponder];
    [self.ageTF resignFirstResponder];
    [self.shejiaoTF resignFirstResponder];
    [self.zeyouTextView resignFirstResponder];

    
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
    
    
    
}

- (void)initView{
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.navigationView.frame))];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(800));
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), 0, FitSizeW(200), FitSizeH(38)) Font:17.0f IsBold:YES Text:@"新建一条相约信息..." Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview: self.titleLabel];
    
    //信息模块
    self.infoView = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(38), SCREEN_WIDTH, FitSizeH(50) * 5) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.mainScrollView addSubview:self.infoView];
    
    NSArray * userTextArr = @[@"姓名",@"所在城市",@"年龄",@"性别",@"活动名称"];
    for (int i = 0; i < userTextArr.count; i ++) {
        UILabel * userInfoTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(50) * i, FitSizeW(65), FitSizeH(50)) Font:14 IsBold:NO Text:userTextArr[i] Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.infoView addSubview:userInfoTextLabel];
        
        UIView * lineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), i * FitSizeH(50) + FitSizeH(50), FitSizeW(345), FitSizeH(0.5)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
        [self.infoView addSubview:lineView];
    }
    //姓名
    self.nameTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), 0, FitSizeW(270), FitSizeH(50)) placeholder:@"请输入您的姓名" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.nameTF.backgroundColor = [UIColor clearColor];
    [self.infoView addSubview:self.nameTF];
    
    //城市
    self.addressBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(90), FitSizeH(50), FitSizeW(270), FitSizeH(50)) Title:currentCityStr Font:14 IsBold:NO TitleColor:RGBA(150, 150, 150, 1.0) TitleSelectColor:RGBA(150, 150, 150, 1.0) ImageName:@"hunlian_dingwei" Target:self Action:@selector(click_selectCityBtn:)];
    [self.addressBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(240), 0, 0)];
    [self.addressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, FitSizeW(240), 0, 0)];
    [self.infoView addSubview:self.addressBtn];
    
    //年龄
    self.ageTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(100), FitSizeW(270), FitSizeH(50)) placeholder:@"请填写您的年龄" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.ageTF.backgroundColor = [UIColor clearColor];
    [self.infoView addSubview:self.ageTF];
    
    //用户性别
    self.userManBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(90), FitSizeH(150), FitSizeW(50), FitSizeH(50)) Title:@"男" Font:14 IsBold:NO TitleColor:RGBA(15, 15, 15, 1.0) TitleSelectColor:RGBA(15, 15, 15, 1.0) ImageName:@"weixuanz" Target:self Action:@selector(click_userSexBtn:)];
    [self.userManBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    CGFloat space = FitSizeW(15);
    [self.userManBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                                     imageTitleSpace:space];
    [self.infoView addSubview:self.userManBtn];
    self.userManBtn.selected = YES;
    
    self.userWomenBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(CGRectGetMaxX(self.userManBtn.frame) + FitSizeW(20), FitSizeH(150), FitSizeW(50), FitSizeH(50)) Title:@"女" Font:14 IsBold:NO TitleColor:RGBA(15, 15, 15, 1.0) TitleSelectColor:RGBA(15, 15, 15, 1.0) ImageName:@"weixuanz" Target:self Action:@selector(click_userSexBtn:)];
    [self.userWomenBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [self.userWomenBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                                       imageTitleSpace:space];
    [self.infoView addSubview:self.userWomenBtn];
    
    
    //活动名称
    self.activityTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(200), FitSizeW(270), FitSizeH(50)) placeholder:@"请填写活动名称" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.activityTF.backgroundColor = [UIColor clearColor];
    [self.infoView addSubview:self.activityTF];
    
    UILabel * zeyouTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.infoView.frame), FitSizeW(200), FitSizeH(45)) Font:14 IsBold:NO Text:@"活动内容" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:zeyouTextLabel];
    
    //活动内容
    self.zeyouTextView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(zeyouTextLabel.frame), FitSizeW(345), FitSizeH(80))];
    self.zeyouTextView.layer.cornerRadius = 5;
    self.zeyouTextView.layer.masksToBounds = YES;
    self.zeyouTextView.backgroundColor = RGBA(245, 245, 245, 1.0);
    [self.zeyouTextView setFont:[UIFont systemFontOfSize:15]];
    self.zeyouTextView.delegate = self;
    [self.zeyouTextView setTextColor:RGBA(158, 158, 158, 1)];
    [self.mainScrollView addSubview:self.zeyouTextView];
    
    zeyouPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(FitSizeW(5), 0,  FitSizeW(324), FitSizeH(30))];
    zeyouPlaceholder.numberOfLines = 0;
    zeyouPlaceholder.backgroundColor = [UIColor clearColor];
    zeyouPlaceholder.textAlignment = NSTextAlignmentLeft;
    zeyouPlaceholder.font = [UIFont systemFontOfSize:15.f];
    zeyouPlaceholder.textColor = RGBA(158, 158, 158, 1);
    zeyouPlaceholder.text = @"请填写活动内容";
    [self.zeyouTextView addSubview:zeyouPlaceholder];
    
    
    //社交账号
    self.sheJiaoLineView1 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.zeyouTextView.frame) + FitSizeH(20), FitSizeW(345), FitSizeH(0.8)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
    [self.mainScrollView addSubview:self.sheJiaoLineView1];
    
    self.shejiaoTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.sheJiaoLineView1.frame) , FitSizeW(65), FitSizeH(50)) Font:14 IsBold:NO Text:@"联系电话" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:self.shejiaoTextLabel];
    
    //联系电话
    self.shejiaoTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), CGRectGetMaxY(self.sheJiaoLineView1.frame), FitSizeW(270), FitSizeH(50)) placeholder:@"请输入您的联系电话" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.shejiaoTF.backgroundColor = [UIColor clearColor];
    self.shejiaoTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.mainScrollView addSubview:self.shejiaoTF];
    
    self.sheJiaoLineView2 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.sheJiaoLineView1.frame) + FitSizeH(50), FitSizeW(345), FitSizeH(0.8)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
    [self.mainScrollView addSubview:self.sheJiaoLineView2];
    
    self.tishiTextView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.sheJiaoLineView2.frame) + FitSizeH(10), FitSizeW(345), FitSizeH(45))];
    self.tishiTextView.text = @"兴趣相同的朋友与您沟通后可以看到您的联系方式，同时您的消息中心也会收到通知.";
    self.tishiTextView.userInteractionEnabled = NO;
    self.tishiTextView.backgroundColor = [UIColor whiteColor];
    [self.tishiTextView setFont:[UIFont systemFontOfSize:14]];
    [self.tishiTextView setTextColor:RGBA(80, 80, 80, 1)];
    [self.mainScrollView addSubview:self.tishiTextView];
    
    
    self.submitBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.tishiTextView.frame) + FitSizeH(20), FitSizeW(345), FitSizeH(44)) Title:@"限时免费发布" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_submitBtn:)];
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.mainScrollView addSubview:self.submitBtn];
}

#pragma mark 选择性别
- (void)click_userSexBtn:(UIButton *)sender{
    self.userManBtn.selected = NO;
    self.userWomenBtn.selected = NO;
    sender.selected = !sender.selected;
    if (sender == self.userManBtn) {
        currentSexStr = @"1";
    }else{
        currentSexStr = @"2";
    }
}

#pragma mark 点击选择城市
- (void)click_selectCityBtn:(UIButton *)sender
{
    //    __weak typeof(self) weakSelf = self;
    CityViewController *controller = [[CityViewController alloc] init];
    controller.currentCityString = self->currentCityStr;
    controller.selectString = ^(NSString *string){
        self->currentSelectStr = string;
        
        [sender setTitle:[NSString stringWithFormat:@"%@",string] forState:UIControlStateNormal];
    };
    controller.modalPresentationStyle = 0;
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.zeyouTextView) {
        if (textView.text.length != 0) {
            zeyouPlaceholder.text = @"";
        }else{
            zeyouPlaceholder.text = @"请填写活动内容";
        }
    }
}

- (void)click_submitBtn:(UIButton *)sender
{
    [self KeyboardDown];
    
    if (self.nameTF.text.length < 1) {
        [self showAlert:@"请输入您的姓名"];
        return;
    }
    if (self.nameTF.text.length > 10) {
        [self showAlert:@"姓名过长"];
        return;
    }
    
    if (self.ageTF.text.length < 1) {
        [self showAlert:@"请填写您的年龄"];
        return;
    }
    if (currentSelectStr.length < 1) {
        [self showAlert:@"请选择所在城市"];
        return;
    }
    if (self.activityTF.text.length < 1) {
        [self showAlert:@"请填写活动名称"];
        return;
    }
    if (self.zeyouTextView.text.length < 1) {
        [self showAlert:@"请填写活动内容"];
        return;
    }
    if (self.activityTF.text.length > 20) {
        [self showAlert:@"活动名称过长"];
        return;
    }
    if (self.zeyouTextView.text.length > 50) {
        [self showAlert:@"活动内容过长"];
        return;
    }
    
    if (![FlanceTools validateMobile:self.shejiaoTF.text]) {
        [self showAlert:@"请输入正确联系电话"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.isEditStr isEqualToString:@"1"]) {
        [self doAppointmentEdit:self.nameTF.text province:@"" city:[NSString stringWithFormat:@"%@市",currentSelectStr] age:self.ageTF.text gender:currentSexStr declaration:self.activityTF.text standard:self.zeyouTextView.text personal_profile:@"" play_profile:@"" play_content:@"" mobile:self.shejiaoTF.text];
    }else{
        [self doAppointmentCreate:self.nameTF.text province:@"" city:[NSString stringWithFormat:@"%@市",currentSelectStr] age:self.ageTF.text gender:currentSexStr declaration:self.activityTF.text standard:self.zeyouTextView.text personal_profile:@"" play_profile:@"" play_content:@"" mobile:self.shejiaoTF.text];
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
    NSDictionary *parameters = @{@"token":tokenStr,@"total_fee":total_fee,@"type":@"appointment",@"type_id":type_id,@"channel":@"2"};
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
                navc.FaBuDatingVC = self;
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
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"releshDetailInfo" object:nil];
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

#pragma mark 获取s交友详情
- (void)doGetAppointmentDetails
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",AppointmentDetails];
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
            
            //性别
            
            NSString * genderStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"gender"]];
            NSString * sexStr = @"";
            if ([genderStr isEqualToString:@"2"]) {
                sexStr = @"女";
                self.userManBtn.selected = NO;
                self.userWomenBtn.selected = YES;
                currentSexStr = @"2";
            }else{
                sexStr = @"男";
                self.userManBtn.selected = YES;
                self.userWomenBtn.selected = NO;
                currentSexStr = @"1";
            }
            
            introductionpPlaceholder.text = @"";
            zeyouPlaceholder.text = @"";
            jianjiePlaceholder.text = @"";
            juhuijianjiePlaceholder.text = @"";
            juhuiInfoPlaceholder.text = @"";
            
            //年龄
            self.ageTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"age"]];
            
            //活动名称
            NSString * configureStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"declaration"]];
            self.activityTF.text = configureStr;
            //活动内容
            NSString * standardStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"standard"]];
            self.zeyouTextView.text = standardStr;
            
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


#pragma mark 发布交友
- (void)doAppointmentCreate:(NSString *)name province:(NSString *)province city:(NSString *)city age:(NSString *)age gender:(NSString *)gender declaration:(NSString *)declaration standard:(NSString *)standard personal_profile:(NSString *)personal_profile play_profile:(NSString *)play_profile play_content:(NSString *)play_content mobile:(NSString *)mobile
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",AppointmentCreate];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"name":name,@"province":province,@"city":city,@"age":age,@"gender":gender,@"declaration":declaration,@"standard":standard,@"personal_profile":personal_profile,@"play_profile":play_profile,@"play_content":play_content,@"mobile":mobile};
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
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

#pragma mark 编辑交友
- (void)doAppointmentEdit:(NSString *)name province:(NSString *)province city:(NSString *)city age:(NSString *)age gender:(NSString *)gender declaration:(NSString *)declaration standard:(NSString *)standard personal_profile:(NSString *)personal_profile play_profile:(NSString *)play_profile play_content:(NSString *)play_content mobile:(NSString *)mobile
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",AppointmentEdit];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"name":name,@"province":province,@"city":city,@"age":age,@"gender":gender,@"declaration":declaration,@"standard":standard,@"personal_profile":personal_profile,@"play_profile":play_profile,@"play_content":play_content,@"mobile":mobile,@"id":self.idStr};
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
    NSDictionary *parameters = @{@"token":tokenStr,@"type":@"appointment"};
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
