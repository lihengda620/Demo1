//
//  FaBuHousekeepingViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/28.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "FaBuHousekeepingViewController.h"

@interface FaBuHousekeepingViewController ()<UIScrollViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIScrollView * mainScrollView;
@property (nonatomic, strong) UIView * infoView;
//岗位名称
@property (nonatomic, strong) UITextField * gangweiNameTF;
//薪资待遇
@property (nonatomic, strong) UIButton * xinZiDBtn;
@property (nonatomic, strong) UITextField * minPriceTF;
@property (nonatomic, strong) UITextField * maxPriceTF;
//职业亮点
@property (nonatomic, strong) UITextField * liangDianTF;
//公司名称
@property (nonatomic, strong) UITextField * gongSiNameTF;
//工作地点
@property (nonatomic, strong) UIButton * addressBtn;
@property (nonatomic, strong) UITextField * addressTF;
//工作经验
@property (nonatomic, strong) UIButton * jingyanBtn;

//职位描述
@property (nonatomic, strong) UITextView * descriptionTextView;

//联系电话
@property (nonatomic, strong) UIView * sheJiaoLineView1;
@property (nonatomic, strong) UILabel * shejiaoTextLabel;
@property (nonatomic, strong) UITextField * shejiaoTF;
@property (nonatomic, strong) UIView * sheJiaoLineView2;
@property (nonatomic, strong) UITextView * tishiTextView;

@property (nonatomic, strong) UIButton * submitBtn;
@end

