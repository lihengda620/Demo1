//
//  FaBuBuySellViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/28.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "FaBuBuySellViewController.h"
static const CGFloat kPhotoViewMargin = 12.0;

@interface FaBuBuySellViewController ()<UIScrollViewDelegate,UITextViewDelegate,HXPhotoViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView * photoView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIScrollView * mainScrollView;
@property (nonatomic, strong) UIView * infoView;

//商品名称
@property (nonatomic, strong) UITextField * nameTF;

//价格
@property (nonatomic, strong) UITextField * priceTF;

//商品特征
@property (nonatomic, strong) UITextField * tezhengTF;
@property (nonatomic, strong) UIButton * tezhengBtn;

//交易方式
@property (nonatomic, strong) UIButton * jiaoyiTypeBtn;

//商品信息
@property (nonatomic, strong) UITextField * shangPinInfoTF;


//联系电话
@property (nonatomic, strong) UIView * connectionView;
@property (nonatomic, strong) UIView * sheJiaoLineView1;
@property (nonatomic, strong) UILabel * shejiaoTextLabel;
@property (nonatomic, strong) UITextField * shejiaoTF;
@property (nonatomic, strong) UIView * sheJiaoLineView2;
@property (nonatomic, strong) UITextView * tishiTextView;

@property (nonatomic, strong) UIButton * submitBtn;

@property (nonatomic, strong) UIView * downLoadPhotoView;

@property (nonatomic, strong) UIControl * keyboardControl;
@end

@implementation FaBuBuySellViewController{
    NSString * deal_typeStr;
    NSString * featureStr;
    NSArray * photoImageArr;
    NSMutableArray * uploadImagePathArr;
    NSString * uploadImageAllPath;
    
    NSDictionary * categoryDic;
    
    NSMutableArray * downLoadPhotoArr;
    
    UIImagePickerController *imagePicker;
    
    int upLoadInt;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    uploadImagePathArr = [NSMutableArray array];
    downLoadPhotoArr = [NSMutableArray array];
    deal_typeStr = @"";
    featureStr = @"";
    upLoadInt = 1;
    [self initNavigationView];
    [self initView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dogGetUserIndex];
    
    if ([self.isEditStr isEqualToString:@"1"]) {
        [self doGetGoodsDetails];
    }
}

-(void)KeyboardDown
{
    [self.nameTF resignFirstResponder];
    [self.priceTF resignFirstResponder];
    [self.tezhengTF resignFirstResponder];
    [self.shangPinInfoTF resignFirstResponder];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=NO;
}


