//
//  IssueViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/27.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "IssueViewController.h"
#import "FaBuHunLianViewController.h"
#import "FaBuRecruitmentViewController.h"
#import "FaBuHousekeepingViewController.h"
#import "RentHouseViewController.h"
#import "FaBuBuySellViewController.h"
#import "FaBuElesViewController.h"
#import "FaBuDatingViewController.h"
#import "UpLoadImageTestVC.h"


@interface IssueViewController ()
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * cancelBtn;

@end

@implementation IssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initNavigationView];
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

- (void)initNavigationView
{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"快捷发布" Color:[UIColor blackColor] Direction:NSTextAlignmentLeft];
    [self.navigationView addSubview: self.titleLabel];
}

- (void)initView{
    
    self.cancelBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(166), FitSizeH(602), FitSizeW(45), FitSizeH(45)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"quxiao" Target:self Action:@selector(click_back)];
    [self.view addSubview:self.cancelBtn];
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = CGRectGetMaxY(self.navigationView.frame) + FitSizeH(15);
    NSArray * titleArr = @[@"婚恋",@"招聘",@"家政",@"租房",@"买卖",@"相约",@"其他",@"测试"];
    NSArray * imageArr = @[@"hunlian",@"qiye",@"jiazheng",@"zufang",@"shangp",@"xiangyue",@"qita",@"hunlian"];
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton * fabuTypeBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(w, h, SCREEN_WIDTH / 4, FitSizeH(90)) Title:titleArr[i] Font:15 IsBold:NO TitleColor:RGBA(15, 15, 15, 1.0) TitleSelectColor:RGBA(15, 15, 15, 1.0) ImageName:imageArr[i] Target:self Action:@selector(click_fabuTypeBtn:)];
        CGFloat space = 20.0;
        [fabuTypeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop
                                      imageTitleSpace:space];
        if (fabuTypeBtn.frame.origin.x + fabuTypeBtn.frame.size.width > SCREEN_WIDTH) {
            w = 0; //换行时将w置为0
            h = h + fabuTypeBtn.frame.size.height + FitSizeH(10);
            fabuTypeBtn.frame = CGRectMake(w, h, SCREEN_WIDTH / 4, FitSizeH(90));
        }
        w = fabuTypeBtn.frame.size.width + fabuTypeBtn.frame.origin.x;
        fabuTypeBtn.tag = 1000 + i;
        [self.view addSubview:fabuTypeBtn];
    }
}

- (void)click_fabuTypeBtn:(UIButton *)sender
{
    NSInteger index = sender.tag;
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * versionStr = [userDefaultes stringForKey:@"versionStr"];
    if (index == 1000) {
        if (![versionStr isEqualToString:@"1.0"]) {
            LoginViewController *controller = [[LoginViewController alloc] init];
            controller.modalPresentationStyle = 0;
            [self presentViewController:controller animated:YES completion:nil];
            return;
        }
        FaBuHunLianViewController * navc = [[FaBuHunLianViewController alloc]init];
        UINavigationController *Navigationv = [[UINavigationController alloc] initWithRootViewController:navc];
        Navigationv.modalPresentationStyle = 0;
        [self presentViewController:Navigationv animated:YES completion:nil];
    }else if (index == 1001){
        if (![versionStr isEqualToString:@"1.0"]) {
            LoginViewController *controller = [[LoginViewController alloc] init];
            controller.modalPresentationStyle = 0;
            [self presentViewController:controller animated:YES completion:nil];
            return;
        }
        FaBuRecruitmentViewController * navc = [[FaBuRecruitmentViewController alloc]init];
        UINavigationController *Navigationv = [[UINavigationController alloc] initWithRootViewController:navc];
        Navigationv.modalPresentationStyle = 0;
        [self presentViewController:Navigationv animated:YES completion:nil];
    }else if (index == 1002){
        if (![versionStr isEqualToString:@"1.0"]) {
            LoginViewController *controller = [[LoginViewController alloc] init];
            controller.modalPresentationStyle = 0;
            [self presentViewController:controller animated:YES completion:nil];
            return;
        }
        FaBuHousekeepingViewController * navc = [[FaBuHousekeepingViewController alloc]init];
        UINavigationController *Navigationv = [[UINavigationController alloc] initWithRootViewController:navc];
        Navigationv.modalPresentationStyle = 0;
        [self presentViewController:Navigationv animated:YES completion:nil];
    }else if (index == 1003){
        if (![versionStr isEqualToString:@"1.0"]) {
            LoginViewController *controller = [[LoginViewController alloc] init];
            controller.modalPresentationStyle = 0;
            [self presentViewController:controller animated:YES completion:nil];
            return;
        }
        RentHouseViewController * navc = [[RentHouseViewController alloc]init];
        UINavigationController *Navigationv = [[UINavigationController alloc] initWithRootViewController:navc];
        Navigationv.modalPresentationStyle = 0;
        [self presentViewController:Navigationv animated:YES completion:nil];
    }else if (index == 1004){
        if (![versionStr isEqualToString:@"1.0"]) {
            LoginViewController *controller = [[LoginViewController alloc] init];
            controller.modalPresentationStyle = 0;
            [self presentViewController:controller animated:YES completion:nil];
            return;
        }
        FaBuBuySellViewController * navc = [[FaBuBuySellViewController alloc]init];
        UINavigationController *Navigationv = [[UINavigationController alloc] initWithRootViewController:navc];
        Navigationv.modalPresentationStyle = 0;
        [self presentViewController:Navigationv animated:YES completion:nil];
    }else if (index == 1005){
        if (![versionStr isEqualToString:@"1.0"]) {
            LoginViewController *controller = [[LoginViewController alloc] init];
            controller.modalPresentationStyle = 0;
            [self presentViewController:controller animated:YES completion:nil];
            return;
        }
        FaBuDatingViewController * navc = [[FaBuDatingViewController alloc]init];
        UINavigationController *Navigationv = [[UINavigationController alloc] initWithRootViewController:navc];
        Navigationv.modalPresentationStyle = 0;
        [self presentViewController:Navigationv animated:YES completion:nil];
    }else if (index == 1006){
        if (![versionStr isEqualToString:@"1.0"]) {
            LoginViewController *controller = [[LoginViewController alloc] init];
            controller.modalPresentationStyle = 0;
            [self presentViewController:controller animated:YES completion:nil];
            return;
        }
        FaBuElesViewController * navc = [[FaBuElesViewController alloc]init];
        UINavigationController *Navigationv = [[UINavigationController alloc] initWithRootViewController:navc];
        Navigationv.modalPresentationStyle = 0;
        [self presentViewController:Navigationv animated:YES completion:nil];
    }else {
        UpLoadImageTestVC * navc = [[UpLoadImageTestVC alloc]init];
        UINavigationController *Navigationv = [[UINavigationController alloc] initWithRootViewController:navc];
        Navigationv.modalPresentationStyle = 0;
        [self presentViewController:Navigationv animated:YES completion:nil];
    }
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
