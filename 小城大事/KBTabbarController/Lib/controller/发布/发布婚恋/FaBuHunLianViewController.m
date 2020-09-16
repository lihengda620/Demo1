//
//  FaBuHunLianViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/27.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "FaBuHunLianViewController.h"
#import "CityViewController.h"
static const CGFloat kPhotoViewMargin = 12.0;

@interface FaBuHunLianViewController ()<UIScrollViewDelegate,UITextViewDelegate,HXPhotoViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView * photoView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIScrollView * mainScrollView;

@property (nonatomic, strong) UIView * userInfoView1;
@property (nonatomic, strong) UITextField * userNameTF;
@property (nonatomic, strong) UIButton * addressBtn;
@property (nonatomic, strong) UITextField * ageTF;
@property (nonatomic, strong) UIButton * userManBtn;
@property (nonatomic, strong) UIButton * userWomenBtn;
@property (nonatomic, strong) UIButton * xueLiBtn;
@property (nonatomic, strong) UIButton * hunYinBtn;
@property (nonatomic, strong) UITextField * shenGaoTF;
@property (nonatomic, strong) UITextField * zhiYeTF;
@property (nonatomic, strong) UITextField * shouRuTF;
@property (nonatomic, strong) UITextField * geRenTeZhengTF;
@property (nonatomic, strong) UITextField * zeOuBiaoZhunTF;
//个人简介
@property (nonatomic, strong) UITextView * introductionpTextView;
//兴趣爱好
@property (nonatomic, strong) UITextView * interestTextView;
//内心独白
@property (nonatomic, strong) UITextView * monologueTextView;

@property (nonatomic, strong) UILabel * IDCardTextLabel;

//社交账号
@property (nonatomic, strong) UIView * connectionView;
@property (nonatomic, strong) UIView * sheJiaoLineView1;
@property (nonatomic, strong) UILabel * shejiaoTextLabel;
@property (nonatomic, strong) UITextField * shejiaoTF;
@property (nonatomic, strong) UIView * sheJiaoLineView2;

@property (nonatomic, strong) UITextView * tishiTextView;

@property (nonatomic, strong) UIButton * submitBtn;

@property (nonatomic, strong) UIControl * mainControl;

@property (nonatomic, strong) UIView * xueliBGView;

@property (nonatomic, strong) UIPickerView * xueLiPickerView;

@property (nonatomic, strong) UILabel * ziPaiTextLabel;

@property (nonatomic, strong) UIView * downLoadPhotoView;

@property (nonatomic, strong) UIControl * keyboardControl;


@end

@implementation FaBuHunLianViewController{
    UILabel * introductionpPlaceholder;
    UILabel * interestPlaceholder;
    UILabel * monologuePlaceholder;
    NSArray * xueLiPickerArr;
    NSString * currentXueliStr;
    NSString * currentXueliIDStr;
    
    NSDictionary * categoryDic;
    NSString * currentCityStr;
    NSString * currentSelectStr;
    NSString * currentSexStr;
    
    NSArray * photoImageArr;
    NSMutableArray * uploadImagePathArr;
    NSString * uploadImageAllPath;
    
    NSString * hunYinIDStr;
    
    NSMutableArray * downLoadPhotoArr;
    
    UIImagePickerController *imagePicker;
    
    int upLoadInt;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * xueLiPickerArrPath = [[NSBundle mainBundle]pathForResource:@"EducationalPlist" ofType:@"plist"];
    xueLiPickerArr = [NSArray arrayWithContentsOfFile:xueLiPickerArrPath];
    uploadImagePathArr = [NSMutableArray array];
    downLoadPhotoArr = [NSMutableArray array];
    currentXueliStr = @"不限";
    currentXueliIDStr = @"";
    hunYinIDStr = @"";
    upLoadInt = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    currentCityStr = [NSString stringWithFormat:@"%@",[userDefaultes stringForKey:@"currentCityStr"]];
    currentSelectStr = currentCityStr;
    currentSexStr = @"1";
    [self initNavigationView];
    [self initView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dogGetUserIndex];
    
    if ([self.isEditStr isEqualToString:@"1"]) {
        [self doGetLiveDetails];
    }
}

-(void)KeyboardDown
{
    [self.userNameTF resignFirstResponder];
    [self.ageTF resignFirstResponder];
    [self.shenGaoTF resignFirstResponder];
    [self.zhiYeTF resignFirstResponder];
    [self.shouRuTF resignFirstResponder];
    [self.geRenTeZhengTF resignFirstResponder];
    [self.zeOuBiaoZhunTF resignFirstResponder];
    [self.introductionpTextView resignFirstResponder];
    [self.interestTextView resignFirstResponder];
    [self.monologueTextView resignFirstResponder];
    [self.tishiTextView resignFirstResponder];
}

- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.photoMaxNum = 5;
        _manager.configuration.deleteTemporaryPhoto = NO;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.saveSystemAblum = YES;
        
        _manager.configuration.navigationBar = ^(UINavigationBar *navigationBar, UIViewController *viewController) {
            
        };
        _manager.configuration.requestImageAfterFinishingSelection = YES;
    }
    return _manager;
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
    self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1550));
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), 0, FitSizeW(200), FitSizeH(38)) Font:17.0f IsBold:YES Text:@"新建一条婚恋信息..." Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview: self.titleLabel];
    
    //用户信息模块
    self.userInfoView1 = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(38), SCREEN_WIDTH, FitSizeH(50) * 12) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.mainScrollView addSubview:self.userInfoView1];
    
    NSArray * userTextArr = @[@"姓名",@"所在城市",@"年龄",@"性别",@"学历",@"婚姻状况",@"身高",@"职业",@"月收入",@"个人特征",@"择偶标准",@"个人简介"];
    for (int i = 0; i < userTextArr.count; i ++) {
        UILabel * userInfoTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(50) * i, FitSizeW(65), FitSizeH(50)) Font:14 IsBold:NO Text:userTextArr[i] Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.userInfoView1 addSubview:userInfoTextLabel];
        
        if (i != userTextArr.count - 1) {
            UIView * lineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), i * FitSizeH(50) + FitSizeH(50), FitSizeW(345), FitSizeH(0.5)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
            [self.userInfoView1 addSubview:lineView];
        }
    }
    
    //用户名
    self.userNameTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), 0, FitSizeW(270), FitSizeH(50)) placeholder:@"请输入姓名" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.userNameTF.backgroundColor = [UIColor clearColor];
    self.userNameTF.returnKeyType = UIReturnKeyDone;
    self.userNameTF.delegate = self;
    [self.userInfoView1 addSubview:self.userNameTF];
    [self.userNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //城市
    self.addressBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(90), FitSizeH(50), FitSizeW(270), FitSizeH(50)) Title:@"请选所在城市" Font:14 IsBold:NO TitleColor:RGBA(150, 150, 150, 1.0) TitleSelectColor:RGBA(150, 150, 150, 1.0) ImageName:@"hunlian_dingwei" Target:self Action:@selector(click_selectCityBtn:)];
    [self.addressBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(210), 0, 0)];
    [self.addressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, FitSizeW(240), 0, 0)];
    [self.userInfoView1 addSubview:self.addressBtn];
    
    //用户年龄
    self.ageTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(100), FitSizeW(270), FitSizeH(50)) placeholder:@"请输入年龄" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.ageTF.backgroundColor = [UIColor clearColor];
    self.ageTF.returnKeyType = UIReturnKeyDone;
    self.ageTF.keyboardType = UIKeyboardTypeNumberPad;
    self.ageTF.delegate = self;
    [self.userInfoView1 addSubview:self.ageTF];
    
    //用户性别
    self.userManBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(90), FitSizeH(150), FitSizeW(50), FitSizeH(50)) Title:@"男" Font:14 IsBold:NO TitleColor:RGBA(15, 15, 15, 1.0) TitleSelectColor:RGBA(15, 15, 15, 1.0) ImageName:@"weixuanz" Target:self Action:@selector(click_userSexBtn:)];
    [self.userManBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    CGFloat space = FitSizeW(15);
    [self.userManBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                                 imageTitleSpace:space];
    [self.userInfoView1 addSubview:self.userManBtn];
    self.userManBtn.selected = YES;
    
    self.userWomenBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(CGRectGetMaxX(self.userManBtn.frame) + FitSizeW(20), FitSizeH(150), FitSizeW(50), FitSizeH(50)) Title:@"女" Font:14 IsBold:NO TitleColor:RGBA(15, 15, 15, 1.0) TitleSelectColor:RGBA(15, 15, 15, 1.0) ImageName:@"weixuanz" Target:self Action:@selector(click_userSexBtn:)];
    [self.userWomenBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [self.userWomenBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                                     imageTitleSpace:space];
    [self.userInfoView1 addSubview:self.userWomenBtn];
    
    //用户学历
    self.xueLiBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(90), FitSizeH(200), FitSizeW(270), FitSizeH(50)) Title:@"请选择学历" Font:14 IsBold:NO TitleColor:RGBA(150, 150, 150, 1.0) TitleSelectColor:RGBA(150, 150, 150, 1.0) ImageName:@"tanchu" Target:self Action:@selector(click_xueLiBtn)];
    [self.xueLiBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(210), 0, 0)];
    [self.xueLiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, FitSizeW(240), 0, 0)];
    [self.userInfoView1 addSubview:self.xueLiBtn];
    
    //婚姻情况
    self.hunYinBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(90), FitSizeH(250), FitSizeW(270), FitSizeH(50)) Title:@"请选择婚姻状况" Font:14 IsBold:NO TitleColor:RGBA(150, 150, 150, 1.0) TitleSelectColor:RGBA(150, 150, 150, 1.0) ImageName:@"tanchu" Target:self Action:@selector(click_marriageType)];
    [self.hunYinBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(210), 0, 0)];
    [self.hunYinBtn setImageEdgeInsets:UIEdgeInsetsMake(0, FitSizeW(240), 0, 0)];
    [self.userInfoView1 addSubview:self.hunYinBtn];
    
    //用户身高
    self.shenGaoTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(300), FitSizeW(270), FitSizeH(50)) placeholder:@"请填写身高" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.shenGaoTF.backgroundColor = [UIColor clearColor];
    self.shenGaoTF.returnKeyType = UIReturnKeyDone;
    self.shenGaoTF.delegate = self;
    self.shenGaoTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.userInfoView1 addSubview:self.shenGaoTF];
    
    //用户职业
    self.zhiYeTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(350), FitSizeW(270), FitSizeH(50)) placeholder:@"请填写职业" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.zhiYeTF.backgroundColor = [UIColor clearColor];
    self.zhiYeTF.returnKeyType = UIReturnKeyDone;
    self.zhiYeTF.delegate = self;
    [self.userInfoView1 addSubview:self.zhiYeTF];
    
    //用户收入
    self.shouRuTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(400), FitSizeW(270), FitSizeH(50)) placeholder:@"请填写月收入" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.shouRuTF.backgroundColor = [UIColor clearColor];
    self.shouRuTF.returnKeyType = UIReturnKeyDone;
    self.shouRuTF.delegate = self;
    self.shouRuTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.userInfoView1 addSubview:self.shouRuTF];
    
    //个人特征
    self.geRenTeZhengTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(450), FitSizeW(270), FitSizeH(50)) placeholder:@"请填写个人特征" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.geRenTeZhengTF.backgroundColor = [UIColor clearColor];
    self.geRenTeZhengTF.returnKeyType = UIReturnKeyDone;
    self.geRenTeZhengTF.delegate = self;
    [self.userInfoView1 addSubview:self.geRenTeZhengTF];
    
    //择偶标准
    self.zeOuBiaoZhunTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(500), FitSizeW(270), FitSizeH(50)) placeholder:@"请描述择偶标准" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.zeOuBiaoZhunTF.backgroundColor = [UIColor clearColor];
    self.zeOuBiaoZhunTF.returnKeyType = UIReturnKeyDone;
    self.zeOuBiaoZhunTF.delegate = self;
    [self.userInfoView1 addSubview:self.zeOuBiaoZhunTF];
    
    //个人简介
    self.introductionpTextView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.userInfoView1.frame), FitSizeW(345), FitSizeH(80))];
    self.introductionpTextView.layer.cornerRadius = 5;
    self.introductionpTextView.layer.masksToBounds = YES;
    self.introductionpTextView.backgroundColor = RGBA(245, 245, 245, 1.0);
    [self.introductionpTextView setFont:[UIFont systemFontOfSize:15]];
    self.introductionpTextView.delegate = self;
    [self.introductionpTextView setTextColor:RGBA(158, 158, 158, 1)];
    [self.mainScrollView addSubview:self.introductionpTextView];
    
    introductionpPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(FitSizeW(5), 0,  FitSizeW(324), FitSizeH(40))];
    introductionpPlaceholder.numberOfLines = 0;
    introductionpPlaceholder.backgroundColor = [UIColor clearColor];
    introductionpPlaceholder.textAlignment = NSTextAlignmentLeft;
    introductionpPlaceholder.font = [UIFont systemFontOfSize:15.f];
    introductionpPlaceholder.textColor = RGBA(158, 158, 158, 1);
    introductionpPlaceholder.text = @"请描述个人简介";
    [self.introductionpTextView addSubview:introductionpPlaceholder];
    
    //兴趣爱好
    UILabel * aihaoTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.introductionpTextView.frame), FitSizeW(200), FitSizeH(40)) Font:14 IsBold:NO Text:@"兴趣爱好" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:aihaoTextLabel];
    
    self.interestTextView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(aihaoTextLabel.frame), FitSizeW(345), FitSizeH(80))];
    self.interestTextView.layer.cornerRadius = 5;
    self.interestTextView.layer.masksToBounds = YES;
    self.interestTextView.backgroundColor = RGBA(245, 245, 245, 1.0);
    [self.interestTextView setFont:[UIFont systemFontOfSize:15]];
    self.interestTextView.delegate = self;
    [self.interestTextView setTextColor:RGBA(158, 158, 158, 1)];
    [self.mainScrollView addSubview:self.interestTextView];
    
    interestPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(FitSizeW(5), 0,  FitSizeW(324), FitSizeH(40))];
    interestPlaceholder.numberOfLines = 0;
    interestPlaceholder.backgroundColor = [UIColor clearColor];
    interestPlaceholder.textAlignment = NSTextAlignmentLeft;
    interestPlaceholder.font = [UIFont systemFontOfSize:15.f];
    interestPlaceholder.textColor = RGBA(158, 158, 158, 1);
    interestPlaceholder.text = @"请描述兴趣爱好";
    [self.interestTextView addSubview:interestPlaceholder];
    
    //内心独白
    UILabel * duBaiTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.interestTextView.frame), FitSizeW(200), FitSizeH(40)) Font:14 IsBold:NO Text:@"内心独白" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:duBaiTextLabel];
    
    self.monologueTextView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(duBaiTextLabel.frame), FitSizeW(345), FitSizeH(80))];
    self.monologueTextView.layer.cornerRadius = 5;
    self.monologueTextView.layer.masksToBounds = YES;
    self.monologueTextView.backgroundColor = RGBA(245, 245, 245, 1.0);
    [self.monologueTextView setFont:[UIFont systemFontOfSize:15]];
    self.monologueTextView.delegate = self;
    [self.monologueTextView setTextColor:RGBA(158, 158, 158, 1)];
    [self.mainScrollView addSubview:self.monologueTextView];
    
    monologuePlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(FitSizeW(5), 0,  FitSizeW(324), FitSizeH(40))];
    monologuePlaceholder.numberOfLines = 0;
    monologuePlaceholder.backgroundColor = [UIColor clearColor];
    monologuePlaceholder.textAlignment = NSTextAlignmentLeft;
    monologuePlaceholder.font = [UIFont systemFontOfSize:15.f];
    monologuePlaceholder.textColor = RGBA(158, 158, 158, 1);
    monologuePlaceholder.text = @"请描述内心独白";
    [self.monologueTextView addSubview:monologuePlaceholder];
    
    //提交自拍照片
    self.ziPaiTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.monologueTextView.frame), FitSizeW(200), FitSizeH(40)) Font:14 IsBold:NO Text:@"提交自拍照片" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:self.ziPaiTextLabel];
    
    if (![self.isEditStr isEqualToString:@"1"]) {
        HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
        photoView.frame = CGRectMake(FitSizeW(15), CGRectGetMaxY(self.ziPaiTextLabel.frame), SCREEN_WIDTH - FitSizeW(30) - kPhotoViewMargin * 4, 0);
        photoView.delegate = self;
        photoView.backgroundColor = [UIColor whiteColor];
        [self.mainScrollView addSubview:photoView];
        self.photoView = photoView;
        
    }else{
        self.downLoadPhotoView = [FlanceTools viewCreateWithFrame:CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame), SCREEN_WIDTH, FitSizeH(135)) BgColor:[UIColor whiteColor] BgImage:nil];
        [self.mainScrollView addSubview:self.downLoadPhotoView];
    }
    
    
    //社交账号
    
    //联系方式模块
    self.connectionView = [FlanceTools viewCreateWithFrame:CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135), SCREEN_WIDTH, FitSizeH(170)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.mainScrollView addSubview:self.connectionView];
    
    self.sheJiaoLineView1 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), 0, FitSizeW(345), FitSizeH(0.8)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
    [self.connectionView addSubview:self.sheJiaoLineView1];
    
    self.shejiaoTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.sheJiaoLineView1.frame) , FitSizeW(65), FitSizeH(50)) Font:14 IsBold:NO Text:@"联系方式" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.connectionView addSubview:self.shejiaoTextLabel];
    
    //用户年龄
    self.shejiaoTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), CGRectGetMaxY(self.sheJiaoLineView1.frame), FitSizeW(270), FitSizeH(50)) placeholder:@"请输入您的手机号码" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.shejiaoTF.backgroundColor = [UIColor clearColor];
    self.shejiaoTF.returnKeyType = UIReturnKeyDone;
    self.shejiaoTF.delegate = self;
    self.shejiaoTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.connectionView addSubview:self.shejiaoTF];
    
    self.sheJiaoLineView2 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.sheJiaoLineView1.frame) + FitSizeH(50), FitSizeW(345), FitSizeH(0.8)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
    [self.connectionView addSubview:self.sheJiaoLineView2];
    
    self.tishiTextView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.sheJiaoLineView2.frame) + FitSizeH(10), FitSizeW(345), FitSizeH(65))];
    self.tishiTextView.text = @"出于隐私保护考虑，请尽量输入您的社交账号配对者与您沟通用后可以看到您的联系方式，同时您的消息中心也会收到通知。";
    self.tishiTextView.userInteractionEnabled = NO;
    self.tishiTextView.backgroundColor = [UIColor whiteColor];
    [self.tishiTextView setFont:[UIFont systemFontOfSize:14]];
    [self.tishiTextView setTextColor:RGBA(80, 80, 80, 1)];
    [self.connectionView addSubview:self.tishiTextView];
    
    
    self.submitBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.tishiTextView.frame) + FitSizeH(20), FitSizeW(345), FitSizeH(44)) Title:@"限时免费发布" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_submitBtn:)];
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.connectionView addSubview:self.submitBtn];
    
    self.mainControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.mainControl];
    self.mainControl.backgroundColor = RGBA(1, 1, 1, 0.5);
    [self.mainControl addTarget:self action:@selector(click_cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    self.mainControl.hidden = YES;
    
    //学历Pickerview
    self.xueliBGView = [FlanceTools viewCreateWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, FitSizeH(240)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.xueliBGView];
    
    UIButton * cancelBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, 0, FitSizeW(60), FitSizeH(39)) Title:@"取消" Font:14 IsBold:NO TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(click_cancelBtn)];
    [self.xueliBGView addSubview:cancelBtn];
    
    UIButton * sureBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(60), 0, FitSizeW(60), FitSizeH(39)) Title:@"完成" Font:14 IsBold:NO TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(click_sureBtn)];
    [self.xueliBGView addSubview:sureBtn];
    
    self.xueLiPickerView = [[UIPickerView alloc] init] ;
    self.xueLiPickerView.frame = CGRectMake(0, FitSizeH(40), SCREEN_WIDTH, FitSizeH(200));
    self.xueLiPickerView.backgroundColor = RGBA(220, 220, 220, 1.0);
    self.xueLiPickerView.dataSource = self ;
    self.xueLiPickerView.delegate = self ;
    [self.xueliBGView addSubview:self.xueLiPickerView] ;
    
    self.keyboardControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.keyboardControl];
    self.keyboardControl.backgroundColor = RGBA(255, 255, 255, 0);
    [self.keyboardControl addTarget:self action:@selector(click_keyboardControl) forControlEvents:UIControlEventTouchUpInside];
    self.keyboardControl.hidden = YES;
}