- (void)getRootViewwController{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), 0, FitSizeW(200), FitSizeH(38)) Font:17.0f IsBold:YES Text:@"新建一条买卖信息..." Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview: self.titleLabel];
    
    //信息模块
    self.infoView = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(38), SCREEN_WIDTH, FitSizeH(50) * 6) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.mainScrollView addSubview:self.infoView];
    
    NSArray * userTextArr = @[@"商品名称",@"价格",@"商品特征",@"交易方式",@"商品信息",@"提交商品图片"];
    for (int i = 0; i < userTextArr.count; i ++) {
        UILabel * userInfoTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(50) * i, FitSizeW(65), FitSizeH(50)) Font:14 IsBold:NO Text:userTextArr[i] Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
        [self.infoView addSubview:userInfoTextLabel];
        
        if (i != userTextArr.count - 1) {
            
            UIView * lineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), i * FitSizeH(50) + FitSizeH(50), FitSizeW(345), FitSizeH(0.5)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
            [self.infoView addSubview:lineView];
        }else{
            userInfoTextLabel.frame = CGRectMake(FitSizeW(15), FitSizeH(50) * i, FitSizeW(100), FitSizeH(50));
        }
    }
    
    //房源名称
    self.nameTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), 0, FitSizeW(270), FitSizeH(50)) placeholder:@"请输入商品名称" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.nameTF.backgroundColor = [UIColor clearColor];
    self.nameTF.returnKeyType = UIReturnKeyDone;
    self.nameTF.delegate = self;
    [self.infoView addSubview:self.nameTF];
    [self.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //价格
    self.priceTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(50), FitSizeW(270), FitSizeH(50)) placeholder:@"请输入价格" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.priceTF.backgroundColor = [UIColor clearColor];
    self.priceTF.returnKeyType = UIReturnKeyDone;
    self.priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.priceTF.delegate = self;
    [self.infoView addSubview:self.priceTF];
    
    //商品特征
    self.tezhengBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(90), FitSizeH(100), FitSizeW(270), FitSizeH(50)) Title:@"请选择商品特征" Font:14 IsBold:NO TitleColor:RGBA(150, 150, 150, 1.0) TitleSelectColor:RGBA(150, 150, 150, 1.0) ImageName:@"tanchu" Target:self Action:@selector(click_CommodityCharacteristics)];
    [self.tezhengBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(200), 0, 0)];
    [self.tezhengBtn setImageEdgeInsets:UIEdgeInsetsMake(0, FitSizeW(250), 0, 0)];
    [self.infoView addSubview:self.tezhengBtn];
    
    //交易方式
    self.jiaoyiTypeBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(90), FitSizeH(150), FitSizeW(270), FitSizeH(50)) Title:@"请选择交易方式" Font:14 IsBold:NO TitleColor:RGBA(150, 150, 150, 1.0) TitleSelectColor:RGBA(150, 150, 150, 1.0) ImageName:@"tanchu" Target:self Action:@selector(click_tradingType)];
    [self.jiaoyiTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(200), 0, 0)];
    [self.jiaoyiTypeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, FitSizeW(250), 0, 0)];
    [self.infoView addSubview:self.jiaoyiTypeBtn];
    
    //商品信息
    self.shangPinInfoTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), FitSizeH(200), FitSizeW(270), FitSizeH(50)) placeholder:@"请填写商品信息" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.shangPinInfoTF.backgroundColor = [UIColor clearColor];
    self.shangPinInfoTF.returnKeyType = UIReturnKeyDone;
    self.shangPinInfoTF.delegate = self;
    [self.infoView addSubview:self.shangPinInfoTF];
    
    if (![self.isEditStr isEqualToString:@"1"]) {
        HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
        photoView.frame = CGRectMake(FitSizeW(15), CGRectGetMaxY(self.infoView.frame), SCREEN_WIDTH - FitSizeW(30) - kPhotoViewMargin * 4, 0);
        photoView.delegate = self;
        photoView.backgroundColor = [UIColor whiteColor];
        [self.mainScrollView addSubview:photoView];
        self.photoView = photoView;
        
    }else{
        self.downLoadPhotoView = [FlanceTools viewCreateWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoView.frame), SCREEN_WIDTH, FitSizeH(135)) BgColor:[UIColor whiteColor] BgImage:nil];
        [self.mainScrollView addSubview:self.downLoadPhotoView];
    }
    
    //联系方式模块
    self.connectionView = [FlanceTools viewCreateWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(135), SCREEN_WIDTH, FitSizeH(170)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.mainScrollView addSubview:self.connectionView];
    
    //社交账号
    self.sheJiaoLineView1 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), 0, FitSizeW(345), FitSizeH(0.8)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
    [self.connectionView addSubview:self.sheJiaoLineView1];
    
    self.shejiaoTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.sheJiaoLineView1.frame) , FitSizeW(65), FitSizeH(50)) Font:14 IsBold:NO Text:@"联系电话" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.connectionView addSubview:self.shejiaoTextLabel];
    
    //联系电话
    self.shejiaoTF = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(90), CGRectGetMaxY(self.sheJiaoLineView1.frame), FitSizeW(270), FitSizeH(50)) placeholder:@"请输入您的联系电话" passWord:NO leftImageView:nil rightImageView:nil Font:14.0 backgRoundImageName:nil];
    self.shejiaoTF.backgroundColor = [UIColor clearColor];
    self.shejiaoTF.returnKeyType = UIReturnKeyDone;
    self.shejiaoTF.keyboardType = UIKeyboardTypeNumberPad;
    self.shejiaoTF.delegate = self;
    [self.connectionView addSubview:self.shejiaoTF];
    
    self.sheJiaoLineView2 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.sheJiaoLineView1.frame) + FitSizeH(50), FitSizeW(345), FitSizeH(0.8)) BgColor:RGBA(230, 230, 230, 1.0) BgImage:nil];
    [self.connectionView addSubview:self.sheJiaoLineView2];
    
    self.tishiTextView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.sheJiaoLineView2.frame) + FitSizeH(10), FitSizeW(345), FitSizeH(45))];
    self.tishiTextView.text = @"消费者与您沟通后可以看到您的联系方式，同时您的消息中心也会收到通知.";
    self.tishiTextView.userInteractionEnabled = NO;
    self.tishiTextView.backgroundColor = [UIColor whiteColor];
    [self.tishiTextView setFont:[UIFont systemFontOfSize:14]];
    [self.tishiTextView setTextColor:RGBA(80, 80, 80, 1)];
    [self.connectionView addSubview:self.tishiTextView];
    
    
    self.submitBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.tishiTextView.frame) + FitSizeH(20), FitSizeW(345), FitSizeH(44)) Title:@"发布信息200元/条" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_submitBtn:)];
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.connectionView addSubview:self.submitBtn];
    
    self.keyboardControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.keyboardControl];
    self.keyboardControl.backgroundColor = RGBA(255, 255, 255, 0);
    [self.keyboardControl addTarget:self action:@selector(click_keyboardControl) forControlEvents:UIControlEventTouchUpInside];
    self.keyboardControl.hidden = YES;
}