@implementation FaBuHousekeepingViewController
{
    UILabel * descriptionPlaceholder;
    NSString * jingYanStr;
    
    NSDictionary * categoryDic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    jingYanStr = @"";
    [self initNavigationView];
    [self initView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dogGetUserIndex];
    
    UITapGestureRecognizer *keyboardDownTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KeyboardDown)];
    keyboardDownTap.delegate = self;
    [self.view addGestureRecognizer:keyboardDownTap];
    
    if ([self.isEditStr isEqualToString:@"1"]) {
        [self doGetRecruithousekeepDetails];
    }
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
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.navigationView.frame))];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(850));
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), 0, FitSizeW(200), FitSizeH(38)) Font:17.0f IsBold:YES Text:@"新建一条招聘信息..." Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview: self.titleLabel];
    
    //信息模块
    self.infoView = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(38), SCREEN_WIDTH, FitSizeH(50) * 8) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.mainScrollView addSubview:self.infoView];
    
    NSArray * userTextArr = @[@"岗位名称",@"最低薪资",@"最高薪资",@"职位亮点",@"公司名称",@"工作地点",@"工作经验",@"职位描述"];
    for (int i = 0; i < userTextArr.count; i ++) {
        UILabel * userInfoTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(50) * i, FitSizeW(65), FitSizeH(50)) Font:14 IsBold:NO Text:userTextArr[i] Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.infoView addSubview:userInfoTextLabel];
        
        if (i != userTextArr.count - 1) {
            UIView * lineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), i * FitSizeH(50) + FitSizeH(50), FitSizeW(345), FitSizeH(0.5)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
            [self.infoView addSubview:lineView];
        }
    }
    
    //岗位名称
    self.gangweiNameTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), 0, FitSizeW(270), FitSizeH(50)) placeholder:@"请输入岗位名称" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.gangweiNameTF.backgroundColor = [UIColor clearColor];
    [self.infoView addSubview:self.gangweiNameTF];
    [self.gangweiNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //薪资待遇
    self.minPriceTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(50), FitSizeW(270), FitSizeH(50)) placeholder:@"请输入最低薪资（单位：K）" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.minPriceTF.backgroundColor = [UIColor clearColor];
    [self.infoView addSubview:self.minPriceTF];
    self.minPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.minPriceTF addTarget:self action:@selector(minPriceTFChange:)forControlEvents:UIControlEventEditingChanged];
    
    self.maxPriceTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(100), FitSizeW(270), FitSizeH(50)) placeholder:@"请输入最高薪资（单位：K）" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.maxPriceTF.backgroundColor = [UIColor clearColor];
    [self.infoView addSubview:self.maxPriceTF];
    self.maxPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.maxPriceTF addTarget:self action:@selector(maxPriceTFChange:)forControlEvents:UIControlEventEditingChanged];
    
    //职位亮点
    self.liangDianTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(150), FitSizeW(270), FitSizeH(50)) placeholder:@"请填写职位亮点" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.liangDianTF.backgroundColor = [UIColor clearColor];
    [self.infoView addSubview:self.liangDianTF];
    
    //公司名称
    self.gongSiNameTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(200), FitSizeW(270), FitSizeH(50)) placeholder:@"请填写公司名称" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.gongSiNameTF.backgroundColor = [UIColor clearColor];
    [self.infoView addSubview:self.gongSiNameTF];
    
    //工作地点
    self.addressTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(250), FitSizeW(270), FitSizeH(50)) placeholder:@"请填写工作地点" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.addressTF.backgroundColor = [UIColor clearColor];
    [self.infoView addSubview:self.addressTF];
    
    
    //工作经验
    self.jingyanBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(90), FitSizeH(300), FitSizeW(270), FitSizeH(50)) Title:@"请选择工作经验" Font:14 IsBold:NO TitleColor:RGBA(150, 150, 150, 1.0) TitleSelectColor:RGBA(150, 150, 150, 1.0) ImageName:@"tanchu" Target:self Action:@selector(click_WorkExperience)];
    [self.jingyanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(200), 0, 0)];
    [self.jingyanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, FitSizeW(250), 0, 0)];
    [self.infoView addSubview:self.jingyanBtn];
    
    //职位描述
    self.descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.infoView.frame), FitSizeW(345), FitSizeH(117))];
    self.descriptionTextView.layer.cornerRadius = 5;
    self.descriptionTextView.layer.masksToBounds = YES;
    self.descriptionTextView.backgroundColor = RGBA(245, 245, 245, 1.0);
    [self.descriptionTextView setFont:[UIFont systemFontOfSize:15]];
    self.descriptionTextView.delegate = self;
    [self.descriptionTextView setTextColor:RGBA(158, 158, 158, 1)];
    [self.mainScrollView addSubview:self.descriptionTextView];
    
    descriptionPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(FitSizeW(5), 0,  FitSizeW(324), FitSizeH(30))];
    descriptionPlaceholder.numberOfLines = 0;
    descriptionPlaceholder.backgroundColor = [UIColor clearColor];
    descriptionPlaceholder.textAlignment = NSTextAlignmentLeft;
    descriptionPlaceholder.font = [UIFont systemFontOfSize:15.f];
    descriptionPlaceholder.textColor = RGBA(158, 158, 158, 1);
    descriptionPlaceholder.text = @"请描述职位信息";
    [self.descriptionTextView addSubview:descriptionPlaceholder];
    
    //社交账号
    self.sheJiaoLineView1 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.descriptionTextView.frame) + FitSizeH(20), FitSizeW(345), FitSizeH(0.8)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
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
    self.tishiTextView.text = @"求职者选择与您沟通后可以看到您的联系方式，同时您的消息中心也会收到通知.";
    self.tishiTextView.userInteractionEnabled = NO;
    self.tishiTextView.backgroundColor = [UIColor whiteColor];
    [self.tishiTextView setFont:[UIFont systemFontOfSize:14]];
    [self.tishiTextView setTextColor:RGBA(80, 80, 80, 1)];
    [self.mainScrollView addSubview:self.tishiTextView];
    
    
    self.submitBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.tishiTextView.frame) + FitSizeH(20), FitSizeW(345), FitSizeH(44)) Title:@"发布信息200元/条" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_submitBtn:)];
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.mainScrollView addSubview:self.submitBtn];
}

- (void)textFieldDidChange:(id)sender
{
    if (self.gangweiNameTF.text.length > 10) // MAXLENGTH为最大字数
    {
        //超出限制字数时所要做的事
        self.gangweiNameTF.text = [self.gangweiNameTF.text substringToIndex: 10]; // MAXLENGTH为最大字数
    }
}