- (void)textFieldDidChange:(id)sender
{
    if (self.userNameTF.text.length > 10) // MAXLENGTH为最大字数
    {
        //超出限制字数时所要做的事
        self.userNameTF.text = [self.userNameTF.text substringToIndex: 10]; // MAXLENGTH为最大字数
    }
}

- (void)click_keyboardControl
{
    self.keyboardControl.hidden = YES;
    [self.userNameTF resignFirstResponder];
    [self.ageTF resignFirstResponder];
    [self.shenGaoTF resignFirstResponder];
    [self.zhiYeTF resignFirstResponder];
    [self.shouRuTF resignFirstResponder];
    [self.geRenTeZhengTF resignFirstResponder];
    [self.zeOuBiaoZhunTF resignFirstResponder];
    [self.introductionpTextView resignFirstResponder];
    [self.interestTextView resignFirstResponder];
    [self.monologueTextView resignFirstResponder];
    [self.tishiTextView resignFirstResponder];
    [self.shejiaoTF resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.keyboardControl.hidden = NO;
    NSLog(@"开始编辑");
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.keyboardControl.hidden = YES;
    NSLog(@"结束编辑");
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.keyboardControl.hidden = NO;
    NSLog(@"开始编辑");
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    self.keyboardControl.hidden = YES;
    NSLog(@"结束编辑");
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


#pragma mark 点击键盘return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)click_xueLiBtn{
    [self KeyboardDown];
    currentXueliStr = @"不限";
    currentXueliIDStr = @"0";
    self.mainControl.hidden = NO;
    [UIView animateWithDuration:0.24 animations:^{
        self.xueliBGView.frame = CGRectMake(0, SCREEN_HEIGHT - FitSizeH(240), SCREEN_WIDTH, FitSizeH(240));
    }];
}

#pragma mark 选择性别
- (void)click_userSexBtn:(UIButton *)sender{
    [self KeyboardDown];
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
    [self KeyboardDown];
    CityViewController *controller = [[CityViewController alloc] init];
    controller.currentCityString = self->currentCityStr;
    controller.selectString = ^(NSString *string){
        self->currentSelectStr = string;
        
        [sender setTitle:[NSString stringWithFormat:@"%@",string] forState:UIControlStateNormal];
        [self.addressBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(235), 0, 0)];
    };
    [self presentViewController:controller animated:YES completion:nil];
}