- (void)textFieldDidChange:(id)sender
{
    if (self.nameTF.text.length > 10) // MAXLENGTH为最大字数
    {
        //超出限制字数时所要做的事
        self.nameTF.text = [self.nameTF.text substringToIndex: 10]; // MAXLENGTH为最大字数
    }
}

- (void)click_keyboardControl
{
    self.keyboardControl.hidden = YES;
    [self.nameTF resignFirstResponder];
    [self.priceTF resignFirstResponder];
    [self.tezhengTF resignFirstResponder];
    [self.shangPinInfoTF resignFirstResponder];
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

- (void)click_submitBtn:(UIButton *)sender
{
    [self KeyboardDown];
    if (self.nameTF.text.length < 1) {
        [self showAlert:@"请输入商品名称"];
        return;
    }
    if (self.priceTF.text.length < 1) {
        [self showAlert:@"请输入价格"];
        return;
    }
    
    if (featureStr.length < 1) {
        [self showAlert:@"请选择商品特征"];
        return;
    }
    if (deal_typeStr.length < 1) {
        [self showAlert:@"请选择交易方式"];
        return;
    }
    if (self.shangPinInfoTF.text.length < 1) {
        [self showAlert:@"请填写商品信息"];
        return;
    }
    if (![FlanceTools validateMobile:self.shejiaoTF.text]) {
        [self showAlert:@"请输入正确联系电话"];
        return;
    }
    
    
    if ([self.isEditStr isEqualToString:@"1"]) {
        if (downLoadPhotoArr.count == 0) {
            [self showAlert:@"请提交商品照片"];
            return;
        }
        UIImage * image = downLoadPhotoArr[0];
        NSData * currentData = [self resetSizeOfImageData:image maxSize:400];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self upLoadCommunityimage:currentData];
    }else{
        if (photoImageArr.count == 0) {
            [self showAlert:@"请提交商品照片"];
            return;
        }
        UIImage * image = photoImageArr[0];
        UIImage * yasuoImage = [AppTools scaleToSize:image size:CGSizeMake(image.size.width/2, image.size.height/2)];
        NSData * currentData = [self resetSizeOfImageData:yasuoImage maxSize:400];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self upLoadCommunityimage:currentData];
    }
}

#pragma mark 选择商品特征
- (void)click_CommodityCharacteristics{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择商品特征" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"7成新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击7成新");
        featureStr = @"7成新";
        [self.tezhengBtn setTitle:@"7成新" forState:UIControlStateNormal];
        [self.tezhengBtn setImage:nil forState:UIControlStateNormal];
        [self.tezhengBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(230), 0, 0)];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"8成新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击8成新");
        featureStr = @"8成新";
        [self.tezhengBtn setTitle:@"8成新" forState:UIControlStateNormal];
        [self.tezhengBtn setImage:nil forState:UIControlStateNormal];
        [self.tezhengBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(230), 0, 0)];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"9成新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击9成新");
        featureStr = @"9成新";
        [self.tezhengBtn setTitle:@"9成新" forState:UIControlStateNormal];
        [self.tezhengBtn setImage:nil forState:UIControlStateNormal];
        [self.tezhengBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(230), 0, 0)];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"99成新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击99成新");
        featureStr = @"99成新";
        [self.tezhengBtn setTitle:@"99成新" forState:UIControlStateNormal];
        [self.tezhengBtn setImage:nil forState:UIControlStateNormal];
        [self.tezhengBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(225), 0, 0)];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"全新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击全新");
        featureStr = @"全新";
        [self.tezhengBtn setTitle:@"全新" forState:UIControlStateNormal];
        [self.tezhengBtn setImage:nil forState:UIControlStateNormal];
        [self.tezhengBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(240), 0, 0)];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 选择交易方式