-(void)KeyboardDown
{
    [self.gangweiNameTF resignFirstResponder];
    [self.minPriceTF resignFirstResponder];
    [self.maxPriceTF resignFirstResponder];
    [self.liangDianTF resignFirstResponder];
    [self.gongSiNameTF resignFirstResponder];
    [self.addressTF resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
    [self.shejiaoTF resignFirstResponder];
}

- (void)click_submitBtn:(UIButton *)sender
{
    [self KeyboardDown];
    if (self.gangweiNameTF.text.length < 1) {
        [self showAlert:@"请输入岗位名称"];
        return;
    }
    if (self.minPriceTF.text.length < 1) {
        [self showAlert:@"请输入最低薪资"];
        return;
    }
    if (self.maxPriceTF.text.length < 1) {
        [self showAlert:@"请输入最高薪资"];
        return;
    }
    if (self.liangDianTF.text.length < 1) {
        [self showAlert:@"请填写职位亮点"];
        return;
    }
    if (self.gongSiNameTF.text.length < 1) {
        [self showAlert:@"请填写公司名称"];
        return;
    }
    if (self.addressTF.text.length < 1) {
        [self showAlert:@"请填写公司地址"];
        return;
    }
    
    if (jingYanStr.length < 1) {
        [self showAlert:@"请选择工作经验"];
        return;
    }
    
    if (self.descriptionTextView.text.length < 1) {
        [self showAlert:@"请描述职位信息"];
        return;
    }
    
    if (self.descriptionTextView.text.length > 50) {
        [self showAlert:@"职位信息描述过长"];
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
        [self doRecruithousekeepEdit:self.gangweiNameTF.text min_salary:self.minPriceTF.text max_salary:self.maxPriceTF.text label:self.liangDianTF.text company:self.gongSiNameTF.text province:@"" city:currentCityStr area:@"" address:self.addressTF.text  experiences:jingYanStr  describe:self.descriptionTextView.text mobile:self.shejiaoTF.text];
    }else {
     [self doRecruitstaffCreate:self.gangweiNameTF.text min_salary:self.minPriceTF.text max_salary:self.maxPriceTF.text label:self.liangDianTF.text company:self.gongSiNameTF.text province:@"" city:currentCityStr area:@"" address:self.addressTF.text  experiences:jingYanStr  describe:self.descriptionTextView.text mobile:self.shejiaoTF.text];
    }
}


#pragma mark 查询次数
- (void)dogGetUserIndex
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserIndex];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"type":@"housekeep"};
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

#pragma mark 创建订单
- (void)doOrderCreate:(NSString *)total_fee type_id:(NSString *)type_id
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",OrderCreate];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"total_fee":total_fee,@"type":@"housekeep",@"type_id":type_id,@"channel":@"2"};
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
                navc.FaBuHousekeepingVC = self;
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


#pragma mark 获取家政详情
- (void)doGetRecruithousekeepDetails
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",RecruithousekeepDetails];
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
            self.gangweiNameTF.text = nameStr;
            
            self.minPriceTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"min_salary"]];
            
            self.maxPriceTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"max_salary"]];
            
            self.liangDianTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"label"]];
            
            self.gongSiNameTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"company"]];
            
            self.addressTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"city"]];
            
            [self.jingyanBtn setTitle:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"experience_name"]] forState:UIControlStateNormal];
            self->jingYanStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"experiences"]];
            
            self.descriptionTextView.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"describe"]];
            self->descriptionPlaceholder.text = @"";
            
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

#pragma mark 发布家政
- (void)doRecruitstaffCreate:(NSString *)name min_salary:(NSString *)min_salary max_salary:(NSString *)max_salary label:(NSString *)label company:(NSString *)company province:(NSString *)province city:(NSString *)city area:(NSString *)area address:(NSString *)address  experiences:(NSString *)experiences describe:(NSString *)describe mobile:(NSString *)mobile
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",RecruithousekeepCreate];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"name":name,@"min_salary":min_salary,@"max_salary":max_salary,@"label":label,@"company":company,@"province":province,@"city":city,@"area":area,@"address":address,@"experiences":experiences,@"education":@"",@"describe":describe,@"mobile":mobile};
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