- (void)click_cancelBtn
{
    [self KeyboardDown];
    self.mainControl.hidden = YES;
    [UIView animateWithDuration:0.24 animations:^{
        self.xueliBGView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, FitSizeH(240));
    }];
}

- (void)click_sureBtn
{
    [self KeyboardDown];
    self.mainControl.hidden = YES;
    [UIView animateWithDuration:0.24 animations:^{
        self.xueliBGView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, FitSizeH(240));
    }];
    [self.xueLiBtn setTitle:currentXueliStr forState:UIControlStateNormal];
    [self.xueLiBtn setImage:nil forState:UIControlStateNormal];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return xueLiPickerArr.count ;
}

//显示每组元素
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary * dic = xueLiPickerArr[row];
    NSString * str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    return str;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSDictionary * dic = xueLiPickerArr[row];
    NSString * str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    currentXueliIDStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    NSLog(@"%@",dic);
    currentXueliStr = str;
    
}

#pragma mark 婚姻状况
- (void)click_marriageType
{
    [self KeyboardDown];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择婚姻状况" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"未婚" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击未婚");
        hunYinIDStr = @"0";
        [self.hunYinBtn  setTitle:@"未婚" forState:UIControlStateNormal];
        [self.hunYinBtn setImage:nil forState:UIControlStateNormal];
        [self.hunYinBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(240), 0, 0)];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"离异" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击离异");
        hunYinIDStr = @"1";
        [self.hunYinBtn  setTitle:@"离异" forState:UIControlStateNormal];
        [self.hunYinBtn setImage:nil forState:UIControlStateNormal];
        [self.hunYinBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(240), 0, 0)];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"丧偶" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击丧偶");
        hunYinIDStr = @"2";
        [self.hunYinBtn  setTitle:@"丧偶" forState:UIControlStateNormal];
        [self.hunYinBtn setImage:nil forState:UIControlStateNormal];
        [self.hunYinBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(240), 0, 0)];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark textViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.introductionpTextView) {
        if (textView.text.length != 0) {
            introductionpPlaceholder.text = @"";
        }else{
            introductionpPlaceholder.text = @"请描述个人简介";
        }
    }else if (textView == self.interestTextView) {
        if (textView.text.length != 0) {
            interestPlaceholder.text = @"";
        }else{
            interestPlaceholder.text = @"请描述兴趣爱好";
        }
    }else if (textView == self.monologueTextView) {
        if (textView.text.length != 0) {
            monologuePlaceholder.text = @"";
        }else{
            monologuePlaceholder.text = @"请描述内心独白";
        }
    }
}