- (void)click_tradingType{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择交易方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"同城面交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击同城面交");
        deal_typeStr = @"1";
        [self.jiaoyiTypeBtn setTitle:@"同城面交" forState:UIControlStateNormal];
        [self.jiaoyiTypeBtn setImage:nil forState:UIControlStateNormal];
        [self.jiaoyiTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(215), 0, 0)];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"邮寄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击邮寄");
        deal_typeStr = @"2";
        [self.jiaoyiTypeBtn setTitle:@"邮寄" forState:UIControlStateNormal];
        [self.jiaoyiTypeBtn setImage:nil forState:UIControlStateNormal];
        [self.jiaoyiTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(235), 0, 0)];
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 点击键盘return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 查询次数
- (void)dogGetUserIndex
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserIndex];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"type":@"goods"};
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
        NSLog(@"```上传成功``` %@",responseObject);
        NSDictionary * dataDic = [responseObject objectForKey:@"data"];
        NSString * ImageUrl = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"url"]];
        [uploadImagePathArr addObject:ImageUrl];
        NSLog(@"uploadImagePathArr======--------====%@",uploadImagePathArr);
        if ([self.isEditStr isEqualToString:@"1"] ? uploadImagePathArr.count == downLoadPhotoArr.count : uploadImagePathArr.count == photoImageArr.count) {
            uploadImageAllPath =  [uploadImagePathArr componentsJoinedByString:@","];
            NSLog(@"uploadImageAllPath========---------========%@",uploadImageAllPath);
            
            NSUserDefaults *userDefaultes = LDUserDefaults;
            NSString * currentCityStr = [NSString stringWithFormat:@"%@",[userDefaultes stringForKey:@"currentCityStr"]];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if ([self.isEditStr isEqualToString:@"1"]) {
                [self doGoodsEdit:self.nameTF.text feature:self->featureStr price:self.priceTF.text deal_type:self->deal_typeStr details:self.shangPinInfoTF.text image:uploadImageAllPath mobile:self.shejiaoTF.text city:currentCityStr];
            }else{
                [self doGoodsCreate:self.nameTF.text feature:self->featureStr price:self.priceTF.text deal_type:self->deal_typeStr details:self.shangPinInfoTF.text image:uploadImageAllPath mobile:self.shejiaoTF.text city:currentCityStr];
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

#pragma mark 创建订单
- (void)doOrderCreate:(NSString *)total_fee type_id:(NSString *)type_id
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",OrderCreate];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"total_fee":total_fee,@"type":@"goods",@"type_id":type_id,@"channel":@"2"};
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
                navc.FaBuBuySellVC = self;
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

#pragma mark 发布买卖
- (void)doGoodsCreate:(NSString *)name feature:(NSString *)feature price:(NSString *)price deal_type:(NSString *)deal_type details:(NSString *)details image:(NSString *)image mobile:(NSString *)mobile city:(NSString *)city
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",GoodsCreate];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"name":name,@"feature":feature,@"price":price,@"deal_type":deal_type,@"details":details,@"image":image,@"mobile":mobile,@"city":city};
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

#pragma mark 编辑买卖
- (void)doGoodsEdit:(NSString *)name feature:(NSString *)feature price:(NSString *)price deal_type:(NSString *)deal_type details:(NSString *)details image:(NSString *)image mobile:(NSString *)mobile city:(NSString *)city
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",GoodsEdit];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"name":name,@"feature":feature,@"price":price,@"deal_type":deal_type,@"details":details,@"image":image,@"mobile":mobile,@"city":city,@"id":self.idStr};
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

#pragma mark 获取商品详情
- (void)doGetGoodsDetails
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",GoodsDetails];
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
            
            //价格
            NSString * salaryStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"price"]];
            self.priceTF.text = salaryStr;
            
            //特征
            featureStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"feature"]];
            [self.tezhengBtn setTitle:featureStr forState:UIControlStateNormal];
            [self.tezhengBtn setImage:nil forState:UIControlStateNormal];
            [self.tezhengBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(230), 0, 0)];
            
            //交易方式
            deal_typeStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"deal_type"]];
            if ([deal_typeStr isEqualToString:@"1"]) {
                [self.jiaoyiTypeBtn setTitle:@"同城面交" forState:UIControlStateNormal];
                [self.jiaoyiTypeBtn setImage:nil forState:UIControlStateNormal];
                [self.jiaoyiTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(215), 0, 0)];
            }else{
                [self.jiaoyiTypeBtn setTitle:@"邮寄" forState:UIControlStateNormal];
                [self.jiaoyiTypeBtn setImage:nil forState:UIControlStateNormal];
                [self.jiaoyiTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -FitSizeW(235), 0, 0)];
            }
            
            //商品信息
            NSString * detailsStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"details"]];
            self.shangPinInfoTF.text = detailsStr;
            
            self.shejiaoTF.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"mobile"]];
            
            //房屋照片
            NSString * imageStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"image"]];
            NSArray *imageArr = [imageStr componentsSeparatedByString:@","];
            CGFloat w = FitSizeW(15);
            CGFloat h = FitSizeH(15);
            for (int i = 0; i < imageArr.count; i ++) {
                NSString * photoPath = [NSString stringWithFormat:@"%@%@",RBDom,imageArr[i]];
                UIImageView * photoImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(w, h, FitSizeW(105), FitSizeH(105)) ImageName:nil];
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
                self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(750));
                [UIView animateWithDuration:0.24 animations:^{
                    self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(135), SCREEN_WIDTH, FitSizeH(170));
                }];
            }else if (imageArr.count > 2 && imageArr.count <= 5){
                self.downLoadPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame), SCREEN_WIDTH, FitSizeH(135)* 2);
                self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(885));
                [UIView animateWithDuration:0.24 animations:^{
                    self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(135)* 2, SCREEN_WIDTH, FitSizeH(170));
                }];
            }else{
                self.downLoadPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame), SCREEN_WIDTH, FitSizeH(135)* 3);
                self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1020));
                [UIView animateWithDuration:0.24 animations:^{
                    self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(135)* 3, SCREEN_WIDTH, FitSizeH(170));
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
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(750));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(135), SCREEN_WIDTH, FitSizeH(170));
        }];
    }else if (downLoadPhotoArr.count > 2 && downLoadPhotoArr.count <= 5){
        self.downLoadPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame), SCREEN_WIDTH, FitSizeH(135)* 2);
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(885));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(135)* 2, SCREEN_WIDTH, FitSizeH(170));
        }];
    }else{
        self.downLoadPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame), SCREEN_WIDTH, FitSizeH(135)* 3);
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1020));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(135)* 3, SCREEN_WIDTH, FitSizeH(170));
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
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(750));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(135), SCREEN_WIDTH, FitSizeH(170));
        }];
    }else if (downLoadPhotoArr.count > 2 && downLoadPhotoArr.count <= 5){
        self.downLoadPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame), SCREEN_WIDTH, FitSizeH(135)* 2);
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(885));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(135)* 2, SCREEN_WIDTH, FitSizeH(170));
        }];
    }else{
        self.downLoadPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame), SCREEN_WIDTH, FitSizeH(135)* 3);
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1020));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(135)* 3, SCREEN_WIDTH, FitSizeH(170));
        }];
    }
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

#pragma mark - ---------------------  照片处理 -----------------------------
- (void)photoView:(HXPhotoView *)photoView imageChangeComplete:(NSArray<UIImage *> *)imageList {
    NSSLog(@"%@",imageList);
    photoImageArr = [NSArray array];
    photoImageArr = imageList;
    //    self.photos = [NSMutableArray arrayWithArray:imageList];
    if (imageList.count <= 2) {
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(750));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(135), SCREEN_WIDTH, FitSizeH(170));
        }];
    }else if (imageList.count > 2 && imageList.count <= 5){
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(860));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(110)* 2, SCREEN_WIDTH, FitSizeH(170));
        }];
    }else{
        self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(970));
        [UIView animateWithDuration:0.24 animations:^{
            self.connectionView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + FitSizeH(110)* 3, SCREEN_WIDTH, FitSizeH(170));
        }];
    }
}

//AjaxUpload

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
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