#pragma mark 修改家政
- (void)doRecruithousekeepEdit:(NSString *)name min_salary:(NSString *)min_salary max_salary:(NSString *)max_salary label:(NSString *)label company:(NSString *)company province:(NSString *)province city:(NSString *)city area:(NSString *)area address:(NSString *)address  experiences:(NSString *)experiences describe:(NSString *)describe mobile:(NSString *)mobile
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",RecruithousekeepEdit];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"name":name,@"min_salary":min_salary,@"max_salary":max_salary,@"label":label,@"company":company,@"province":province,@"city":city,@"area":area,@"address":address,@"experiences":experiences,@"education":@"",@"describe":describe,@"mobile":mobile,@"id":self.idStr};
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


#pragma mark 选择工作经验
- (void)click_WorkExperience{
    [self KeyboardDown];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择工作经验" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"不限" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击不限");
        jingYanStr = @"0";
        [self.jingyanBtn setTitle:@"不限" forState:UIControlStateNormal];
        [self.jingyanBtn setImage:nil forState:UIControlStateNormal];
        [self.jingyanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(240), 0, 0)];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"1~3年" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击1~3年");
        jingYanStr = @"1";
        [self.jingyanBtn setTitle:@"1~3年" forState:UIControlStateNormal];
        [self.jingyanBtn setImage:nil forState:UIControlStateNormal];
        [self.jingyanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(230), 0, 0)];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"3~5年" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击3~5年");
        jingYanStr = @"2";
        [self.jingyanBtn setTitle:@"3~5年" forState:UIControlStateNormal];
        [self.jingyanBtn setImage:nil forState:UIControlStateNormal];
        [self.jingyanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(230), 0, 0)];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"5~10年" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击5~10年");
        jingYanStr = @"3";
        [self.jingyanBtn setTitle:@"5~10年" forState:UIControlStateNormal];
        [self.jingyanBtn setImage:nil forState:UIControlStateNormal];
        [self.jingyanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(225), 0, 0)];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"10年以上" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击10年以上");
        jingYanStr = @"4";
        [self.jingyanBtn setTitle:@"10年以上" forState:UIControlStateNormal];
        [self.jingyanBtn setImage:nil forState:UIControlStateNormal];
        [self.jingyanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(215), 0, 0)];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)minPriceTFChange:(id)sender{
    UITextField *TextTF=(UITextField *)sender;
    NSLog(@"%@",TextTF.text);
    if (TextTF.text.length > 1) {
        if ([TextTF.text componentsSeparatedByString:@"."].count == 2){
            NSString *last = [TextTF.text componentsSeparatedByString:@"."].lastObject;
            if (last.length > 1) {
                [self showAlert:@"只能输入小数点后一位"];
                self.minPriceTF.text = @"";
            }
        }
    }
}

-(void)maxPriceTFChange:(id)sender{
    UITextField *TextTF=(UITextField *)sender;
    NSLog(@"%@",TextTF.text);
    if (TextTF.text.length > 1) {
        if ([TextTF.text componentsSeparatedByString:@"."].count == 2){
            NSString *last = [TextTF.text componentsSeparatedByString:@"."].lastObject;
            if (last.length > 1) {
                [self showAlert:@"只能输入小数点后一位"];
                self.maxPriceTF.text = @"";
            }
        }
    }
}

- (void)showAlert:(NSString *)text
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert ];
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        descriptionPlaceholder.text = @"";
    }else{
        descriptionPlaceholder.text = @"请描述职位信息";
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"开始编辑");
    [self keyboardWillShow];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"结束编辑");
    [self keyboardWillHide];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"开始编辑");
    [self keyboardWillShow];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"结束编辑");
    [self keyboardWillHide];
    return YES;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow{
    [UIView animateWithDuration:0.3 animations:^{
        self.mainScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationView.frame) - FitSizeH(350), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.navigationView.frame));
    }];
}

//当键退出时调用
- (void)keyboardWillHide{
    [UIView animateWithDuration:0.3 animations:^{
        self.mainScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.navigationView.frame));
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