- (void)click_submitBtn:(UIButton *)sender
{
    [self KeyboardDown];
    
    if (self.introductionpTextView.text.length < 1) {
        [self showAlert:@"请描述个人简介"];
        return;
    }
    if (self.interestTextView.text.length < 1) {
        [self showAlert:@"请描述兴趣爱好"];
        return;
    }
    
    if (self.monologueTextView.text.length < 1) {
        [self showAlert:@"请描述内心独白"];
        return;
    }
    
    if (self.introductionpTextView.text.length > 50) {
        [self showAlert:@"个人简介描述过长"];
        return;
    }
    if (self.interestTextView.text.length  > 50) {
        [self showAlert:@"兴趣爱好描述过长"];
        return;
    }
    
    if (self.monologueTextView.text.length  > 50) {
        [self showAlert:@"内心独白描述过长"];
        return;
    }
    
    if (self.userNameTF.text.length < 1) {
        [self showAlert:@"请输入姓名"];
        return;
    }
    if (self.ageTF.text.length < 1) {
        [self showAlert:@"请输入年龄"];
        return;
    }
    if (self.shenGaoTF.text.length < 1) {
        [self showAlert:@"请填写身高"];
        return;
    }
    float shengaoFloat = [self.shenGaoTF.text floatValue];
    if (shengaoFloat > 250) {
        [self showAlert:@"请填写正确身高"];
        return;
    }
    if (self.zhiYeTF.text.length < 1) {
        [self showAlert:@"请填写职业"];
        return;
    }
    if (self.shouRuTF.text.length < 1) {
        [self showAlert:@"请填写月收入"];
        return;
    }
    if (self.geRenTeZhengTF.text.length < 1) {
        [self showAlert:@"请填写个人特征"];
        return;
    }
    if (self.zeOuBiaoZhunTF.text.length < 1) {
        [self showAlert:@"请描述择偶标准"];
        return;
    }
    if (currentXueliIDStr.length < 1) {
        [self showAlert:@"请选择学历"];
        return;
    }
    if (hunYinIDStr.length < 1) {
        [self showAlert:@"请选择婚姻状况"];
        return;
    }
    if (currentSelectStr.length < 1) {
        [self showAlert:@"请选择所在城市"];
        return;
    }
    if (![FlanceTools validateMobile:self.shejiaoTF.text]) {
        [self showAlert:@"请输入正确联系电话"];
        return;
    }
    
    
    if ([self.isEditStr isEqualToString:@"1"]) {
        if (downLoadPhotoArr.count == 0) {
            [self showAlert:@"请提交自拍照片"];
            return;
        }
        UIImage * image = downLoadPhotoArr[0];
        NSData * currentData = [self resetSizeOfImageData:image maxSize:400];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self upLoadCommunityimage:currentData];
    }else{
        if (photoImageArr.count == 0) {
            [self showAlert:@"请提交自拍照片"];
            return;
        }
        UIImage * image = photoImageArr[0];
        UIImage * yasuoImage = [AppTools scaleToSize:image size:CGSizeMake(image.size.width/2, image.size.height/2)];
        NSData * currentData = [self resetSizeOfImageData:yasuoImage maxSize:400];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self upLoadCommunityimage:currentData];
    }
}

- (void)upLoadCommunityimage:(NSData *)imageData
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSString *url=[NSString stringWithFormat:@"%@/index/Ajax/upload",RBDom];
    NSDictionary * parameters = @{@"token":tokenStr};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        /*
         *该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"---上传进度--- %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"```上传成功``` %@",responseObject);
        NSDictionary * dataDic = [responseObject objectForKey:@"data"];
        NSString * ImageUrl = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"url"]];
        [uploadImagePathArr addObject:ImageUrl];
        NSLog(@"uploadImagePathArr======--------====%@",uploadImagePathArr);
        if ([self.isEditStr isEqualToString:@"1"] ? uploadImagePathArr.count == downLoadPhotoArr.count : uploadImagePathArr.count == photoImageArr.count) {
            uploadImageAllPath =  [uploadImagePathArr componentsJoinedByString:@","];
            NSLog(@"uploadImageAllPath========---------========%@",uploadImageAllPath);
            
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            if ([self.isEditStr isEqualToString:@"1"]) {
                [self doLiveEdit:self.userNameTF.text province:@"" city:[NSString stringWithFormat:@"%@市",currentSelectStr] age:self.ageTF.text gender:currentSexStr declaration:self.geRenTeZhengTF.text standard:self.zeOuBiaoZhunTF.text personal_profile:self.introductionpTextView.text soliloquy:self.monologueTextView.text image:uploadImageAllPath social_account:self.shejiaoTF.text hobby:self.interestTextView.text education:currentXueliIDStr marital_status:hunYinIDStr height:self.shenGaoTF.text vocation:self.zhiYeTF.text monthly_income:self.shouRuTF.text];
            }else{
                [self doLiveCreate:self.userNameTF.text province:@"" city:[NSString stringWithFormat:@"%@市",currentSelectStr] age:self.ageTF.text gender:currentSexStr declaration:self.geRenTeZhengTF.text standard:self.zeOuBiaoZhunTF.text personal_profile:self.introductionpTextView.text soliloquy:self.monologueTextView.text image:uploadImageAllPath social_account:self.shejiaoTF.text hobby:self.interestTextView.text education:currentXueliIDStr marital_status:hunYinIDStr height:self.shenGaoTF.text vocation:self.zhiYeTF.text monthly_income:self.shouRuTF.text];
            }
            
            
        }else{
            if ([self.isEditStr isEqualToString:@"1"]) {
                for (int i = upLoadInt; i < downLoadPhotoArr.count; i ++) {
                    UIImage * image = downLoadPhotoArr[i];
                    NSData * currentData = [self resetSizeOfImageData:image maxSize:400];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self upLoadCommunityimage:currentData];
                    upLoadInt = upLoadInt + 1;
                }
            }else{
                for (int i = upLoadInt; i < photoImageArr.count; i ++) {
                    UIImage * image = photoImageArr[i];
                    UIImage * yasuoImage = [AppTools scaleToSize:image size:CGSizeMake(image.size.width/2, image.size.height/2)];
                    NSData * currentData = [self resetSizeOfImageData:yasuoImage maxSize:400];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self upLoadCommunityimage:currentData];
                    upLoadInt = upLoadInt + 1;
                }

            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"xxx上传失败xxx %@", error);
        
    }];
}


#pragma mark 发布婚恋
- (void)doLiveCreate:(NSString *)name province:(NSString *)province city:(NSString *)city age:(NSString *)age gender:(NSString *)gender declaration:(NSString *)declaration standard:(NSString *)standard personal_profile:(NSString *)personal_profile soliloquy:(NSString *)soliloquy image:(NSString *)image social_account:(NSString *)social_account hobby:(NSString *)hobby education:(NSString *)education marital_status:(NSString *)marital_status height:(NSString *)height vocation:(NSString *)vocation monthly_income:(NSString *)monthly_income
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",LiveCreate];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"name":name,@"province":province,@"city":city,@"age":age,@"gender":gender,@"declaration":declaration,@"standard":standard,@"personal_profile":personal_profile,@"soliloquy":soliloquy,@"image":image,@"social_account":social_account,@"hobby":hobby,@"education":education,@"marital_status":marital_status,@"height":height,@"vocation":vocation,@"monthly_income":monthly_income};
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


#pragma mark 编辑婚恋
- (void)doLiveEdit:(NSString *)name province:(NSString *)province city:(NSString *)city age:(NSString *)age gender:(NSString *)gender declaration:(NSString *)declaration standard:(NSString *)standard personal_profile:(NSString *)personal_profile soliloquy:(NSString *)soliloquy image:(NSString *)image social_account:(NSString *)social_account hobby:(NSString *)hobby education:(NSString *)education marital_status:(NSString *)marital_status height:(NSString *)height vocation:(NSString *)vocation monthly_income:(NSString *)monthly_income
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",LiveEdit];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"name":name,@"province":province,@"city":city,@"age":age,@"gender":gender,@"declaration":declaration,@"standard":standard,@"personal_profile":personal_profile,@"soliloquy":soliloquy,@"image":image,@"social_account":social_account,@"hobby":hobby,@"education":education,@"marital_status":marital_status,@"height":height,@"vocation":vocation,@"monthly_income":monthly_income,@"id":self.idStr};
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

#pragma mark 获取婚恋详情
- (void)doGetLiveDetails
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",LiveDetails];
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
            self.userNameTF.text = nameStr;
            
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
            
            //城市
            [self.addressBtn setTitle:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"city"]] forState:UIControlStateNormal];
            [self.addressBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(235), 0, 0)];
            
            //年龄
            self.ageTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"age"]];
            
            //学历
            [self.xueLiBtn setTitle:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"education_name"]] forState:UIControlStateNormal];
            self->currentXueliIDStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"education"]];
            
            //婚姻状况
            [self.hunYinBtn setTitle:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"marital_status_name"]] forState:UIControlStateNormal];
            self->hunYinIDStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"marital_status"]];
            
            //身高
            self.shenGaoTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"height"]];
            
            //职业
            self.zhiYeTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"vocation"]];
            
            //职业
            self.shouRuTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"monthly_income"]];
            
            //交友宣言
            self.geRenTeZhengTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"declaration"]];
            
            //择偶标准
            self.zeOuBiaoZhunTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"standard"]];
            
            introductionpPlaceholder.text = @"";
            
            interestPlaceholder.text = @"";
            
            monologuePlaceholder.text = @"";
            
            //个人简介
            self.introductionpTextView.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"personal_profile"]];
            
            //兴趣爱好
            self.interestTextView.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"hobby"]];
            
            //内心独白
            self.monologueTextView.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"soliloquy"]];
            
            self.shejiaoTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"social_account"]];
            
            //自拍照片
            NSString * imageStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"image"]];
            NSArray *imageArr = [imageStr componentsSeparatedByString:@","];
            CGFloat w = FitSizeW(15);
            CGFloat h = FitSizeH(15);
            for (int i = 0; i < imageArr.count; i ++) {
                NSString * photoPath = [NSString stringWithFormat:@"%@%@",RBDom,imageArr[i]];
                UIImageView * photoImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(w, h, FitSizeW(105), FitSizeH(105)) ImageName:@"jiazai"];
                [self.downLoadPhotoView addSubview:photoImageView];
                photoImageView.tag = 3000 + i;
                photoImageView.layer.masksToBounds = YES;
                photoImageView.layer.cornerRadius = 3;
                photoImageView.contentMode = UIViewContentModeScaleAspectFill;
                [photoImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
                
                [photoImageView sd_setImageWithURL:[NSURL URLWithString:photoPath] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    [downLoadPhotoArr addObject:image];
                }];
                
                w = w + FitSizeW(15) + FitSizeW(105);
                
                if (w >= SCREEN_WIDTH) {
                    w = FitSizeW(15);
                    h = h + FitSizeH(105) + FitSizeH(15);
                }
                
                UIButton * deleteBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(CGRectGetMaxX(photoImageView.frame) - FitSizeW(24), CGRectGetMinY(photoImageView.frame), FitSizeW(24), FitSizeW(24)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"photo_delete" Target:self Action:@selector(click_deletePhoto:)];
                deleteBtn.tag = 4000 + i;
                [self.downLoadPhotoView addSubview:deleteBtn];
                
                if (imageArr.count < 5) {
                    UIButton * addPhotoBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(w , h, FitSizeW(105), FitSizeH(105)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:nil Target:self Action:@selector(click_addPhotoBt)];
                    [addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"shangchuanzahop"] forState:UIControlStateNormal];
                    [self.downLoadPhotoView addSubview:addPhotoBtn];
                }
            }
            
            
            if (imageArr.count <= 2) {
                self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1550));
                [UIView animateWithDuration:0.24 animations:^{
                    self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135), SCREEN_WIDTH, FitSizeH(170));
                }];
            }else if (imageArr.count > 2 && imageArr.count <= 5){
                self.downLoadPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame), SCREEN_WIDTH, FitSizeH(135)* 2);
                self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1685));
                [UIView animateWithDuration:0.24 animations:^{
                    self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135)* 2, SCREEN_WIDTH, FitSizeH(170));
                }];
            }else{
                self.downLoadPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame), SCREEN_WIDTH, FitSizeH(135)* 3);
                self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1820));
                [UIView animateWithDuration:0.24 animations:^{
                    self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135)* 3, SCREEN_WIDTH, FitSizeH(170));
                }];
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

- (void)click_deletePhoto:(UIButton *)sender
{
    NSInteger index = sender.tag - 4000;
    
    NSLog(@"downLoadPhotoArr=======%@",downLoadPhotoArr);
    
    [self.downLoadPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [downLoadPhotoArr removeObjectAtIndex:index];
    
    if (downLoadPhotoArr.count == 0) {
        UIButton * addPhotoBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(15) , FitSizeH(15), FitSizeW(105), FitSizeH(105)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:nil Target:self Action:@selector(click_addPhotoBt)];
        [addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"shangchuanzahop"] forState:UIControlStateNormal];
        [self.downLoadPhotoView addSubview:addPhotoBtn];
    }
    
    CGFloat w = FitSizeW(15);
    CGFloat h = FitSizeH(15);
    for (int i = 0; i < downLoadPhotoArr.count; i ++) {
        
        UIImageView * photoImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(w, h, FitSizeW(105), FitSizeH(105)) ImageName:nil];
        [self.downLoadPhotoView addSubview:photoImageView];
        [photoImageView setImage:downLoadPhotoArr[i]];
        photoImageView.tag = 3000 + i;
        photoImageView.layer.masksToBounds = YES;
        photoImageView.layer.cornerRadius = 3;
        photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [photoImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        
        w = w + FitSizeW(15) + FitSizeW(105);
        
        if (w >= SCREEN_WIDTH) {
            w = FitSizeW(15);
            h = h + FitSizeH(105) + FitSizeH(15);
        }
        
        UIButton * deleteBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(CGRectGetMaxX(photoImageView.frame) - FitSizeW(24), CGRectGetMinY(photoImageView.frame), FitSizeW(24), FitSizeW(24)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"photo_delete" Target:self Action:@selector(click_deletePhoto:)];
        deleteBtn.tag = 4000 + i;
        [self.downLoadPhotoView addSubview:deleteBtn];
        
        if (downLoadPhotoArr.count < 5) {
            UIButton * addPhotoBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(w , h, FitSizeW(105), FitSizeH(105)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:nil Target:self Action:@selector(click_addPhotoBt)];
            [addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"shangchuanzahop"] forState:UIControlStateNormal];
            [self.downLoadPhotoView addSubview:addPhotoBtn];
        }
    }
    
    if (downLoadPhotoArr.count <= 2) {
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1550));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135), SCREEN_WIDTH, FitSizeH(170));
        }];
    }else if (downLoadPhotoArr.count > 2 && downLoadPhotoArr.count <= 5){
        self.downLoadPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame), SCREEN_WIDTH, FitSizeH(135)* 2);
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1685));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135)* 2, SCREEN_WIDTH, FitSizeH(170));
        }];
    }else{
        self.downLoadPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame), SCREEN_WIDTH, FitSizeH(135)* 3);
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1820));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135)* 3, SCREEN_WIDTH, FitSizeH(170));
        }];
    }
}

- (void)click_addPhotoBt{
    UIActionSheet * imageSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"从相册中选取", @"拍照", nil];
    [imageSheet showInView:KEY_WINDOW];
}

#pragma mark UIActionSheetDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if (0 == buttonIndex) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            __weak typeof(self) weakSelf = self;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakSelf presentViewController:self->imagePicker animated:YES completion:nil];
            }];
        }
    } else if (1 == buttonIndex) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.allowsEditing = YES;
            imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            __weak typeof(self) weakSelf = self;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakSelf presentViewController:self->imagePicker animated:YES completion:nil];
            }];
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [downLoadPhotoArr addObject:image];
    
    [self.downLoadPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    CGFloat w = FitSizeW(15);
    CGFloat h = FitSizeH(15);
    for (int i = 0; i < downLoadPhotoArr.count; i ++) {
        
        UIImageView * photoImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(w, h, FitSizeW(105), FitSizeH(105)) ImageName:nil];
        [self.downLoadPhotoView addSubview:photoImageView];
        [photoImageView setImage:downLoadPhotoArr[i]];
        photoImageView.tag = 3000 + i;
        photoImageView.layer.masksToBounds = YES;
        photoImageView.layer.cornerRadius = 3;
        photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [photoImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        
        w = w + FitSizeW(15) + FitSizeW(105);
        
        if (w >= SCREEN_WIDTH) {
            w = FitSizeW(15);
            h = h + FitSizeH(105) + FitSizeH(15);
        }
        
        UIButton * deleteBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(CGRectGetMaxX(photoImageView.frame) - FitSizeW(24), CGRectGetMinY(photoImageView.frame), FitSizeW(24), FitSizeW(24)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"photo_delete" Target:self Action:@selector(click_deletePhoto:)];
        deleteBtn.tag = 4000 + i;
        [self.downLoadPhotoView addSubview:deleteBtn];
        
        if (downLoadPhotoArr.count < 5) {
            UIButton * addPhotoBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(w , h, FitSizeW(105), FitSizeH(105)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:nil Target:self Action:@selector(click_addPhotoBt)];
            [addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"shangchuanzahop"] forState:UIControlStateNormal];
            [self.downLoadPhotoView addSubview:addPhotoBtn];
        }
    }
    
    if (downLoadPhotoArr.count <= 2) {
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1550));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135), SCREEN_WIDTH, FitSizeH(170));
        }];
    }else if (downLoadPhotoArr.count > 2 && downLoadPhotoArr.count <= 5){
        self.downLoadPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame), SCREEN_WIDTH, FitSizeH(135)* 2);
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1685));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135)* 2, SCREEN_WIDTH, FitSizeH(170));
        }];
    }else{
        self.downLoadPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame), SCREEN_WIDTH, FitSizeH(135)* 3);
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1820));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135)* 3, SCREEN_WIDTH, FitSizeH(170));
        }];
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
    NSDictionary *parameters = @{@"token":tokenStr,@"total_fee":total_fee,@"type":@"live",@"type_id":type_id,@"channel":@"2"};
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
                navc.FaBuHunLianVC = self;
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


#pragma mark 查询次数
- (void)dogGetUserIndex
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserIndex];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"type":@"live"};
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

#pragma mark - 压缩图片
- (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize {
    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(sourceImage,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;
    
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    //获取原图片宽高比
    CGFloat sourceImageAspectRatio = sourceImage.size.width/sourceImage.size.height;
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024/sourceImageAspectRatio);
    UIImage *newImage = [self newSizeImage:defaultSize image:sourceImage];
    
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    
    //保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    /*
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
     */
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        CGFloat reduceWidth = 100.0;
        CGFloat reduceHeight = 100.0/sourceImageAspectRatio;
        if (defaultSize.width-reduceWidth <= 0 || defaultSize.height-reduceHeight <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-reduceWidth, defaultSize.height-reduceHeight);
        UIImage *image = [self newSizeImage:defaultSize
                                      image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage,[[compressionQualityArr lastObject] floatValue])]];
        finallImageData = [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
    }
    return finallImageData;
}
#pragma mark 调整图片分辨率/尺寸（等比例缩放）
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark 二分法
- (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize {
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        NSLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        NSLog(@"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf", start, end, (unsigned long)index, [arr[index] floatValue]);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return tempData;
}


#pragma mark - ---------------------  照片处理 -----------------------------
- (void)photoView:(HXPhotoView *)photoView imageChangeComplete:(NSArray<UIImage *> *)imageList {
    NSSLog(@"%@",imageList);
    photoImageArr = [NSArray array];
    photoImageArr = imageList;
    //    self.photos = [NSMutableArray arrayWithArray:imageList];
    if (imageList.count <= 2) {
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1550));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135), SCREEN_WIDTH, FitSizeH(170));
        }];
    }else if (imageList.count > 2 && imageList.count <= 5){
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1670));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135)* 2, SCREEN_WIDTH, FitSizeH(170));
        }];
    }else{
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1790));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.ziPaiTextLabel.frame) + FitSizeH(135)* 3, SCREEN_WIDTH, FitSizeH(170));
        }];
    }
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
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
